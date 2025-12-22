import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:image_gallery_saver_plus/image_gallery_saver_plus.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/message.dart';
import 'package:path_provider/path_provider.dart';

class ConversationService {
  final _db = FirebaseFirestore.instance;

  CollectionReference<Map<String, dynamic>> _messages(String cid) =>
      _db.collection('conversations').doc(cid).collection('messages');

  // ─────────────────────────────────────────────
  // CONVERSATIONS
  // ─────────────────────────────────────────────

  Future<DocumentReference> createConversation(List<String> participants) {
    participants.sort();

    return _db.collection('conversations').add({
      'participants': participants,
      'last_message': '',
      'last_message_timestamp': null,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<DocumentSnapshot> getConversation(String conversationId) {
    return _db.collection('conversations').doc(conversationId).get();
  }

  Stream<List<DocumentSnapshot>> getUserConversations(String uid) {
    return _db
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('last_message_timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs);
  }

  Future<List<DocumentSnapshot>> findUserConversations(String uid) async {
    final snap = await _db
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .get();

    return snap.docs;
  }

  Future<void> updateConversation(
    String conversationId,
    Map<String, dynamic> data,
  ) {
    return _db.collection('conversations').doc(conversationId).update(data);
  }

  // ─────────────────────────────────────────────
  // MESSAGES
  // ─────────────────────────────────────────────
  Stream<QuerySnapshot<Map<String, dynamic>>> streamMessageSnapshots(
    String conversationId, {
    int limit = 30,
  }) {
    return _messages(conversationId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots(includeMetadataChanges: false);
  }

  Future<DocumentReference<Map<String, dynamic>>> addMessage(
    String conversationId,
    Map<String, dynamic> message,
  ) {
    return _messages(conversationId).add(message);
  }

  /// Live stream (latest messages only)
  Stream<List<Message>> streamLatestMessages(
    String conversationId, {
    int limit = 30,
  }) {
    return _messages(conversationId)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots()
        .map((s) => s.docs.map(Message.fromFirestore).toList());
  }

  /// Pagination: fetch older messages
  Future<List<Message>> fetchOlderMessages(
    String conversationId, {
    required DocumentSnapshot lastDoc,
    int limit = 30,
  }) async {
    final snap = await _messages(conversationId)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();

    return snap.docs.map(Message.fromFirestore).toList();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> fetchOlderMessageSnapshots(
    String cid, {
    required QueryDocumentSnapshot<Map<String, dynamic>> lastDoc,
    int limit = 30,
  }) {
    return _messages(cid)
        .orderBy('timestamp', descending: true)
        .startAfterDocument(lastDoc)
        .limit(limit)
        .get();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> streamConversationImages(
    String conversationId, {
    int limit = 30,
  }) {
    return _messages(conversationId)
        .where('type', isEqualTo: MessageType.image.name)
        .orderBy('timestamp', descending: true)
        .limit(limit)
        .snapshots(includeMetadataChanges: false);
  }

  Future<void> deleteMessage(Message message) async {
    await _db
        .collection('conversations')
        .doc(message.conversationId)
        .collection('messages')
        .doc(message.id)
        .update({'deleted': true, 'deleted_at': FieldValue.serverTimestamp()});
  }

  Future<void> saveImages(Message message) async {
    if (message.type != MessageType.image) return;

    for (final img in message.images) {
      if (kIsWeb) {
        // Web: let browser handle it
        continue;
      }

      final response = await http.get(Uri.parse(img.url));
      if (response.statusCode != 200) continue;

      final Uint8List bytes = response.bodyBytes;
      final fileName = 'messenger_${DateTime.now().millisecondsSinceEpoch}.jpg';

      if (Platform.isAndroid || Platform.isIOS) {
        // Mobile → gallery
        await ImageGallerySaverPlus.saveImage(
          bytes,
          quality: 100,
          name: fileName,
        );
      } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
        // Desktop → Downloads folder
        final dir = await getDownloadsDirectory();
        if (dir == null) return;

        final file = File('${dir.path}/$fileName');
        await file.writeAsBytes(bytes);
      }
    }
  }

  Future<void> saveImageByUrl(String url) async {
    if (url.isEmpty) return;

    if (kIsWeb) return;

    final response = await http.get(Uri.parse(url));
    if (response.statusCode != 200) return;

    final Uint8List bytes = response.bodyBytes;
    final fileName = 'messenger_${DateTime.now().millisecondsSinceEpoch}.jpg';

    if (Platform.isAndroid || Platform.isIOS) {
      // Mobile → gallery
      await ImageGallerySaverPlus.saveImage(
        bytes,
        quality: 100,
        name: fileName,
      );
    } else if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      // Desktop → Downloads folder
      final dir = await getDownloadsDirectory();
      if (dir == null) return;

      final file = File('${dir.path}/$fileName');
      await file.writeAsBytes(bytes);
    }
  }

  Future<void> copyMessage(Message message) async {
    Clipboard.setData(ClipboardData(text: message.text));
  }

  // ─────────────────────────────────────────────
  // TYPING
  // ─────────────────────────────────────────────

  Future<void> setTyping(String conversationId, String uid, bool isTyping) {
    return _db.collection('conversations').doc(conversationId).update({
      'typing.$uid': isTyping
          ? FieldValue.serverTimestamp()
          : FieldValue.delete(),
    });
  }
}
