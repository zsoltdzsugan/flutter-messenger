import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class SidebarHeader extends StatelessWidget {
  final bool settingsOpen;
  final bool sidebarCollapsed;
  final VoidCallback onSettingsTap;
  final VoidCallback onSidebarToggle;

  const SidebarHeader({
    super.key,
    required this.settingsOpen,
    required this.sidebarCollapsed,
    required this.onSettingsTap,
    required this.onSidebarToggle,
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

    Widget buildAvatar(bool settingsOpen, Map<String, dynamic>? user) {
      if (settingsOpen) {
        return CircleAvatar(
          radius: t.spacing(16),
          backgroundColor: avatarBgColor,
          child: Icon(Icons.close, color: avatarTextColor, size: t.font(18)),
        );
      }

      final photo = user?['photoUrl'] ?? '';
      final name = (user?['name'] as String?) ?? 'U';

      final presence = () {
        final isOnline = user?['is_online'] == true;
        final lastSeen = user?['last_seen'];

        if (isOnline) return PresenceState.online;
        if (lastSeen is Timestamp &&
            DateTime.now().difference(lastSeen.toDate()).inMinutes < 10) {
          return PresenceState.away;
        }
        return PresenceState.offline;
      }();

      return Avatar(
        photoUrl: photo,
        name: name,
        presence: presence,
        backgroundColor: avatarBgColor,
        textColor: avatarTextColor,
      );
    }

    return ValueListenableBuilder<bool>(
      valueListenable: UserController.instance.isLoading,
      builder: (context, loading, _) {
        return ValueListenableBuilder<Map<String, dynamic>?>(
          valueListenable: UserController.instance.userData,
          builder: (context, user, _) {
            // 🚫 Not ready yet → render NOTHING
            if (loading || user == null) {
              return const SizedBox(height: 56); // keeps layout stable
            }

            final avatar = buildAvatar(settingsOpen, user);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing(c.spaceXSmall),
                vertical: t.spacing(c.spaceSmall),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User block
                  Row(
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: onSettingsTap,
                          child: avatar,
                        ),
                      ),
                      SizedBox(width: t.spacing(c.spaceSmall)),

                      Text(
                        user['name'], // ✅ SAFE
                        style: TextStyle(
                          color: nameTextColor,
                          fontSize: t.font(16),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),

                  // Sidebar toggle
                  IconButton(
                    icon: sidebarCollapsed
                        ? Icon(Icons.chevron_right, color: iconColor)
                        : Icon(Icons.chevron_left, color: iconColor),
                    onPressed: onSidebarToggle,
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
