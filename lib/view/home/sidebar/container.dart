import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/enums/sidebar_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/view/home/sidebar/collapsed_sidebar.dart';
import 'package:messenger/view/home/sidebar/header.dart';
import 'package:messenger/view/home/sidebar/sidebar.dart';
import 'package:messenger/view/setting/settings_page.dart';

class SidebarContainer extends StatefulWidget {
  final SidebarFilter filter;
  final ValueChanged<SidebarFilter> onFilterChanged;

  final TextEditingController searchController;

  final Map<String, Map<String, dynamic>> usersCache;
  final ValueChanged<DocumentReference> onConversationSelected;
  final void Function(String uid) onUserNeeded;

  const SidebarContainer({
    super.key,
    required this.filter,
    required this.onFilterChanged,
    required this.searchController,
    required this.usersCache,
    required this.onConversationSelected,
    required this.onUserNeeded,
  });

  @override
  State<SidebarContainer> createState() => _SidebarContainerState();
}

class _SidebarContainerState extends State<SidebarContainer>
    with SingleTickerProviderStateMixin {
  late SidebarState _state;
  late SidebarState _prevState;
  late AnimationController _animationController;
  late Animation<double> _fade;
  late Animation<double> _headerDetails;

  @override
  void initState() {
    super.initState();

    _state = SidebarState.expanded;
    _prevState = _state;

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );

    _fade = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutCubic,
    );

    _headerDetails = CurvedAnimation(
      parent: _animationController,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );

    _animationController.value = 1.0; // visible
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _transitionTo(SidebarState next) async {
    if (_state == next) return;

    if (_state != SidebarState.settings) {
      _prevState = _state;
    }

    // fade out
    await _animationController.reverse();
    if (!mounted) return;

    // width/layout changes here
    setState(() {
      _state = next;
    });

    // let width animation start first
    await Future.delayed(const Duration(milliseconds: 100));

    // fade in
    await _animationController.forward();
  }

  Future<void> _handleUserTap(String userId) async {
    widget.onUserNeeded(userId);

    final conv = await ConversationController.instance.getConversation(userId);
    widget.onConversationSelected(conv);
  }

  void _toggleSidebar(bool shouldForceCollapse) {
    if (_isAnimating || shouldForceCollapse) return;

    _transitionTo(
      _state == SidebarState.collapsed
          ? SidebarState.expanded
          : SidebarState.collapsed,
    );

    if (_state == SidebarState.collapsed &&
        widget.filter != SidebarFilter.messages) {
      widget.onFilterChanged(SidebarFilter.messages);
    }
  }

  void _openSettings() {
    if (_isAnimating) return;
    _transitionTo(SidebarState.settings);
  }

  void _closeSettings(bool shouldForceCollapse) {
    if (shouldForceCollapse) {
      _transitionTo(SidebarState.collapsed);
    } else {
      _transitionTo(_prevState);
    }
  }

  double get _sidebarWidth {
    final t = context.adaptive;
    final c = context.components;

    if (_state == SidebarState.collapsed) return t.font(72);

    final maxWidth = t.spacing(c.sidebarMaxWidth);
    final minWidth = t.spacing(c.sidebarMinWidth);
    final responsive = MediaQuery.of(context).size.width * 0.3;

    return responsive.clamp(minWidth, maxWidth);
  }

  bool get _isAnimating => _animationController.isAnimating;

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final bgColor = context.resolveStateColor(MainBgColors.bg);
    final width = MediaQuery.of(context).size.width;

    final bool shouldForceCollapse =
        width < 700 && t.device != DeviceType.mobile;

    if (shouldForceCollapse && _state != SidebarState.settings) {
      _state = SidebarState.collapsed;
    }

    return Container(
      decoration: BoxDecoration(color: bgColor),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
        width: _sidebarWidth,
        child: Column(
          children: [
            SidebarHeader(
              sidebarCollapsed: _state == SidebarState.collapsed,
              isSettingsOpen: _state == SidebarState.settings,
              onSettingsTap: () {
                if (_state == SidebarState.settings) {
                  _closeSettings(shouldForceCollapse);
                } else {
                  _openSettings();
                }
              },
              onSidebarToggle: () => _toggleSidebar(shouldForceCollapse),
              animationDelay: _headerDetails,
            ),
            Expanded(child: _buildAnimatedBody(shouldForceCollapse)),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBody(bool shouldForceCollapse) {
    return Stack(
      children: [
        // Old content stays invisible but keeps layout stable
        Offstage(
          offstage: !_isAnimating,
          child: _buildContent(shouldForceCollapse),
        ),

        // New content fades/slides in AFTER width settles
        FadeTransition(
          opacity: _fade,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(_fade),
            child: _buildContent(shouldForceCollapse),
          ),
        ),
      ],
    );
  }

  Widget _buildContent(bool shouldForceCollapse) {
    switch (_state) {
      case SidebarState.collapsed:
        return CollapsedSidebar(
          usersCache: widget.usersCache,
          onUserNeeded: widget.onUserNeeded,
          onConversationSelected: widget.onConversationSelected,
          onExpand: () => _toggleSidebar(false),
          canExpand: !shouldForceCollapse,
        );

      case SidebarState.settings:
        return SettingsPage(onClose: () => _closeSettings(shouldForceCollapse));

      case SidebarState.expanded:
        return Sidebar(
          filter: widget.filter,
          onFilterChanged: widget.onFilterChanged,
          searchController: widget.searchController,
          usersCache: widget.usersCache,
          onConversationSelected: widget.onConversationSelected,
          onUserSelected: _handleUserTap,
          onUserNeeded: widget.onUserNeeded,
        );
    }
  }
}
