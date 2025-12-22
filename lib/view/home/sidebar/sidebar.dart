import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/view/home/sidebar/filter_bar.dart';
import 'package:messenger/view/home/sidebar/list.dart';
import 'package:messenger/view/home/sidebar/search_field.dart';

class Sidebar extends StatelessWidget {
  final SidebarFilter filter;
  final ValueChanged<SidebarFilter> onFilterChanged;
  final TextEditingController searchController;
  final Map<String, Map<String, dynamic>> usersCache;
  final ValueChanged<DocumentReference> onConversationSelected;
  final void Function(String) onUserSelected;
  final void Function(String) onUserNeeded;

  const Sidebar({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.searchController,
    required this.usersCache,
    required this.onConversationSelected,
    required this.onUserSelected,
    required this.onUserNeeded,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SidebarFilterBar(filter: filter, onChanged: onFilterChanged),
        SearchField(controller: searchController),
        Expanded(
          child: ValueListenableBuilder<TextEditingValue>(
            valueListenable: searchController,
            builder: (_, value, __) {
              return SidebarList(
                filter: filter,
                query: value.text.trim(),
                usersCache: usersCache,
                onConversationSelected: onConversationSelected,
                onUserNeeded: onUserNeeded,
                onUserSelected: onUserSelected,
              );
            },
          ),
        ),
      ],
    );
  }
}
