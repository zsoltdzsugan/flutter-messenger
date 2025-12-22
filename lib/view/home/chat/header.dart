import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/presence_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/services/bug_report.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/chat/avatar.dart';

class ChatHeader extends StatelessWidget {
  final String conversationId;
  final String otherUserId;
  final bool showImages;
  final VoidCallback onImagesToggle;

  const ChatHeader({
    super.key,
    required this.conversationId,
    required this.otherUserId,
    required this.showImages,
    required this.onImagesToggle,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

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

        final iconColor = context.resolveStateColor(
          AuthInputColors.textPrimary,
        );

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
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Avatar(
                    photoUrl: photoUrl,
                    name: name,
                    presence: presence,
                    size: t.spacing(c.avatarSize),
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

                  SizedBox(width: t.spacing(c.spaceSmall)),
                ],
              ),

              // ───── Actions ─────
              Row(
                children: [
                  IconButton(
                    icon: Icon(showImages ? Icons.close : Icons.collections),
                    iconSize: t.font(20),
                    color: iconColor,
                    onPressed: onImagesToggle,
                  ),
                  SizedBox(width: t.spacing(c.spaceSmall)),

                  PopupMenuButton<String>(
                    offset: Offset(-10, 40),
                    tooltip: '',
                    color: context.core.colors.background,
                    icon: const Icon(Icons.more_vert),
                    iconColor: iconColor,
                    iconSize: t.font(20),
                    onSelected: (value) {
                      switch (value) {
                        case "refresh":
                          break;
                        case "delete":
                          break;
                        case "Hibajelentés":
                          showBugReportDialog(context);
                          break;
                        default:
                          break;
                      }
                    },
                    itemBuilder: (_) => [
                      PopupMenuItem(
                        value: "Hibajelentés",
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 8.0),
                              child: Icon(
                                Icons.support_agent,
                                color: iconColor,
                                size: t.font(20),
                              ),
                            ),
                            SizedBox(width: t.spacing(c.spaceSmall)),
                            Text(
                              "Hibajelentés",
                              style: TextStyle(
                                fontSize: t.font(12),
                                color: iconColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                      /*PopupMenuItem(
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
                       */
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

  Future<void> showBugReportDialog(BuildContext context) async {
    final t = context.adaptive;
    final c = context.components;
    final controller = TextEditingController();
    bool loading = false;
    bool _isSelected = false;
    final _focusNode = FocusNode();

    final textColor = context.resolveStateColor(AuthInputColors.textPrimary);
    final borderColor = context.resolveStateColor(
      AuthInputColors.borderPrimary,
      isSelected: _isSelected,
    );
    final bgColor = context.resolveStateColor(MainBgColors.bg);

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: bgColor,
              title: Text(
                'Hiba jelentése',
                style: TextStyle(
                  fontSize: t.font(20),
                  fontFeatures: [FontFeature.enable('smcp')],
                  letterSpacing: 1.25,
                  color: textColor,
                ),
              ),
              content: SizedBox(
                width: t.spacing(c.mainButtonWidth),
                child: TextField(
                  focusNode: _focusNode,
                  controller: controller,
                  maxLines: 10,
                  decoration: InputDecoration(
                    hintText: 'Írd le a problémát...',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      borderSide: BorderSide(color: borderColor),
                    ),
                  ),
                ),
              ),
              actions: [
                TextButton(
                  onPressed: loading ? null : () => Navigator.pop(context),
                  child: Text(
                    'Mégse',
                    style: TextStyle(color: context.core.colors.textPrimary),
                  ),
                ),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: context.core.colors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        context.core.baseRadius * t.radiusScale,
                      ),
                    ),
                  ),
                  onPressed: loading
                      ? null
                      : () async {
                          final text = controller.text.trim();
                          if (text.isEmpty) return;

                          setState(() => loading = true);

                          try {
                            await BugReportService.submit(text);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  'Hiba jelentés sikeresen elküldve',
                                ),
                              ),
                            );
                          } catch (_) {
                            setState(() => loading = false);
                          }
                        },
                  child: loading
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : Text(
                          'Küldés',
                          style: TextStyle(
                            color: context.core.colors.onPrimary,
                          ),
                        ),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
