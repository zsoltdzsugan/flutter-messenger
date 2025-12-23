import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class HoverActions extends StatelessWidget {
  final VoidCallback? onCopy;
  final VoidCallback? onDelete;
  final VoidCallback? onSave;
  final VoidCallback? onForward;
  final bool isMe;

  const HoverActions({
    super.key,
    required this.isMe,
    this.onCopy,
    this.onDelete,
    this.onSave,
    this.onForward,
  });

  @override
  Widget build(BuildContext context) {
    final iconColors = context.resolveStateColor(ContextMenuColors.icon);

    final actions = <Widget>[
      if (onCopy != null)
        IconButton(
          tooltip: 'Másolás',
          icon: Icon(Icons.copy, size: 18, color: iconColors),
          onPressed: onCopy,
        ),
      if (onForward != null)
        IconButton(
          tooltip: 'Megosztás',
          icon: Icon(Icons.share, size: 18, color: iconColors),
          onPressed: onForward,
        ),
      if (onSave != null)
        IconButton(
          tooltip: 'Letöltés',
          icon: Icon(Icons.download, size: 18, color: iconColors),
          onPressed: onSave,
        ),
      /*if (onDelete != null)
        IconButton(
          tooltip: 'Törlés',
          icon: Icon(Icons.delete, size: 18, color: iconColors),
          onPressed: onDelete,
        ),
       */
    ];

    final orderedActions = isMe ? actions.reversed.toList() : actions;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      decoration: BoxDecoration(color: Colors.transparent),
      child: Row(mainAxisSize: MainAxisSize.min, children: orderedActions),
    );
  }
}
