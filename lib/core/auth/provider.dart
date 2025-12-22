import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/session.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  StreamSubscription<User?>? _sub;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _user = _auth.currentUser;
    _sub = _auth.authStateChanges().listen((user) async {
      if (user == null) {
        _user = null;
      } else {
        try {
          await user.reload();
          _user = _auth.currentUser;
        } catch (e) {
          await _auth.signOut();
          _user = null;
        }
      }
      notifyListeners();
    });
    SessionController.instance.register(_sub!);
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
