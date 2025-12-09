import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/services/auth_service.dart';
import 'package:messenger/core/services/presence_service.dart';
import 'package:messenger/core/services/user_service.dart';
import 'package:messenger/core/utils/app_error.dart';

class UserController {
  UserController._privateController();
  static final UserController instance = UserController._privateController();

  final AuthService _auth = AuthService();
  final UserService _user = UserService();
  final PresenceService _presence = PresenceService();

  final ValueNotifier<Map<String, dynamic>?> userData = ValueNotifier(null);

  Map<String, dynamic>? get currentUserData => userData.value;

  User? get currentUser => _auth.currentUser;

  Future<void> getCurrentUserData() async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    final data = await _user.fetch(uid);
    userData.value = data;
  }

  Future<User?> register({
    required String email,
    required String password,
    String? name,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      throw AppError(
        'missing-fields',
        'Adj meg egy email-címet és egy jelszót!',
      );
    }

    try {
      final user = await _auth.register(email, password);
      if (user == null) return null;

      await _user.create(user.uid, email, name);
      await getCurrentUserData();
      return user;
    } on FirebaseAuthException catch (e) {
      throw AppError(e.code, AppError.firebaseAuthMessage(e.code));
    }
  }

  Future<void> login(String email, String password) async {
    if (email.isEmpty || password.isEmpty) {
      throw AppError('missing-fields', 'Add meg az email-címet és a jelszót!');
    }

    final user = await _auth.login(email, password);
    if (user == null) return;

    await _presence.updateOnline(user.uid, true);
    await _presence.updateLastSeen(user.uid);
    await getCurrentUserData();
  }

  Future<void> logout() async {
    final uid = currentUser?.uid;
    if (uid != null) {
      await _presence.updateOnline(uid, false);
      await _presence.updateLastSeen(uid);
    }

    userData.value = null;
    await _auth.logout();
  }

  Future<void> update(Map<String, dynamic> newUserData) async {
    final uid = currentUser?.uid;
    if (uid == null) return;

    await _user.update(uid, newUserData);
    await getCurrentUserData();
  }

  Future<void> delete() async {
    final user = currentUser;
    if (user == null) return;

    await _presence.updateOnline(user.uid, false);
    await _user.delete(user.uid);
    await _auth.delete(user);
    await _auth.logout();

    userData.value = null;
  }

  Stream<List<DocumentSnapshot>> getUsersByName(String name) {
    return _user.getUsersByName(name);
  }

  Future<DocumentSnapshot> getUserById(String uid) {
    return _user.getUserById(uid);
  }

  Stream<QuerySnapshot> getAllUsers() {
    return _user.getAllUsers();
  }

  Stream<QuerySnapshot> getOnlineUsers() {
    return _user.getOnlineUsers();
  }

  Stream<List<DocumentSnapshot>> searchUsers(String name) {
    final uid = currentUser?.uid;

    return _user
        .getUsersByName(name)
        .map((list) => list.where((doc) => doc.id != uid).toList());
  }
}
