import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class HomeMobileLayout extends StatelessWidget {
  final TextEditingController searchController;
  final SidebarFilter filter;
  final bool isSidebarOpen;
  final DocumentReference? activeConversation;
  final String? otherUserId;
  final Map<String, Map<String, dynamic>> usersCache;

  final ValueChanged<SidebarFilter> onFilterChanged;
  final VoidCallback onSidebarToggle;
  final ValueChanged<DocumentReference> onConversationSelected;
  final void Function(String uid) onUserNeeded;

  const HomeMobileLayout({
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
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;

    return Scaffold(
      appBar: AppBar(
        title: Text("Messenger", style: TextStyle(fontSize: t.font(16))),
      ),
      body: Text('placeholder'), // show only list
    );
  }
}
