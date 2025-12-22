import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/core/models/message.dart';
import 'package:messenger/core/services/conversation.dart';
import 'package:messenger/core/services/storage.dart';
import 'package:messenger/core/utils/chat_image.dart';

class ConversationController {
  ConversationController._();
  static final instance = ConversationController._();

  final _auth = FirebaseAuth.instance;
  final _conv = ConversationService();
  final _storage = StorageService.instance;

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
        'media': {
          'url': gif.url,
          'preview_url': gif.previewUrl,
          'provider': gif.provider.name,
        },
      },
    );
  }

  Future<void> _sendSticker(String conversationId, Gif sticker) async {
    if (sticker.url.isEmpty) return;

    return _sendMessage(
      conversationId,
      type: MessageType.sticker,
      extra: {
        'media': {
          'url': sticker.url,
          'preview_url': sticker.previewUrl,
          'provider': GifProvider.giphy.name,
        },
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
      debugPrint('Image upload failed: $e');
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

    final msgRef = await _conv.addMessage(conversationId, payload);
    final msgId = msgRef.id;

    final conversation = await _conv.getConversation(conversationId);
    final data = conversation.data() as Map<String, dynamic>;
    final participants = List<String>.from(
      data['participants'] ?? const <String>[],
    );

    final updates = {
      'last_message': type == MessageType.text ? text : '[${type.name}]',
      'last_message_id': msgId,
      'last_message_sender': uid,
      'last_message_timestamp': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
      'last_read_at': {uid: FieldValue.serverTimestamp()},
    };

    for (final pid in participants) {
      if (pid == uid) {
        updates['unread_count.$pid'] = 0;
      } else {
        updates['unread_count.$pid'] = FieldValue.increment(1);
      }
    }

    await _conv.updateConversation(conversationId, updates);
  }

  // ─────────────────────────────────────────────
  // STREAM + PAGINATION
  // ─────────────────────────────────────────────

  Stream<List<Message>> streamMessages(String conversationId) {
    return _conv.streamLatestMessages(conversationId);
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessageSnapshots(
    String conversationId, {
    int limit = 30,
  }) {
    return _conv.streamMessageSnapshots(conversationId, limit: limit);
  }

  Future<QuerySnapshot<Map<String, dynamic>>> loadMoreSnapshots(
    String cid, {
    required QueryDocumentSnapshot<Map<String, dynamic>> lastDoc,
    int limit = 30,
  }) {
    return _conv.fetchOlderMessageSnapshots(
      cid,
      lastDoc: lastDoc,
      limit: limit,
    );
  }

  Stream<List<ChatImage>> streamConversationImages(String conversationId) {
    return _conv.streamConversationImages(conversationId).map((snap) {
      final List<ChatImage> images = [];
      for (final doc in snap.docs) {
        final data = doc.data();
        print(doc.data());
        final List imgs = data['images'] ?? [];

        for (final img in imgs) {
          images.add(
            ChatImage(
              url: img['url'],
              width: (img['width'] as num?)!.toDouble(),
              height: (img['height'] as num?)!.toDouble(),
              messageId: doc.id,
            ),
          );
        }
      }

      return images;
    });
  }

  // ─────────────────────────────────────────────
  // META
  // ─────────────────────────────────────────────

  Future<void> markConversationAsRead(String conversationId) async {
    final uid = _user.uid;
    final firestore = FirebaseFirestore.instance;

    final messagesRef = firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');

    final snap = await messagesRef.where('sender', isNotEqualTo: uid).get();

    if (snap.docs.isEmpty) return;

    final batch = firestore.batch();
    bool hasUpdates = false;

    for (final doc in snap.docs) {
      final data = doc.data();

      final List<dynamic> readBy =
          (data['read_by'] as List<dynamic>?) ?? const [];

      if (!readBy.contains(uid)) {
        batch.update(doc.reference, {
          'read_by': FieldValue.arrayUnion([uid]),
        });
        hasUpdates = true;
      }
    }

    if (!hasUpdates) return;

    batch.update(firestore.collection('conversations').doc(conversationId), {
      'unread_count.$uid': 0,
      'updated_at': FieldValue.serverTimestamp(),
    });

    await batch.commit();
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

  // ─────────────────────────────────────────────
  // CHAT MESSAGE HELPER
  // ─────────────────────────────────────────────

  Future<void> deleteMessage(Message message) async {
    await _conv.deleteMessage(message);
    final conversation = await _conv.getConversation(message.conversationId);
    final data = conversation.data() as Map<String, dynamic>;

    if (data['last_message_id'] == message.id) {
      await _conv.updateConversation(message.conversationId, {
        'last_message': 'Üzenet törölve',
        'updated_at': FieldValue.serverTimestamp(),
        'last_message_timestamp': FieldValue.serverTimestamp(),
      });
    }
  }

  Future<void> saveImage(Message message) async {
    if (message.type != MessageType.image) return;
    await _conv.saveImages(message);
  }

  Future<void> saveImageByUrl(String url) async {
    await _conv.saveImageByUrl(url);
  }

  Future<void> forwardMessage(Message message, String toUserId) async {
    final convRef = await getConversation(toUserId);
    final conversationId = convRef.id;

    switch (message.type) {
      case MessageType.text:
        await send(conversationId, type: MessageType.text, text: message.text);
        break;

      case MessageType.image:
        if (message.images.isEmpty) return;

        await _sendMessage(
          conversationId,
          type: MessageType.image,
          extra: {
            'images': message.images
                .map(
                  (i) => {'url': i.url, 'width': i.width, 'height': i.height},
                )
                .toList(),
          },
        );
        break;

      case MessageType.gif:
      case MessageType.sticker:
        await send(
          conversationId,
          type: message.type,
          gif: Gif(
            url: message.mediaUrl,
            previewUrl: message.previewUrl,
            width: message.width ?? 128,
            height: message.height ?? 128,
            provider: message.type == MessageType.sticker
                ? GifProvider.giphy
                : (message.provider ?? GifProvider.tenor),
          ),
        );
        break;

      default:
        throw UnsupportedError('Forward not supported for ${message.type}');
    }
  }

  Future<void> forwardImage(ChatImage image, String toUserId) async {
    final convRef = await getConversation(toUserId);
    await _sendMessage(
      convRef.id,
      type: MessageType.image,
      extra: {
        'images': [
          {'url': image.url, 'width': image.width, 'height': image.height},
        ],
      },
    );
  }

  Future<void> copyMessage(Message message) async {
    if (message.type != MessageType.text) return;
    await _conv.copyMessage(message);
  }
}
