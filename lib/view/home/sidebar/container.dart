import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/view/home/sidebar/filter.dart';
import 'package:messenger/view/home/sidebar/filter_bar.dart';
import 'package:messenger/view/home/sidebar/header.dart';
import 'package:messenger/view/home/sidebar/list.dart';
import 'package:messenger/view/home/sidebar/search_field.dart';
import 'package:messenger/view/setting/settings_page.dart';

class SidebarContainer extends StatefulWidget {
  final SidebarFilter filter;
  final ValueChanged<SidebarFilter> onFilterChanged;

  final TextEditingController searchController;
  final ValueChanged<String> onSearchChanged;

  final Map<String, Map<String, dynamic>> usersCache;
  final ValueChanged<DocumentReference> onConversationSelected;
  final void Function(String uid, Map<String, dynamic> data) onCacheUpdate;

  const SidebarContainer({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.searchController,
    required this.onSearchChanged,
    required this.usersCache,
    required this.onConversationSelected,
    required this.onCacheUpdate,
  });

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer> {
  bool _showSettings = false;

  void _toggleSettings() {
    setState(() => _showSettings = !_showSettings);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = context.resolveStateColor(MainBgColors.bg);

    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: Column(
        children: [
          SidebarHeader(
            settingsOpen: _showSettings,
            onSettingsTap: _toggleSettings,
          ),

          Expanded(
            child: Stack(
              children: [
                if (!_showSettings)
                  Column(
                    children: [
                      SidebarFilterBar(
                        filter: widget.filter,
                        onChanged: widget.onFilterChanged,
                      ),
                      SearchField(
                        controller: widget.searchController,
                        onQueryChanged: widget.onSearchChanged,
                      ),
                      Expanded(
                        child: SidebarList(
                          filter: widget.filter,
                          query: widget.searchController.text,
                          usersCache: widget.usersCache,
                          onConversationSelected: widget.onConversationSelected,
                          onCacheUpdate: widget.onCacheUpdate,
                        ),
                      ),
                    ],
                  ),

                // SETTINGS PAGE
                if (_showSettings)
                  Positioned.fill(
                    child: SettingsPage(onClose: _toggleSettings),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
