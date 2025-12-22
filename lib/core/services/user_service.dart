import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:messenger/core/services/storage.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>?> fetch(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    return doc.data();
  }

  Future<void> create(String uid, String email, String? name) async {
    await _firestore.collection('users').doc(uid).set({
      'id': uid,
      'email': email,
      'name': name ?? '',
      'name_lowercase': name?.toLowerCase() ?? '',
      'photo_url': '',
      'is_online': true,
      'deleted': false,
      'last_seen': FieldValue.serverTimestamp(),
      'created_at': FieldValue.serverTimestamp(),
      'updated_at': FieldValue.serverTimestamp(),
    });
  }

  Future<void> update(String uid, Map<String, dynamic> newUserData) {
    final Map<String, dynamic> payload = Map.from(newUserData);

    if (payload.containsKey('name') && payload['name'] is String) {
      final name = payload['name'];
      payload['name_lowercase'] = name.toLowerCase();
    }

    payload['updated_at'] = FieldValue.serverTimestamp();

    return _firestore.collection('users').doc(uid).update(payload);
  }

  Future<void> delete(String uid) {
    return _firestore.collection('users').doc(uid).delete();
  }

  // -----------------------------
  // USER SEARCH / USER LIST
  // -----------------------------
  Stream<QuerySnapshot> getAllUsers() {
    return _firestore.collection('users').orderBy('name_lowercase').snapshots();
  }

  Stream<QuerySnapshot> getOnlineUsers() {
    return _firestore
        .collection('users')
        .where('is_online', isEqualTo: true)
        .snapshots();
  }

  Future<DocumentSnapshot> getUserById(String id) {
    return _firestore.collection('users').doc(id).get();
  }

  Stream<List<DocumentSnapshot>> getUsersByName(String name) {
    if (name.isEmpty) return Stream.value([]);

    final query = name.toLowerCase();
    return _firestore
        .collection('users')
        .orderBy('name_lowercase')
        .startAt([query])
        .endAt(['$query\uf8ff'])
        .snapshots()
        .map((snapshot) => snapshot.docs);
  }

  Future<void> updateProfilePicture(String uid, File file) async {
    if (uid == null) return;

    final photoUrl = await StorageService.instance.uploadProfilePicture(
      uid,
      file,
    );
    await _firestore.collection('users').doc(uid).update({
      'photo_url': photoUrl,
      'updated_at': FieldValue.serverTimestamp(),
    });
  }
}
