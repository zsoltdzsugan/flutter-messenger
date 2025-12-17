import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  final String id;
  final List<String> participants;
  final String lastMessage;
  final DateTime? lastMessageTimestamp;
  final List<String> readBy;

  Conversation({
    required this.id,
    required this.participants,
    required this.lastMessage,
    required this.lastMessageTimestamp,
    required this.readBy,
  });

  factory Conversation.fromFirestore(DocumentSnapshot doc) {
    final data = (doc.data() as Map<String, dynamic>?) ?? {};

    final ts = data['last_message_timestamp'];
    final lastTs = (ts is Timestamp) ? ts.toDate() : null;

    return Conversation(
      id: doc.id,
      participants: List<String>.from(data['participants'] ?? const <String>[]),
      lastMessage: (data['last_message'] as String?) ?? '',
      lastMessageTimestamp: lastTs,
      readBy: List<String>.from(data['read_by'] ?? const <String>[]),
    );
  }
}
