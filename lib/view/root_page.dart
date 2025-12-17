import 'package:flutter/material.dart';
import 'package:messenger/core/auth/provider.dart';
import 'package:messenger/view/home/home_page.dart';
import 'package:messenger/view/welcome/welcome_page.dart';
import 'package:provider/provider.dart';

class RootPage extends StatelessWidget {
  const RootPage({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    if (!auth.isLoggedIn) {
      return const WelcomePage();
    }

    return const HomePage();
  }
}
