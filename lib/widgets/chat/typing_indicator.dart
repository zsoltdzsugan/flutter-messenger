import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TypingIndicator extends StatelessWidget {
  final String conversationId;

  const TypingIndicator({super.key, required this.conversationId});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('conversations')
          .doc(conversationId)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;

        if (data == null || data['typing'] == null) {
          return const SizedBox.shrink();
        }

        final typing = Map<String, dynamic>.from(data['typing']);
        typing.removeWhere((_, v) => v != true);

        if (typing.isEmpty) return const SizedBox.shrink();

        return Padding(
          padding: const EdgeInsets.only(left: 12, bottom: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Ír…',
              style: TextStyle(fontSize: 12, color: Colors.grey.shade400),
            ),
          ),
        );
      },
    );
  }
}
