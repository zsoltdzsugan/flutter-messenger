import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? _user;
  StreamSubscription<User?>? _sub;

  User? get user => _user;
  bool get isLoggedIn => _user != null;

  AuthProvider() {
    _user = _auth.currentUser;
    _sub = _auth.authStateChanges().listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }
}
