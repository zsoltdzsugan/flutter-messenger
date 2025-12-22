import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/design/breakpoints.dart';
import 'package:messenger/core/enums/avatar_layout.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/sidebar_user_view.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class CollapsedSidebar extends StatefulWidget {
  final VoidCallback onExpand;
  final bool canExpand;
  final Map<String, Map<String, dynamic>> usersCache;
  final void Function(String uid) onUserNeeded;
  final ValueChanged<DocumentReference> onConversationSelected;

  const CollapsedSidebar({
    super.key,
    required this.usersCache,
    required this.onUserNeeded,
    required this.onConversationSelected,
    required this.onExpand,
    required this.canExpand,
  });

  @override
  State<CollapsedSidebar> createState() => _CollapsedSidebarState();
}

class _CollapsedSidebarState extends State<CollapsedSidebar> {
  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final iconColor = context.resolveStateColor(SettingIconColors.bg);

    return Column(
      children: [
        // Scrollable avatars
        Expanded(
          child: StreamBuilder<List<DocumentSnapshot>>(
            stream: ConversationController.instance.getUserConversations(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox.shrink();
              }

              final docs = snapshot.data!;
              if (docs.isEmpty) {
                return const SizedBox.shrink();
              }

              final missingUserIds = <String>{};
              final myUid = UserController.instance.currentUser!.uid;

              for (final doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final participants = List<String>.from(data['participants']);
                final otherId = participants.firstWhere((id) => id != myUid);

                if (!widget.usersCache.containsKey(otherId)) {
                  missingUserIds.add(otherId);
                }
              }

              for (final uid in missingUserIds) {
                widget.onUserNeeded(uid);
              }

              return ListView.builder(
                padding: EdgeInsets.only(
                  right: _collapsedListPadding(context).right,
                ),
                itemCount: docs.length,
                itemBuilder: (_, i) {
                  final doc = docs[i];
                  final data = doc.data() as Map<String, dynamic>;

                  final participants = List<String>.from(data['participants']);
                  final otherId = participants.firstWhere((id) => id != myUid);

                  final unreadCounts = (data['unread_count'] as Map?)
                      ?.cast<String, dynamic>();
                  final unread = (unreadCounts?[myUid] as num?)?.toInt() ?? 0;
                  final hasUnread = unread > 0;

                  final view = buildSidebarUserView(widget.usersCache[otherId]);

                  return MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: GestureDetector(
                      onTap: () => widget.onConversationSelected(doc.reference),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Avatar(
                          photoUrl: view.photoUrl,
                          name: view.name,
                          presence: view.presence,
                          showUnread: hasUnread,
                          unreadCount: unread,
                          size: t.spacing(c.avatarSize),
                          layout: AvatarLayout.collapsed,
                        ),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),

        // Chevron handled in header
        if (widget.canExpand)
          Padding(
            padding: EdgeInsets.only(right: t.spacing(16)),
            child: IconButton(
              icon: const Icon(Symbols.left_panel_open_rounded),
              iconSize: t.font(20),
              color: iconColor,
              onPressed: widget.onExpand,
            ),
          ),

        SizedBox(height: t.spacing(c.spaceSmall)),
      ],
    );
  }

  EdgeInsets _collapsedListPadding(BuildContext context) {
    final t = context.adaptive;

    switch (t.breakpoint) {
      case Breakpoint.xs:
        return const EdgeInsets.only(right: 4);

      case Breakpoint.sm:
        return const EdgeInsets.only(right: 20);

      case Breakpoint.md:
        return const EdgeInsets.only(right: 16);

      case Breakpoint.lg:
        return const EdgeInsets.only(right: 20);
      case Breakpoint.xl:
        return const EdgeInsets.only(right: 8);
    }
  }
}
