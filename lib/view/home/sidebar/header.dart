import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class SidebarHeader extends StatelessWidget {
  final bool sidebarCollapsed;
  final VoidCallback onSettingsTap;
  final VoidCallback onSidebarToggle;
  final bool isSettingsOpen;
  final Animation<double> animationDelay;

  const SidebarHeader({
    super.key,
    required this.sidebarCollapsed,
    required this.onSettingsTap,
    required this.onSidebarToggle,
    required this.isSettingsOpen,
    required this.animationDelay,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final avatarBgColor = context.resolveStateColor(AvatarColors.bg);
    final avatarTextColor = context.resolveStateColor(AvatarColors.text);
    final nameTextColor = context.resolveStateColor(NameColors.text);
    final iconColor = context.resolveStateColor(SettingIconColors.bg);

    Widget buildAvatar(Map<String, dynamic>? user) {
      if (isSettingsOpen) {
        return CircleAvatar(
          radius: t.spacing(16),
          backgroundColor: avatarBgColor,
          child: Icon(Icons.close, color: avatarTextColor, size: t.font(18)),
        );
      }

      final photo = user?['photo_url'] ?? '';
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
        size: t.spacing(c.avatarSize),
      );
    }

    final Animation<double> delayedAnimation =
        animationDelay is Animation<double> && animationDelay.value < 1.0
        ? animationDelay
        : const AlwaysStoppedAnimation(1.0);

    return ValueListenableBuilder<bool>(
      valueListenable: UserController.instance.isLoading,
      builder: (context, loading, _) {
        return ValueListenableBuilder<Map<String, dynamic>?>(
          valueListenable: UserController.instance.userData,
          builder: (context, user, _) {
            if (loading || user == null) {
              return const SizedBox.shrink();
            }

            final avatar = buildAvatar(user);

            return Padding(
              padding: EdgeInsets.symmetric(
                horizontal: t.spacing(8),
                vertical: t.spacing(c.spaceSmall),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // User block
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          behavior: HitTestBehavior.translucent,
                          onTap: onSettingsTap,
                          child: avatar,
                        ),
                      ),

                      if (!sidebarCollapsed && !isSettingsOpen)
                        SizeTransition(
                          axis: Axis.horizontal,
                          sizeFactor: delayedAnimation,
                          child: FadeTransition(
                            opacity: delayedAnimation,
                            child: Padding(
                              padding: EdgeInsets.only(
                                left: t.spacing(c.spaceSmall),
                              ),
                              child: Text(
                                user['name'],
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: nameTextColor,
                                  fontSize: t.font(16),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),

                  // Sidebar toggle
                  if (!sidebarCollapsed)
                    SizeTransition(
                      axis: Axis.horizontal,
                      sizeFactor: delayedAnimation,
                      child: FadeTransition(
                        opacity: delayedAnimation,
                        child: IconButton(
                          icon: Icon(
                            Symbols.left_panel_close_rounded,
                            color: iconColor,
                          ),
                          iconSize: t.font(20),
                          onPressed: onSidebarToggle,
                        ),
                      ),
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
