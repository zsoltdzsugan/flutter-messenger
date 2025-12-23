import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/controller/session.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/widgets/chat/message_bubble.dart';

class MessageContainer extends StatefulWidget {
  final String conversationId;
  final String otherUserId;

  const MessageContainer({
    super.key,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  State<MessageContainer> createState() => _MessageContainerState();
}

class _MessageContainerState extends State<MessageContainer> {
  final ScrollController _scrollController = ScrollController();

  StreamSubscription<QuerySnapshot<Map<String, dynamic>>>? _sub;

  // Latest N messages (live stream)
  List<Message> _latest = const [];

  // Older pages fetched via .get()
  final List<Message> _older = [];

  QueryDocumentSnapshot<Map<String, dynamic>>? _oldestDoc;
  bool _isLoadingOlder = false;
  bool _hasMore = true;

  static const int _pageSize = 30;

  final Map<String, GlobalKey> _keys = {};
  QueryDocumentSnapshot<Map<String, dynamic>>? _cursor;

  @override
  void initState() {
    super.initState();

    _listenLatest();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant MessageContainer oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.conversationId != widget.conversationId) {
      _resetAndRelisten();
    }
  }

  void _resetAndRelisten() {
    _sub?.cancel();
    _latest = const [];
    _older.clear();
    _oldestDoc = null;
    _isLoadingOlder = false;
    _hasMore = true;
    _keys.clear();
    _cursor = null;

    setState(() {});
    _listenLatest();
  }

  void _listenLatest() {
    final stream = ConversationController.instance.streamMessageSnapshots(
      widget.conversationId,
      limit: _pageSize,
    );

    _sub = stream.listen((snap) {
      final wasAtBottom = _isAtBottom();

      final msgs = snap.docs
          .map((d) => Message.fromFirestore(d))
          .toList(); // query is DESC, so list is DESC
      if (_oldestDoc == null && snap.docs.isNotEmpty) {
        _oldestDoc = snap.docs.last; // oldest among latest
      }

      _cursor ??= snap.docs.isNotEmpty ? snap.docs.last : null;

      setState(() {
        _latest = msgs;
      });

      // If user was at bottom, keep them at bottom when new messages arrive
      if (wasAtBottom) {
        _scrollToBottomAfterLayout();
      }
    });
    SessionController.instance.register(_sub!);
  }

  bool _isAtBottom() {
    if (!_scrollController.hasClients) return true;
    // reverse:true => bottom (newest) is offset ~ 0
    return _scrollController.offset != 0;
  }

  void _scrollToBottomAfterLayout() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      // Wait ONE MORE frame for images/placeholders to settle
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!_scrollController.hasClients) return;

        _scrollController.animateTo(
          0,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
        );
      });
    });
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    if (_isLoadingOlder || !_hasMore) return;

    // reverse:true => "scroll up to older" means moving toward maxScrollExtent
    final pos = _scrollController.position;
    final nearTopOfHistory = pos.pixels >= pos.maxScrollExtent - 200;
    if (nearTopOfHistory) {
      _loadOlder();
    }
  }

  Future<void> _loadOlder() async {
    if (_cursor == null || _isLoadingOlder || !_hasMore) return;

    _isLoadingOlder = true;

    final anchorId = _findAnchorMessageId();

    final snap = await ConversationController.instance.loadMoreSnapshots(
      widget.conversationId,
      lastDoc: _cursor!,
      limit: _pageSize,
    );

    if (snap.docs.isEmpty) {
      _hasMore = false;
      _isLoadingOlder = false;
      return;
    }

    _cursor = snap.docs.last;

    final olderMsgs = snap.docs
        .map((d) => Message.fromFirestore(d))
        .toList(); // DESC

    setState(() {
      _older.addAll(olderMsgs);
    });

    // Restore anchor AFTER layout
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (anchorId != null) {
        await _ensureVisible(anchorId);
      }
      _isLoadingOlder = false;
    });

    if (snap.docs.length < _pageSize) {
      _hasMore = false;
    }
  }

  List<Message> get _mergedMessages {
    // Merge stream + older pages, dedupe by id, keep DESC order by timestamp
    final map = <String, Message>{};

    for (final m in _latest) {
      map[m.id] = m;
    }
    for (final m in _older) {
      map[m.id] = m;
    }

    final list = map.values.toList();

    // DESC: newest first
    list.sort((a, b) => b.timestamp.compareTo(a.timestamp));
    return list;
  }

  Future<void> _ensureVisible(String id) async {
    final key = _keys[id];
    final ctx = key?.currentContext;
    if (ctx == null) return;

    await Scrollable.ensureVisible(
      ctx,
      alignment: 0.5,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
    );
  }

  String? _findAnchorMessageId() {
    for (final entry in _keys.entries) {
      final ctx = entry.value.currentContext;
      if (ctx == null) continue;

      final box = ctx.findRenderObject() as RenderBox?;
      if (box == null || !box.attached) continue;

      final pos = box.localToGlobal(Offset.zero);
      if (pos.dy >= 0) {
        return entry.key;
      }
    }
    return null;
  }

  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final messages = _mergedMessages;

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        return ListView.builder(
          controller: _scrollController,
          reverse: true, // crucial for sane chat behavior
          itemCount: messages.length + 1,
          itemBuilder: (context, index) {
            // Optional top loader row (appears when user scrolls up)
            if (index == messages.length) {
              if (!_hasMore) return const SizedBox(height: 24);
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Center(
                  child: _isLoadingOlder
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const SizedBox(height: 18),
                ),
              );
            }

            final m = messages[index];
            final isMe = m.sender != widget.otherUserId;
            final key = _keys.putIfAbsent(m.id, () => GlobalKey());
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              key: key,
              child: MessageBubble(
                message: m,
                isMe: isMe,
                otherUserId: widget.otherUserId,
                onOpenMenu: () => _ensureVisible(m.id),
                constraints: constraints,
              ),
            );
          },
        );
      },
    );
  }
}
