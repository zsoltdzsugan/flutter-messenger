import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/core/models/message.dart';

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

  Future<void> addMessage(String conversationId, Map<String, dynamic> message) {
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
