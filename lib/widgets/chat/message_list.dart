import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/controller/session.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/widgets/chat/message_bubble.dart';

class MessageList extends StatefulWidget {
  final String conversationId;
  final String otherUserId;

  const MessageList({
    super.key,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  final Map<String, Message> _byId = {};
  final Map<String, GlobalKey> _keys = {};

  List<Message> _ordered = [];

  QueryDocumentSnapshot<Map<String, dynamic>>? _cursor;
  bool _fetchingOlder = false;
  bool _hasMore = true;
  bool _didInitialScroll = false;
  bool _didFinalMediaScroll = false;

  StreamSubscription? _sub;

  static const int _pageSize = 30;

  bool get isNearBottom {
    if (!_scrollController.hasClients) return false;
    final position = _scrollController.position;
    return position.maxScrollExtent - position.pixels < 20;
  }

  @override
  void initState() {
    super.initState();
    _listenLive();
    _scrollController.addListener(_onScroll);
  }

  @override
  void didUpdateWidget(covariant MessageList oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.conversationId != widget.conversationId) {
      _sub?.cancel();
      _byId.clear();
      _keys.clear();
      _ordered = [];
      _cursor = null;
      _hasMore = true;
      _fetchingOlder = false;

      _didInitialScroll = false;
      _didFinalMediaScroll = false;

      _listenLive();
    }
  }

  // ─────────────────────────────────────────────
  // LIVE STREAM (LATEST MESSAGES ONLY)
  // ─────────────────────────────────────────────
  void _listenLive() {
    _sub = ConversationController.instance
        .streamMessageSnapshots(widget.conversationId, limit: _pageSize)
        .listen(_onLiveSnapshot);
    SessionController.instance.register(_sub!);
  }

  void _onLiveSnapshot(QuerySnapshot<Map<String, dynamic>> snap) {
    bool addedNew = false;

    for (final change in snap.docChanges) {
      final doc = change.doc;
      final msg = Message.fromFirestore(doc);

      if (change.type == DocumentChangeType.added ||
          change.type == DocumentChangeType.modified) {
        final isNew = !_byId.containsKey(msg.id);
        _byId[msg.id] = msg;
        if (isNew) addedNew = true;
      }
    }

    // initialize cursor ONCE
    _cursor ??= snap.docs.isNotEmpty ? snap.docs.last : null;

    _rebuild();

    if (!mounted) return;
    setState(() {});

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (!_scrollController.hasClients) return;

      // First layout pass
      if (!_didInitialScroll) {
        scrollToBottom();
        _didInitialScroll = true;

        // wait for next frame (images start resolving sizes)
        await WidgetsBinding.instance.endOfFrame;
      }

      // Second pass — after images/gifs expand
      if (!_didFinalMediaScroll) {
        _didFinalMediaScroll = true;
        scrollToBottom();
        return;
      }

      // Normal behavior for new messages
      if (addedNew && _isNearBottom()) {
        scrollToBottom();
      }
    });
  }

  // ─────────────────────────────────────────────
  // PAGINATION (OLDER MESSAGES)
  // ─────────────────────────────────────────────
  void _onScroll() {
    if (!_hasMore || _fetchingOlder) return;
    if (_scrollController.position.pixels > 80) return;

    _fetchOlder();
  }

  Future<void> _fetchOlder() async {
    if (_cursor == null) return;

    _fetchingOlder = true;

    final beforeOffset = _scrollController.position.pixels;
    final beforeMax = _scrollController.position.maxScrollExtent;

    final snap = await ConversationController.instance.loadMoreSnapshots(
      widget.conversationId,
      lastDoc: _cursor!,
      limit: _pageSize,
    );

    if (snap.docs.isEmpty) {
      _hasMore = false;
      _fetchingOlder = false;
      return;
    }

    for (final doc in snap.docs) {
      final msg = Message.fromFirestore(doc);
      _byId[msg.id] = msg;
    }

    _cursor = snap.docs.last;
    _rebuild();

    if (!mounted) return;
    setState(() {});

    // preserve scroll position
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final afterMax = _scrollController.position.maxScrollExtent;
      final delta = afterMax - beforeMax;
      _scrollController.jumpTo(beforeOffset + delta);
    });

    _fetchingOlder = false;
  }

  // ─────────────────────────────────────────────
  // HELPERS
  // ─────────────────────────────────────────────
  void _rebuild() {
    _ordered = _byId.values.toList()
      ..sort((a, b) => a.timestamp.compareTo(b.timestamp));
  }

  bool _isNearBottom() {
    if (!_scrollController.hasClients) return false;
    final pos = _scrollController.position;
    return (pos.maxScrollExtent - pos.pixels) < 60;
  }

  void scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!_scrollController.hasClients) return;

      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      );
    });
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

  // ─────────────────────────────────────────────
  // LIFECYCLE
  // ─────────────────────────────────────────────
  @override
  void dispose() {
    _sub?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // UI
  // ─────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _ordered.length,
      itemBuilder: (context, index) {
        final msg = _ordered[index];

        final isMe = msg.sender != widget.otherUserId;
        final key = _keys.putIfAbsent(msg.id, () => GlobalKey());

        return Container(
          key: key,
          child: MessageBubble(
            message: msg,
            isMe: isMe,
            otherUserId: widget.otherUserId,
            onOpenMenu: () => _ensureVisible(msg.id),
          ),
        );
      },
    );
  }
}
