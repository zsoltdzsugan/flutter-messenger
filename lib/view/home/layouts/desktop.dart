import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class HomeDesktopLayout extends StatelessWidget {
  const HomeDesktopLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;

    return Scaffold(
      body: Row(
        children: [
          SizedBox(width: 280, child: Placeholder()),
          Expanded(child: Placeholder()),
          SizedBox(width: 300, child: Placeholder()),
        ],
      ),
    );
  }
}
