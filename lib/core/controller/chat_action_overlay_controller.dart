import 'package:flutter/material.dart';
import 'package:messenger/view/home/chat/hover_context_menu.dart';

class ChatActionOverlayController {
  static OverlayEntry? _entry;

  static void showFor({
    required BuildContext context,
    required LayerLink link,
    required bool isMe,
    VoidCallback? onDelete,
    VoidCallback? onSave,
    VoidCallback? onForward,
  }) {
    hide();

    _entry = OverlayEntry(
      builder: (_) => Positioned.fill(
        child: Stack(
          children: [
            GestureDetector(behavior: HitTestBehavior.translucent, onTap: hide),
            CompositedTransformFollower(
              link: link,
              showWhenUnlinked: false,

              targetAnchor: isMe ? Alignment.centerLeft : Alignment.centerRight,

              followerAnchor: isMe
                  ? Alignment.centerRight
                  : Alignment.centerLeft,

              offset: const Offset(-12, 0),

              child: Material(
                color: Colors.transparent,
                child: HoverActions(
                  onDelete: onDelete == null
                      ? null
                      : () {
                          hide();
                          onDelete();
                        },
                  onSave: onSave == null
                      ? null
                      : () {
                          hide();
                          onSave();
                        },
                  onForward: onForward == null
                      ? null
                      : () {
                          hide();
                          onForward();
                        },
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context, rootOverlay: true).insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
