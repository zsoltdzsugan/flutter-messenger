import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class ContextMenu extends StatelessWidget {
  final Widget child;
  final VoidCallback onOpen;

  const ContextMenu({super.key, required this.child, required this.onOpen});

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (event) {
        if (event.buttons == kSecondaryMouseButton) {
          onOpen();
        }
      },
      child: GestureDetector(
        onLongPress: onOpen,
        behavior: HitTestBehavior.translucent,
        child: child,
      ),
    );
  }
}
