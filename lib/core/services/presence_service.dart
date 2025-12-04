import 'package:cloud_firestore/cloud_firestore.dart';

class PresenceService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateOnline(String uid, bool value) {
    return _firestore.collection('users').doc(uid).update({
      'is_online': value,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> updateLastSeen(String uid) {
    return _firestore.collection('users').doc(uid).update({
      'last_seen': FieldValue.serverTimestamp(),
    });
  }
}
