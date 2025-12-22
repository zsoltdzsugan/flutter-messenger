import 'package:flutter/material.dart';
import 'package:messenger/core/design/breakpoints.dart';
import 'package:messenger/core/enums/avatar_layout.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/avatar_overlay_offsets.dart';

class Avatar extends StatelessWidget {
  final String photoUrl;
  final String name;
  final PresenceState presence;

  /// e.g. 32 list, 36 header, 40 profile, etc.
  final double size;

  final bool showPresence;

  final bool showIcon;
  final IconData? iconData;
  final VoidCallback? onIconTap;

  final bool showUnread;
  final int unreadCount;

  final bool loading;
  final VoidCallback? onTap;

  final AvatarLayout layout;

  const Avatar({
    super.key,
    required this.photoUrl,
    required this.name,
    required this.presence,
    this.size = 48,
    this.showPresence = true,
    this.showIcon = false,
    this.iconData,
    this.onIconTap,
    this.showUnread = false,
    this.unreadCount = 0,
    this.loading = false,
    this.onTap,
    this.layout = AvatarLayout.general,
  });

  Color _presenceColor(PresenceState presence) {
    switch (presence) {
      case PresenceState.online:
        return Colors.green;
      case PresenceState.away:
        return Colors.orange;
      case PresenceState.offline:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;

    final hasPhoto = photoUrl.trim().isNotEmpty;

    final avatarBgColor = context.resolveStateColor(AvatarColors.bg);
    final avatarTextColor = context.resolveStateColor(AvatarColors.text);
    final presenceBorderColor = context.resolveStateColor(MainBgColors.bg);

    final double radius = size / 2;

    // Scale overlays relative to avatar size (uniform across window sizes)
    final double presenceSize = size * 0.28;
    final double iconSize = size * 0.36;
    final double iconGlyphSize = size * 0.18; // icon inside bubble
    final double badgeFontSize = 10; // fixed keeps it readable everywhere

    final offsets = _resolveOffsets(context);

    final avatar = SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          CircleAvatar(
            radius: radius,
            backgroundColor: avatarBgColor,
            backgroundImage: hasPhoto ? NetworkImage(photoUrl) : null,
            child: !hasPhoto
                ? Text(
                    name.isNotEmpty ? name[0].toUpperCase() : '?',
                    style: TextStyle(
                      color: avatarTextColor,
                      fontSize: radius * 0.9,
                      fontWeight: FontWeight.w600,
                    ),
                  )
                : null,
          ),

          // Presence dot
          if (showPresence)
            Positioned(
              left: size / 2 + offsets.presence.dx,
              top: size / 2 + offsets.presence.dy,
              child: Container(
                width: presenceSize,
                height: presenceSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _presenceColor(presence),
                  border: Border.all(color: presenceBorderColor, width: 2),
                ),
              ),
            ),

          // Universal icon overlay (camera_alt etc.)
          if (showIcon && iconData != null)
            Positioned(
              right: -2,
              bottom: -2,
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: onIconTap,
                child: Container(
                  width: iconSize,
                  height: iconSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.black87,
                    border: Border.all(color: presenceBorderColor, width: 2),
                  ),
                  alignment: Alignment.center,
                  child: Icon(
                    iconData,
                    size: iconGlyphSize,
                    color: Colors.white,
                  ),
                ),
              ),
            ),

          // Loading overlay
          if (loading)
            Positioned.fill(
              child: Container(
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black38,
                ),
                child: const Center(
                  child: SizedBox(
                    width: 14,
                    height: 14,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              ),
            ),

          // Unread badge
          if (showUnread && unreadCount > 0)
            Positioned(
              left: size / 2 + offsets.unread.dx,
              top: size / 2 + offsets.unread.dy,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: context.core.colors.accent,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: context.core.colors.background,
                    width: 2,
                  ),
                ),
                child: Text(
                  unreadCount > 99 ? '99+' : unreadCount.toString(),
                  style: TextStyle(
                    fontSize: badgeFontSize,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
        ],
      ),
    );

    return onTap != null
        ? GestureDetector(onTap: onTap, child: avatar)
        : avatar;
  }

  AvatarOverlayOffsets _resolveOffsets(BuildContext context) {
    final bp = context.adaptive.breakpoint;

    switch (layout) {
      // ───────────────── DEFAULT ─────────────────
      case AvatarLayout.general:
        switch (bp) {
          case Breakpoint.xs:
            return const AvatarOverlayOffsets(
              presence: Offset(8, 8),
              unread: Offset(0, 0),
            );
          case Breakpoint.sm:
            return const AvatarOverlayOffsets(
              presence: Offset(10, 10),
              unread: Offset(0, 0),
            );
          case Breakpoint.md:
          case Breakpoint.lg:
            return const AvatarOverlayOffsets(
              presence: Offset(12, 12),
              unread: Offset(0, 0),
            );
          case Breakpoint.xl:
            return const AvatarOverlayOffsets(
              presence: Offset(14, 14),
              unread: Offset(0, 0),
            );
        }

      // ─────────────── SIDEBAR ───────────────
      case AvatarLayout.sidebar:
        switch (bp) {
          case Breakpoint.xs:
            return const AvatarOverlayOffsets(
              presence: Offset(8, 6),
              unread: Offset(4, -18),
            );
          case Breakpoint.sm:
            return const AvatarOverlayOffsets(
              presence: Offset(10, 10),
              unread: Offset(0, 0),
            );
          case Breakpoint.md:
            return const AvatarOverlayOffsets(
              presence: Offset(10, 10),
              unread: Offset(0, 0),
            );
          case Breakpoint.lg:
            return const AvatarOverlayOffsets(
              presence: Offset(10, 4),
              unread: Offset(0, 0),
            );
          case Breakpoint.xl:
            return const AvatarOverlayOffsets(
              presence: Offset(10, -2),
              unread: Offset(0, 0),
            );
        }

      // ─────────── COLLAPSED SIDEBAR ───────────
      case AvatarLayout.collapsed:
        switch (bp) {
          case Breakpoint.xs:
            return const AvatarOverlayOffsets(
              presence: Offset(12, 8),
              unread: Offset(6, -18),
            );
          case Breakpoint.sm:
            return const AvatarOverlayOffsets(
              presence: Offset(20, 10),
              unread: Offset(18, -26),
            );
          case Breakpoint.md:
            return const AvatarOverlayOffsets(
              presence: Offset(24, 12),
              unread: Offset(22, -26),
            );
          case Breakpoint.lg:
            return const AvatarOverlayOffsets(
              presence: Offset(26, 12),
              unread: Offset(26, -30),
            );
          case Breakpoint.xl:
            return const AvatarOverlayOffsets(
              presence: Offset(30, 14),
              unread: Offset(32, -32),
            );
        }
    }
  }
}
