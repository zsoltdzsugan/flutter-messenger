import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class SidebarHeader extends StatelessWidget {
  final bool settingsOpen;
  final VoidCallback onSettingsTap;

  const SidebarHeader({
    super.key,
    required this.settingsOpen,
    required this.onSettingsTap,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final avatarBgColor = context.resolveStateColor(
      AvatarColors.bg,
      isSelected: settingsOpen,
    );
    final avatarTextColor = context.resolveStateColor(
      AvatarColors.text,
      isSelected: settingsOpen,
    );
    final nameTextColor = context.resolveStateColor(
      NameColors.text,
      isSelected: settingsOpen,
    );
    final iconColor = context.resolveStateColor(
      SettingIconColors.bg,
      isSelected: settingsOpen,
    );

    return ValueListenableBuilder(
      valueListenable: UserController.instance.userData,
      builder: (context, user, _) {
        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: t.spacing(c.spaceSmall),
            vertical: t.spacing(c.spaceSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // User block
              Row(
                children: [
                  CircleAvatar(
                    radius: t.spacing(16),
                    backgroundColor: avatarBgColor,
                    backgroundImage:
                        user?['photoUrl'] != null &&
                            (user!['photoUrl'] as String).isNotEmpty
                        ? NetworkImage(user['photoUrl'])
                        : null,
                    child: (user?['photoUrl'] as String?)?.isNotEmpty == true
                        ? null
                        : Text(
                            (() {
                              final username = (user?["name"] as String?) ?? "";
                              return username.isNotEmpty
                                  ? username[0].toUpperCase()
                                  : "U";
                            })(),
                            style: TextStyle(
                              color: avatarTextColor,
                              fontSize: t.font(16),
                            ),
                          ),
                  ),
                  SizedBox(width: t.spacing(c.spaceSmall)),

                  Text(
                    user?['name'] ?? 'Ismeretlen',
                    style: TextStyle(
                      color: nameTextColor,
                      fontSize: t.font(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // Settings button
              IconButton(
                icon: settingsOpen
                    ? Icon(Icons.close, color: iconColor, size: t.font(20))
                    : Icon(Icons.settings, color: iconColor, size: t.font(20)),
                onPressed: onSettingsTap,
              ),
            ],
          ),
        );
      },
    );
  }
}
