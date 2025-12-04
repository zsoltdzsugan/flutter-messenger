import 'package:cloud_firestore/cloud_firestore.dart';

class ConversationService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Creates a new conversation doc
  Future<DocumentReference> createConversation(List<String> participants) {
    participants.sort();

    return _firestore.collection('conversations').add({
      'participants': participants,
      'last_message': '',
      'last_message_timestamp': '',
      'unread_by': participants.skip(1).toList(),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  // Loads all conversations for a user
  Stream<List<DocumentSnapshot>> getUserConversations(String uid) {
    return _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .orderBy('last_message_timestamp', descending: true)
        .snapshots()
        .map((s) => s.docs);
  }

  // Searches for an existing conversation
  Future<List<DocumentSnapshot>> findUserConversations(String uid) async {
    final snap = await _firestore
        .collection('conversations')
        .where('participants', arrayContains: uid)
        .get();
    return snap.docs;
  }

  // Send message
  Future<void> sendMessage(
    String conversationId,
    Map<String, dynamic> message,
  ) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .add(message);
  }

  // Update conversation metadata
  Future<void> updateConversation(
    String conversationId,
    Map<String, dynamic> data,
  ) {
    return _firestore
        .collection('conversations')
        .doc(conversationId)
        .update(data);
  }

  // Fetch unread messages for marking read
  Future<List<DocumentSnapshot>> getUnreadMessages(
    String conversationId,
    String uid,
  ) async {
    final snap = await _firestore
        .collection('conversations')
        .doc(conversationId)
        .collection('messages')
        .where('unread_by', arrayContains: uid)
        .get();
    return snap.docs;
  }

  // Update multiple messages in batch
  Future<void> applyBatchWrite(WriteBatch batch) => batch.commit();
}
