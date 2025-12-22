import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
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
    final bgColor = context.resolveStateColor(MainBgColors.bg);

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
                  : const Center(child: Text("Válassz egy beszélgetést")),
            ),
          ],
        ),
      ),
    );
  }
}
