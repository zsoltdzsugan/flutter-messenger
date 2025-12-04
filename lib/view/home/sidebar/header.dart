import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';

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
    final colors = context.core.colors;
    final t = context.adaptive;
    final c = context.components;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    final user = UserController.instance.currentUserData;

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
                backgroundColor: colors.primary,
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
                          color: colors.onPrimary,
                          fontSize: t.font(16),
                        ),
                      ),
              ),
              SizedBox(width: t.spacing(c.spaceSmall)),

              Text(
                user?['name'] ?? 'Ismeretlen',
                style: TextStyle(
                  color: isDark ? colors.textPrimary : colors.textSecondary,
                  fontSize: t.font(16),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),

          // Settings button
          IconButton(
            icon: settingsOpen
                ? Icon(Icons.close, color: colors.primary, size: t.font(20))
                : Icon(Icons.settings, color: colors.primary, size: t.font(20)),
            onPressed: onSettingsTap,
          ),
        ],
      ),
    );
  }
}
