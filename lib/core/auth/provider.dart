import 'package:flutter/material.dart';

class AuthProvider extends ChangeNotifier {
  bool _loggedIn = false;

  bool get isLoggedIn => _loggedIn;

  Future<void> loadSession() async {
    // load from SharedPrefs, secure storage, server, anything you want
    await Future.delayed(Duration(milliseconds: 300));
    _loggedIn = false; // change to true once real auth is in place
    notifyListeners();
  }

  void setLoggedIn(bool value) {
    _loggedIn = value;
    notifyListeners();
  }
}
