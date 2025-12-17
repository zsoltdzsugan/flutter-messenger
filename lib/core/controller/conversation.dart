import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/core/services/conversation.dart';
import 'package:messenger/core/services/storage.dart';

class ConversationController {
  ConversationController._();
  static final instance = ConversationController._();

  final _auth = FirebaseAuth.instance;
  final _conv = ConversationService();
  final _storage = StorageService();

  User get _user => _auth.currentUser!;

  // ─────────────────────────────────────────────
  // SEND
  // ─────────────────────────────────────────────

  Future<void> send(
    String conversationId, {
    required MessageType type,
    String text = '',
    List<File> files = const [],
    Gif? gif,
  }) {
    switch (type) {
      case MessageType.text:
        return _sendText(conversationId, text);

      case MessageType.image:
        if (files.isEmpty) return Future.value();
        return _sendImages(conversationId, files);

      case MessageType.gif:
        if (gif == null) return Future.value();
        return _sendGif(conversationId, gif);

      case MessageType.sticker:
        if (gif == null) return Future.value();
        return _sendSticker(conversationId, gif);

      default:
        throw UnimplementedError();
    }
  }

  Future<void> _sendText(String conversationId, String text) async {
    if (text.isEmpty) return Future.value();

    return _sendMessage(conversationId, type: MessageType.text, text: text);
  }

  Future<void> _sendGif(String conversationId, Gif gif) async {
    if (gif.url.isEmpty) return;

    return _sendMessage(
      conversationId,
      type: MessageType.gif,
      extra: {
        'media': {'url': gif.url, 'preview_url': gif.previewUrl},
      },
    );
  }

  Future<void> _sendSticker(String conversationId, Gif sticker) async {
    if (sticker.url.isEmpty) return;

    return _sendMessage(
      conversationId,
      type: MessageType.sticker,
      extra: {
        'media': {'url': sticker.url, 'preview_url': sticker.previewUrl},
      },
    );
  }

  Future<void> _sendImages(String conversationId, List<File> files) async {
    if (files.isEmpty) return;

    final List<UploadedMedia> uploads = [];

    try {
      for (final file in files) {
        debugPrint('Uploading ${file.path}');
        final img = await _storage.uploadImage(file);
        uploads.add(img);
      }
    } catch (e, st) {
      debugPrint('❌ Image upload failed: $e');
      debugPrintStack(stackTrace: st);
      return;
    }

    if (uploads.isEmpty) return;

    final images = uploads
        .map(
          (img) => {'url': img.url, 'width': img.width, 'height': img.height},
        )
        .toList();

    await _sendMessage(
      conversationId,
      type: MessageType.image,
      extra: {'images': images},
    );
  }

  Future<void> _sendMessage(
    String conversationId, {
    required MessageType type,
    String text = '',
    Map<String, Object?>? extra,
  }) async {
    final uid = _user.uid;

    final Map<String, Object?> payload = {
      'sender': uid,
      'type': type.name,
      'text': text,
      'read_by': [uid],
      'timestamp': FieldValue.serverTimestamp(),
      'created_at': FieldValue.serverTimestamp(),
    };

    if (extra != null) payload.addAll(extra);

    await _conv.addMessage(conversationId, payload);

    await _conv.updateConversation(conversationId, {
      'last_message': type == MessageType.text ? text : '[${type.name}]',
      'last_message_timestamp': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // ─────────────────────────────────────────────
  // STREAM + PAGINATION
  // ─────────────────────────────────────────────

  Stream<List<Message>> streamMessages(String conversationId) {
    return _conv.streamLatestMessages(conversationId);
  }

  Future<List<Message>> loadMore(
    String conversationId, {
    required DocumentSnapshot lastDoc,
    int limit = 30,
  }) {
    return _conv.fetchOlderMessages(
      conversationId,
      limit: limit,
      lastDoc: lastDoc,
    );
  }

  // ─────────────────────────────────────────────
  // META
  // ─────────────────────────────────────────────

  Future<void> markConversationRead(String conversationId) async {
    await _conv.updateConversation(conversationId, {
      'read_by': FieldValue.arrayUnion([_user.uid]),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> setTyping(String conversationId, bool isTyping) {
    return _conv.setTyping(conversationId, _user.uid, isTyping);
  }

  // ─────────────────────────────────────────────
  // SIDEBAR SUPPORT
  // ─────────────────────────────────────────────

  Future<DocumentReference> getConversation(String otherUserId) async {
    final uid = _user.uid;

    // Find all convos where I'm a participant
    final existing = await _conv.findUserConversations(uid);

    // Return the first convo that also contains the other user
    for (final doc in existing) {
      final participants = List<String>.from(doc['participants'] as List);
      if (participants.contains(otherUserId)) {
        return doc.reference;
      }
    }

    // Otherwise create a new one
    return _conv.createConversation([uid, otherUserId]);
  }

  Stream<List<DocumentSnapshot>> getUserConversations() {
    return _conv.getUserConversations(_user.uid);
  }
}
