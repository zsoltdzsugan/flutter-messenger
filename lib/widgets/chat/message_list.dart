import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/chat_action_overlay_controller.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/widgets/chat/message_bubble.dart';

class MessageList extends StatefulWidget {
  final Stream<List<Message>> stream;
  final String conversationId;
  final String otherUserId;

  const MessageList({
    super.key,
    required this.stream,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  State<MessageList> createState() => _MessageListState();
}

class _MessageListState extends State<MessageList> {
  final ScrollController _scrollController = ScrollController();

  final List<Message> _messages = [];
  final Set<String> _messageIds = {}; // ← HARD dedupe

  late final StreamSubscription<List<Message>> _sub;

  DocumentSnapshot? _oldestDoc;
  bool _loadingMore = false;
  bool _initialJumpDone = false;
  bool _isAtBottom = true;

  @override
  void initState() {
    super.initState();

    _sub = widget.stream.listen(_onLatestMessages);
    _scrollController.addListener(() {
      ChatActionOverlayController.hide();
      _onScroll();
    });
  }

  void _onLatestMessages(List<Message> latest) {
    if (latest.isEmpty) return;

    bool added = false;

    for (final m in latest) {
      if (_messageIds.add(m.id)) {
        _messages.add(m);
        added = true;
      }
    }

    if (!added) return;

    _messages.sort((a, b) => a.timestamp.compareTo(b.timestamp));
    _oldestDoc ??= _messages.first.firestoreDoc;

    setState(() {});

    if (!_initialJumpDone) {
      _initialJumpDone = true;
      _jumpToBottom();
    } else if (_isAtBottom) {
      _jumpToBottom();
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;

    final pos = _scrollController.position;
    _isAtBottom = (pos.maxScrollExtent - pos.pixels) < 40;

    if (pos.pixels <= 80 && !_loadingMore && _oldestDoc != null) {
      _loadMore();
    }
  }

  Future<void> _loadMore() async {
    _loadingMore = true;

    final older = await ConversationController.instance.loadMore(
      widget.conversationId,
      lastDoc: _oldestDoc!,
    );

    if (older.isNotEmpty) {
      for (final m in older) {
        if (_messageIds.add(m.id)) {
          _messages.insert(0, m);
        }
      }

      _oldestDoc = _messages.first.firestoreDoc;
      setState(() {});
    }

    _loadingMore = false;
  }

  void _jumpToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _sub.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(12),
      itemCount: _messages.length,
      itemBuilder: (context, index) {
        final msg = _messages[index];
        final prev = index > 0 ? _messages[index - 1] : null;

        final isMe = msg.sender != widget.otherUserId;
        final grouped = prev != null && prev.sender == msg.sender;

        return MessageBubble(
          message: msg,
          isMe: isMe,
          otherUserId: widget.otherUserId,
          showAvatar: !grouped,
        );
      },
    );
  }
}
