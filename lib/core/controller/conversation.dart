import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:messenger/core/services/conversation.dart';

class ConversationController {
  ConversationController._privateConstructor();
  static final ConversationController instance =
      ConversationController._privateConstructor();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final ConversationService _conv = ConversationService();

  User? get currentUser => _auth.currentUser;

  // -----------------------------
  // CONVERSATIONS
  // -----------------------------

  Future<DocumentReference> getConversation(String otherUserId) async {
    final uid = currentUser!.uid;

    final existing = await _conv.findUserConversations(uid);

    for (final doc in existing) {
      final participants = List<String>.from(doc['participants']);
      if (participants.contains(otherUserId)) {
        return doc.reference;
      }
    }

    return _conv.createConversation([uid, otherUserId]);
  }

  Stream<List<DocumentSnapshot>> getUserConversations() {
    final uid = currentUser!.uid;
    return _conv.getUserConversations(uid);
  }

  Future<DocumentReference?> loadLatestConversation() async {
    final uid = currentUser!.uid;

    final docs = await _conv.findUserConversations(uid);
    if (docs.isEmpty) return null;

    docs.sort((a, b) {
      final at = a['last_message_timestamp'] ?? 0;
      final bt = b['last_message_timestamp'] ?? 0;
      return bt.compareTo(at);
    });

    return docs.first.reference;
  }

  // -----------------------------
  // MESSAGES
  // -----------------------------

  Future<void> sendMessage(
    String conversationId,
    String text, {
    String type = 'text',
    String? gifUrl,
    String? fileUrl,
    String? previewUrl,
  }) async {
    final uid = currentUser!.uid;

    final messageData = {
      'sender': uid,
      'text': text,
      'type': type, // text | image | gif | file
      'gif_url': gifUrl ?? '',
      'file_url': fileUrl ?? '',
      'preview_url': previewUrl ?? '',
      'unread_by': [],
      'timestamp': FieldValue.serverTimestamp(),
      'width': 480,
      'height': 270,
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    };

    await _conv.sendMessage(conversationId, messageData);

    await _conv.updateConversation(conversationId, {
      'last_message': text,
      'last_message_timestamp': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> markMessagesAsRead(String conversationId) async {
    final uid = currentUser!.uid;

    final unread = await _conv.getUnreadMessages(conversationId, uid);

    final batch = FirebaseFirestore.instance.batch();

    for (final msg in unread) {
      batch.update(msg.reference, {
        'unread_by': FieldValue.arrayRemove([uid]),
      });
    }

    batch.update(
      FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId),
      {
        'unread_by': FieldValue.arrayRemove([uid]),
      },
    );

    await _conv.applyBatchWrite(batch);
  }
}
