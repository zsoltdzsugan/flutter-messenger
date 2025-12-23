import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class BugReportService {
  static final _db = FirebaseFirestore.instance;
  static final _auth = FirebaseAuth.instance;

  static Future<DocumentReference> submit(String text) async {
    final user = _auth.currentUser;

    if (user == null) {
      throw Exception('No authenticated user');
    }

    return await _db.collection('bug_reports').add({
      'user_id': user.uid,
      'text': text,
      'created_at': FieldValue.serverTimestamp(),
      'resolved': false,
    });
  }
}
