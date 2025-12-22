import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/enums/avatar_layout.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/sidebar_user_view.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class SidebarList extends StatefulWidget {
  final SidebarFilter filter;
  final String query;

  final Map<String, Map<String, dynamic>> usersCache;
  final void Function(String uid) onUserNeeded;
  final void Function(DocumentReference) onConversationSelected;
  final void Function(String userId) onUserSelected;

  const SidebarList({
    super.key,
    required this.filter,
    required this.query,
    required this.usersCache,
    required this.onUserSelected,
    required this.onConversationSelected,
    required this.onUserNeeded,
  });

  @override
  State<SidebarList> createState() => _SidebarListState();
}

class _SidebarListState extends State<SidebarList> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      switchInCurve: Curves.easeOut,
      switchOutCurve: Curves.easeIn,
      transitionBuilder: _fadeSlideTransition,
      child: widget.filter == SidebarFilter.users
          ? KeyedSubtree(
              key: const ValueKey('users'),
              child: _buildUserSearch(context),
            )
          : KeyedSubtree(
              key: const ValueKey('conversations'),
              child: _buildConversations(context),
            ),
    );
  }

  // ───────────────────────────────────────────────
  Widget _buildUserSearch(BuildContext context) {
    final currentUid = UserController.instance.currentUser!.uid;
    final q = widget.query.toLowerCase();
    final t = context.adaptive;
    final c = context.components;

    final users = widget.usersCache.entries
        .where((e) => e.value['deleted'] != true)
        .where((e) => e.key != currentUid)
        .where((e) {
          final name = (e.value['name'] ?? '').toString().toLowerCase();
          return q.isEmpty || name.contains(q);
        })
        .toList();

    if (users.isEmpty) {
      return const Center(child: Text('Nincs találat!'));
    }

    return _buildListView(
      itemCount: users.length,
      itemBuilder: (_, i) {
        final uid = users[i].key;
        final userData = users[i].value;

        final view = buildSidebarUserView(userData);

        final presence = view.presence == PresenceState.offline
            ? 'Nem elérhető'
            : view.presence == PresenceState.away
            ? 'Elfoglalt'
            : 'Elérhető';

        return ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16),
          leading: Avatar(
            photoUrl: view.photoUrl,
            name: view.name,
            presence: view.presence,
            size: t.spacing(c.avatarSize),
            layout: AvatarLayout.sidebar,
          ),
          title: Text(
            view.name,
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          subtitle: Text(presence, maxLines: 1),
          onTap: () => widget.onUserSelected(uid),
        );
      },
    );
  }

  // ───────────────────────────────────────────────
  Widget _buildConversations(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final userController = UserController.instance;

    final trailingBgColor = context.resolveStateColor(AvatarColors.unreadBg);
    final trailingTextColor = context.resolveStateColor(
      AvatarColors.unreadText,
    );

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: ConversationController.instance.getUserConversations(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const SizedBox.shrink();
        }

        final docs = snapshot.data!;
        if (docs.isEmpty) {
          return const Center(child: Text('Nincs üzenet'));
        }

        final missingUserIds = <String>{};
        final myUid = userController.currentUser!.uid;

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

        return _buildListView(
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

            final lastMessage = data['last_message'] as String? ?? '';
            final lastSender = data['last_message_sender'] as String?;
            final isMe = lastSender == myUid;

            final view = buildSidebarUserView(widget.usersCache[otherId]);

            return ListTile(
              key: ValueKey(doc.id),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16),
              leading: Avatar(
                photoUrl: view.photoUrl,
                name: view.name,
                presence: view.presence,
                size: t.spacing(c.avatarSize),
                layout: AvatarLayout.sidebar,
              ),
              title: Text(
                view.name,
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
              subtitle: Text(
                isMe && lastMessage.isNotEmpty
                    ? 'Te: $lastMessage'
                    : lastMessage,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: hasUnread ? FontWeight.bold : FontWeight.normal,
                ),
              ),
              trailing: hasUnread
                  ? Container(
                      padding: EdgeInsets.symmetric(
                        vertical: t.spacing(4),
                        horizontal: t.spacing(8),
                      ),
                      decoration: BoxDecoration(
                        color: trailingBgColor,
                        borderRadius: BorderRadius.circular(t.font(32)),
                      ),
                      child: Text(
                        unread.toString(),
                        style: TextStyle(
                          color: trailingTextColor,
                          fontSize: t.font(12),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    )
                  : null,
              onTap: () async {
                await ConversationController.instance.markConversationAsRead(
                  doc.id,
                );
                widget.onConversationSelected(doc.reference);
              },
            );
          },
        );
      },
    );
  }

  Widget _fadeSlideTransition(Widget child, Animation<double> animation) {
    return FadeTransition(
      opacity: animation,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0.02, 0),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    );
  }

  Widget _buildListView({
    required int itemCount,
    required IndexedWidgetBuilder itemBuilder,
  }) {
    return ListView.builder(
      padding: EdgeInsets.zero, // lock it
      itemCount: itemCount,
      itemBuilder: itemBuilder,
    );
  }
}
