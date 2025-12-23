import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/bug_report.dart';
import 'package:messenger/view/home/chat/container.dart';
import 'package:messenger/view/home/sidebar/container.dart';

class HomeDesktopLayout extends StatelessWidget {
  final SidebarFilter filter;
  final bool isSidebarOpen;
  final TextEditingController searchController;
  final Map<String, Map<String, dynamic>> usersCache;
  final DocumentReference? activeConversation;
  final String? otherUserId;

  final ValueChanged<SidebarFilter> onFilterChanged;
  final ValueChanged<DocumentReference> onConversationSelected;
  final VoidCallback onSidebarToggle;
  final void Function(String uid) onUserNeeded;

  final bool showSettings;
  final VoidCallback onOpenSettings;
  final VoidCallback onCloseSettings;

  const HomeDesktopLayout({
    super.key,
    required this.filter,
    required this.isSidebarOpen,
    required this.searchController,
    required this.usersCache,
    this.activeConversation,
    this.otherUserId,
    required this.onFilterChanged,
    required this.onConversationSelected,
    required this.onSidebarToggle,
    required this.onUserNeeded,
    required this.showSettings,
    required this.onOpenSettings,
    required this.onCloseSettings,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final bgColor = context.resolveStateColor(MainBgColors.bg);
    final iconColor = context.resolveStateColor(SettingIconColors.bg);

    bool hasActiveConversation =
        activeConversation != null && otherUserId != null;

    return Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Row(
          children: [
            SidebarContainer(
              filter: filter,
              onFilterChanged: onFilterChanged,
              searchController: searchController,
              usersCache: usersCache,
              onConversationSelected: onConversationSelected,
              onUserNeeded: onUserNeeded,
            ),

            Expanded(
              child: hasActiveConversation
                  ? ChatContainer(
                      conversationId: activeConversation!.id,
                      otherUserId: otherUserId!,
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(
                        vertical: t.spacing(c.spaceXSmall),
                        horizontal: t.spacing(c.spaceXSmall),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: t.spacing(c.spaceSmall - 1.5),
                            ),
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: PopupMenuButton<String>(
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
                                          padding: const EdgeInsets.only(
                                            left: 8.0,
                                          ),
                                          child: Icon(
                                            Icons.support_agent,
                                            color: iconColor,
                                            size: t.font(20),
                                          ),
                                        ),
                                        SizedBox(
                                          width: t.spacing(c.spaceSmall),
                                        ),
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
                            ),
                          ),
                          Expanded(
                            child: const Center(
                              child: Text("Válassz egy beszélgetést"),
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
