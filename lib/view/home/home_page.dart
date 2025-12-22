import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/session.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/design/responsive_layout.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/view/home/layouts/desktop.dart';
import 'package:messenger/view/home/layouts/mobile.dart';
import 'package:messenger/view/home/layouts/tablet.dart';

class HomePage extends StatefulWidget {
  static const String route = "HomePage";

  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // search
  final TextEditingController _searchController = TextEditingController();

  // sidebar
  SidebarFilter _sidebarFilter = SidebarFilter.messages;
  bool _isSidebarOpen = true;

  // users cache
  final Map<String, Map<String, dynamic>> _usersCache = {};
  final Map<String, StreamSubscription> _usersSubs = {};
  StreamSubscription<QuerySnapshot>? _allUserSub;

  // conversation
  DocumentReference? _activeConversation;
  String? _otherUserId;

  // settings
  bool _showSettings = false;

  Future<void> openConversation(DocumentReference ref) async {
    final snap = await ref.get();
    final data = snap.data() as Map<String, dynamic>;

    final participants = List<String>.from(data["participants"]);
    final currentUid = UserController.instance.currentUser!.uid;
    final otherUid = participants.firstWhere((id) => id != currentUid);

    setState(() {
      _activeConversation = ref;
      _otherUserId = otherUid;
    });
  }

  void ensureUserCached(String uid) {
    if (_usersSubs.containsKey(uid)) return;

    final sub = FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .snapshots()
        .listen((snap) {
          if (!snap.exists) {
            setState(() {
              _usersCache.remove(uid);
            });
            _usersSubs.remove(uid)?.cancel();
            return;
          }

          setState(() {
            _usersCache[uid] = snap.data()!;
          });
        });

    _usersSubs[uid] = sub;
    SessionController.instance.register(sub!);
  }

  void ensureAllUsersCached() {
    if (_allUserSub != null) return;

    _allUserSub = FirebaseFirestore.instance
        .collection('users')
        .where('deleted', isEqualTo: false)
        .snapshots()
        .listen((snap) {
          setState(() {
            for (final change in snap.docChanges) {
              final uid = change.doc.id;

              switch (change.type) {
                case DocumentChangeType.added:
                case DocumentChangeType.modified:
                  _usersCache[uid] = change.doc.data()!;
                  break;

                case DocumentChangeType.removed:
                  _usersCache.remove(uid);
                  _usersSubs.remove(uid)?.cancel();
                  break;
              }
            }
          });
        });
    SessionController.instance.register(_allUserSub!);
  }

  void requestUser(String uid) {
    ensureUserCached(uid);
  }

  @override
  void dispose() {
    for (final sub in _usersSubs.values) {
      sub.cancel();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeMobileLayout(
        filter: _sidebarFilter,
        isSidebarOpen: _isSidebarOpen,
        searchController: _searchController,
        activeConversation: _activeConversation,
        otherUserId: _otherUserId,
        usersCache: _usersCache,
        onFilterChanged: (f) {
          if (f == SidebarFilter.users) {
            ensureAllUsersCached();
          }
          setState(() => _sidebarFilter = f);
        },
        onConversationSelected: openConversation,
        onSidebarToggle: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        onUserNeeded: requestUser,
      ),
      tablet: HomeTabletLayout(
        filter: _sidebarFilter,
        isSidebarOpen: _isSidebarOpen,
        searchController: _searchController,
        activeConversation: _activeConversation,
        otherUserId: _otherUserId,
        usersCache: _usersCache,
        onFilterChanged: (f) {
          if (f == SidebarFilter.users) {
            ensureAllUsersCached();
          }
          setState(() => _sidebarFilter = f);
        },
        onConversationSelected: openConversation,
        onSidebarToggle: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        onUserNeeded: requestUser,
        showSettings: _showSettings,
        onOpenSettings: () => setState(() => _showSettings = true),
        onCloseSettings: () => setState(() => _showSettings = false),
      ),
      desktop: HomeDesktopLayout(
        filter: _sidebarFilter,
        isSidebarOpen: _isSidebarOpen,
        searchController: _searchController,
        activeConversation: _activeConversation,
        otherUserId: _otherUserId,
        usersCache: _usersCache,
        onFilterChanged: (f) {
          if (f == SidebarFilter.users) {
            ensureAllUsersCached();
          }
          setState(() => _sidebarFilter = f);
        },
        onConversationSelected: openConversation,
        onSidebarToggle: () => setState(() => _isSidebarOpen = !_isSidebarOpen),
        onUserNeeded: requestUser,
        showSettings: _showSettings,
        onOpenSettings: () => setState(() => _showSettings = true),
        onCloseSettings: () => setState(() => _showSettings = false),
      ),
    );
  }
}
