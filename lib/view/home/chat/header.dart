import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class ChatHeader extends StatelessWidget {
  final String conversationId;
  final String otherUserId;

  const ChatHeader({
    super.key,
    required this.conversationId,
    required this.otherUserId,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final avatarBgColor = context.resolveStateColor(AvatarColors.bg);
    final avatarTextColor = context.resolveStateColor(AvatarColors.text);
    final nameTextColor = context.resolveStateColor(NameColors.text);

    return StreamBuilder<DocumentSnapshot>(
      stream: FirebaseFirestore.instance
          .collection('users')
          .doc(otherUserId)
          .snapshots(),
      builder: (context, snapshot) {
        final data = snapshot.data?.data() as Map<String, dynamic>?;

        final name = data?['name'] ?? 'Ismeretlen';
        final photoUrl = data?['photo_url'] ?? '';
        final isOnline = data?['is_online'] ?? false;
        final lastSeen = data?['last_seen'] as Timestamp?;

        final presence = isOnline
            ? PresenceState.online
            : lastSeen != null &&
                  lastSeen.toDate().isAfter(
                    DateTime.now().subtract(const Duration(minutes: 30)),
                  )
            ? PresenceState.away
            : PresenceState.offline;

        return Padding(
          padding: EdgeInsets.symmetric(
            vertical: t.spacing(c.spaceSmall),
            horizontal: t.spacing(c.spaceXSmall),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // ───── User block ─────
              Row(
                children: [
                  Avatar(
                    photoUrl: photoUrl,
                    name: name,
                    presence: presence,
                    backgroundColor: avatarBgColor,
                    textColor: avatarTextColor,
                  ),
                  SizedBox(width: t.spacing(c.spaceSmall)),
                  Text(
                    name,
                    style: TextStyle(
                      color: nameTextColor,
                      fontSize: t.font(16),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),

              // ───── Actions ─────
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image),
                    onPressed: () {
                      // keep existing behavior
                    },
                  ),
                  SizedBox(width: t.spacing(c.spaceSmall)),
                  PopupMenuButton<String>(
                    tooltip: '',
                    icon: const Icon(Icons.more_vert),
                    onSelected: (value) {
                      switch (value) {
                        case "refresh":
                          break;
                        case "delete":
                          break;
                      }
                    },
                    itemBuilder: (_) => const [
                      PopupMenuItem(
                        value: "refresh",
                        child: Row(
                          children: [
                            Icon(Icons.refresh),
                            SizedBox(width: 8),
                            Text("Refresh"),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "delete",
                        child: Row(
                          children: [
                            Icon(Icons.delete_outline, color: Colors.red),
                            SizedBox(width: 8),
                            Text("Delete Conversation"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
