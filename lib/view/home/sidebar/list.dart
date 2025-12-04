import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/view/home/sidebar/filter.dart';

class SidebarList extends StatelessWidget {
  final SidebarFilter filter;
  final String query;

  final Map<String, Map<String, dynamic>> usersCache;
  final ValueChanged<DocumentReference> onConversationSelected;
  final void Function(String uid, Map<String, dynamic> data) onCacheUpdate;

  const SidebarList({
    super.key,
    required this.filter,
    required this.query,
    required this.usersCache,
    required this.onConversationSelected,
    required this.onCacheUpdate,
  });

  @override
  Widget build(BuildContext context) {
    if (filter == SidebarFilter.users) {
      return _buildUserSearch(context);
    }
    return _buildConversations(context);
  }

  // ───────────────────────────────────────────────
  // USERS SEARCH LIST
  // ───────────────────────────────────────────────
  Widget _buildUserSearch(BuildContext context) {
    if (query.isEmpty || query.length < 2) {
      return const SizedBox.shrink();
    }

    final userController = UserController.instance;

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: userController.getUsersByName(query),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? [];

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final user = docs[i].data() as Map<String, dynamic>?;

            return ListTile(
              leading: const CircleAvatar(radius: 22),
              title: Text(user?['name'] ?? ''),
              subtitle: Text(
                (user?['is_online'] ?? false) ? 'Elérhető' : 'Nem elérhető',
              ),
              onTap: () async {
                final conversationRef = await ConversationController.instance
                    .getConversation(docs[i].id);

                onConversationSelected(conversationRef);
              },
            );
          },
        );
      },
    );
  }

  // ───────────────────────────────────────────────
  // CONVERSATIONS LIST
  // ───────────────────────────────────────────────
  Widget _buildConversations(BuildContext context) {
    final convController = ConversationController.instance;
    final userController = UserController.instance;

    return StreamBuilder<List<DocumentSnapshot>>(
      stream: convController.getUserConversations(),
      builder: (context, snapshot) {
        final docs = snapshot.data ?? [];

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: docs.length,
          itemBuilder: (_, i) {
            final doc = docs[i];
            final data = doc.data() as Map<String, dynamic>?;

            if (data == null || !data.containsKey("participants")) {
              return const SizedBox.shrink();
            }

            final participants = List<String>.from(data["participants"]);
            final currentId = userController.currentUser!.uid;
            final otherId = participants.firstWhere((id) => id != currentId);

            final cached = usersCache[otherId];
            if (cached == null) {
              userController.getUserById(otherId).then((snap) {
                final userData = snap.data() as Map<String, dynamic>?;
                if (userData != null) {
                  onCacheUpdate(otherId, userData);
                }
              });
            }

            return ListTile(
              leading: const CircleAvatar(radius: 22),
              title: Text(cached?['name'] ?? 'Betöltés...'),
              subtitle: Text(data['last_message'] ?? ''),
              onTap: () => onConversationSelected(doc.reference),
            );
          },
        );
      },
    );
  }
}
