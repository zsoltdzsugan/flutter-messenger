import 'package:flutter/material.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final String name;
  final PresenceState presence;
  final Color backgroundColor;
  final Color textColor;

  const Avatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.presence,
    required this.backgroundColor,
    required this.textColor,
  });

  Color _presenceColor(PresenceState presence) {
    switch (presence) {
      case PresenceState.online:
        return Colors.green;
      case PresenceState.away:
        return Colors.yellow;
      case PresenceState.offline:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;

    final hasPhoto = photoUrl.trim().isNotEmpty;
    final presenceBorderColor = context.resolveStateColor(MainBgColors.bg);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        CircleAvatar(
          radius: t.spacing(16),
          backgroundColor: backgroundColor,
          backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
          child: !hasPhoto
              ? Text(
                  name.isNotEmpty ? name[0].toUpperCase() : '?',
                  style: TextStyle(color: textColor, fontSize: t.font(16)),
                )
              : null,
        ),

        Positioned(
          bottom: 0,
          right: 1,
          child: Container(
            width: t.spacing(14) * 0.6,
            height: t.spacing(14) * 0.6,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _presenceColor(presence),
              border: Border.all(color: presenceBorderColor, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
