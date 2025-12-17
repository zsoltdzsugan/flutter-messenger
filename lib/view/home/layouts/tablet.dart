import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/view/home/chat/container.dart';
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

  DocumentReference? _activeConversation;
  String? _otherUserId;

  // search controller + cache
  final TextEditingController _search = TextEditingController();
  final Map<String, Map<String, dynamic>> _usersCache = {};

  @override
  Widget build(BuildContext context) {
    final bgColor = context.resolveStateColor(MainBgColors.bg);

    return Scaffold(
      backgroundColor: bgColor,
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
                onConversationSelected: (ref) async {
                  final snap = await ref.get();
                  final data = snap.data() as Map<String, dynamic>;

                  final participants = List<String>.from(data["participants"]);
                  final currentId = UserController.instance.currentUser!.uid;
                  final otherId = participants.firstWhere(
                    (id) => id != currentId,
                  );

                  setState(() {
                    _activeConversation = ref;
                    _otherUserId = otherId;
                  });
                },
                onCacheUpdate: (uid, data) {
                  setState(() => _usersCache[uid] = data);
                },
              ),
            ),

            Expanded(
              flex: 5,
              child: _activeConversation == null
                  ? const Center(child: Text("Válassz egy beszélgetést"))
                  : ChatContainer(
                      conversationId: _activeConversation?.id ?? '',
                      otherUserId: _otherUserId ?? '',
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
