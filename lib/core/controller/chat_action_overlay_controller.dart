import 'package:flutter/material.dart';
import 'package:messenger/view/home/chat/hover_context_menu.dart';

class ChatActionOverlayController {
  static OverlayEntry? _entry;
  static bool get isOpen => _entry != null;

  static void showFor({
    required BuildContext context,
    required Offset anchorOffset,
    required Size anchorSize,
    required bool isMe,
    VoidCallback? onDelete,
    VoidCallback? onSave,
    VoidCallback? onForward,
    VoidCallback? onCopy,
  }) {
    hide(); // only one open

    final overlay = Overlay.of(context, rootOverlay: true);

    final screenWidth = MediaQuery.of(context).size.width;
    //final screenHeight = MediaQuery.of(context).size.height;

    double? menuLeft;
    double? menuRight;
    const double gap = 8.0;
    const double assumedMenuHeight =
        48.0; // Adjust based on your HoverActions height

    if (isMe) {
      // Menu on left side of bubble
      final bubbleLeft = anchorOffset.dx;
      menuRight = screenWidth - bubbleLeft + gap;
    } else {
      // Menu on right side of bubble
      final bubbleRight = anchorOffset.dx + anchorSize.width;
      menuLeft = bubbleRight + gap;
    }

    final menuTop =
        anchorOffset.dy + (anchorSize.height / 2) - (assumedMenuHeight / 2);

    _entry = OverlayEntry(
      builder: (_) {
        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onTap: hide,
              ),
            ),
            Positioned(
              left: menuLeft,
              right: menuRight,
              top: menuTop,
              child: Material(
                color: Colors.transparent,
                child: HoverActions(
                  isMe: isMe,
                  onCopy: onCopy == null
                      ? null
                      : () {
                          hide();
                          onCopy();
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
                  onDelete: onDelete == null
                      ? null
                      : () {
                          hide();
                          onDelete();
                        },
                ),
              ),
            ),
          ],
        );
      },
    );

    overlay.insert(_entry!);
  }

  static void hide() {
    _entry?.remove();
    _entry = null;
  }
}
