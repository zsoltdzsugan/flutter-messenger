import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class HomeMobileLayout extends StatelessWidget {
  const HomeMobileLayout({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;

    return Scaffold(
      appBar: AppBar(
        title: Text("Messenger", style: TextStyle(fontSize: t.font(16))),
      ),
      body: Text('placeholder'), // show only list
    );
  }
}
