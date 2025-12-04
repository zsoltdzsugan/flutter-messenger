import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/view/home/home_page.dart';
import 'package:messenger/view/welcome/welcome_page.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snap) {
        if (snap.connectionState == ConnectionState.waiting) {
          return Placeholder();
        }
        if (snap.data == null) {
          return WelcomePage();
        }
        return HomePage();
      },
    );
  }
}
