import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class HoverActions extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onSave;
  final VoidCallback? onForward;

  const HoverActions({
    super.key,
    this.onCopy,
    this.onDelete,
    this.onSave,
    this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    final iconColors = context.resolveStateColor(ContextMenuColors.icon);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (onCopy != null)
            IconButton(
              icon: Icon(Icons.copy, size: 18, color: iconColors),
              onPressed: onCopy,
            ),
          if (onForward != null)
            IconButton(
              icon: Icon(Icons.share, size: 18, color: iconColors),
              onPressed: onForward,
            ),
          if (onSave != null)
            IconButton(
              icon: Icon(Icons.download, size: 18, color: iconColors),
              onPressed: onSave,
            ),
          if (onDelete != null)
            IconButton(
              icon: Icon(Icons.delete, size: 18, color: iconColors),
              onPressed: onDelete,
            ),
        ],
      ),
    );
  }
}
