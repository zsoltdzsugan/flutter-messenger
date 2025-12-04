import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/view/home/sidebar/container.dart';
import 'package:messenger/view/home/sidebar/filter.dart';

class HomeTabletLayout extends StatefulWidget {
  const HomeTabletLayout({super.key});

  @override
  State<HomeTabletLayout> createState() => _HomeTabletLayoutState();
}

class _HomeTabletLayoutState extends State<HomeTabletLayout> {
  SidebarFilter _filter = SidebarFilter.messages;

  String _query = '';
  DocumentReference? _selectedConversation;

  // search controller + cache
  final TextEditingController _search = TextEditingController();
  final Map<String, Map<String, dynamic>> _usersCache = {};

  @override
  void initState() {
    super.initState();
    _loadLatestConversation();
  }

  Future<void> _loadLatestConversation() async {
    final ref = await ConversationController.instance.loadLatestConversation();
    setState(() => _selectedConversation = ref);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final colors = context.core.colors;
    print(MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: SidebarContainer(
                filter: _filter,
                onFilterChanged: (f) => setState(() => _filter = f),
                searchController: _search,
                onSearchChanged: (q) => setState(() => _query = q),
                usersCache: _usersCache,
                onConversationSelected: (ref) {
                  setState(() => _selectedConversation = ref);
                },
                onCacheUpdate: (uid, data) {
                  setState(() => _usersCache[uid] = data);
                },
              ),
            ),

            Expanded(
              flex: 5,
              child: _selectedConversation == null
                  ? const Center(child: Text("Válassz egy beszélgetést"))
                  : const Placeholder(),
              //: ChatScreen(conversationRef: _selectedConversation!),
            ),
          ],
        ),
      ),
    );
  }
}
