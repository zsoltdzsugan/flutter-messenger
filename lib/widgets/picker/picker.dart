import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/gif.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/enums/picker_mode.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/sidebar_user_view.dart';
import 'package:messenger/widgets/buttons/animated_filter_button.dart';
import 'package:messenger/widgets/chat/avatar.dart';
import 'package:messenger/widgets/gif/bubble.dart';

class Picker extends StatefulWidget {
  final PickerMode mode;
  final ValueChanged<dynamic> onSelected;

  const Picker({super.key, required this.mode, required this.onSelected});

  @override
  State<Picker> createState() => _PickerState();
}

class _PickerState extends State<Picker> {
  final _gifController = GifController();
  final _userController = UserController.instance;
  final _search = TextEditingController();

  GifProvider _provider = GifProvider.tenor;
  Timer? _debounce;

  bool _loading = true;
  bool _initialized = false;

  List<dynamic> _items = [];

  StreamSubscription? _userSub;
  List<DocumentSnapshot> _users = [];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;
    _loadInitial();
  }

  @override
  void dispose() {
    _userSub?.cancel();
    _debounce?.cancel();
    _search.dispose();
    super.dispose();
  }

  // ─────────────────────────────────────────────
  // LOADERS
  // ─────────────────────────────────────────────

  void _loadInitial() {
    switch (widget.mode) {
      case PickerMode.gif:
        _loadTrendingGifs();
        break;
      case PickerMode.sticker:
        _loadTrendingStickers();
        break;
      case PickerMode.forward:
        _loadUsers();
        break;
    }
  }

  Future<void> _loadTrendingGifs() async {
    setState(() => _loading = true);
    final res = await _gifController.trending(
      _provider,
      device: context.adaptive.device,
    );
    if (!mounted) return;
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  Future<void> _loadTrendingStickers() async {
    setState(() => _loading = true);
    final res = await _gifController.trendingStickers();
    if (!mounted) return;
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  void _loadUsers() {
    _userSub?.cancel();
    setState(() => _loading = true);

    _userSub = _userController.searchUsers('').listen((users) {
      if (!mounted) return;
      setState(() {
        _users = users;
        _loading = false;
      });
    });
  }

  // ─────────────────────────────────────────────
  // SEARCH
  // ─────────────────────────────────────────────

  void _onSearchChanged(String q) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;

      switch (widget.mode) {
        case PickerMode.gif:
          _searchGifs(q);
          break;
        case PickerMode.sticker:
          _searchStickers(q);
          break;
        case PickerMode.forward:
          _searchUsers(q);
          break;
      }
    });
  }

  Future<void> _searchGifs(String q) async {
    if (q.isEmpty) return _loadTrendingGifs();
    setState(() => _loading = true);
    final res = await _gifController.search(
      _provider,
      query: q,
      device: context.adaptive.device,
    );
    if (!mounted) return;
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  Future<void> _searchStickers(String q) async {
    if (q.isEmpty) return _loadTrendingStickers();
    setState(() => _loading = true);
    final res = await _gifController.searchStickers(q);
    if (!mounted) return;
    setState(() {
      _items = res;
      _loading = false;
    });
  }

  void _searchUsers(String q) {
    _userSub?.cancel();
    setState(() => _loading = true);

    _userSub = _userController.searchUsers(q).listen((users) {
      if (!mounted) return;
      setState(() {
        _users = users;
        _loading = false;
      });
    });
  }

  void _setProvider(GifProvider provider) {
    if (_provider == provider) return;
    setState(() {
      _provider = provider;
      _search.clear();
    });
    _loadTrendingGifs();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final bgColor = context.resolveStateColor(PickerColors.bg);
    final borderColor = context.resolveStateColor(PickerColors.border);

    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(
          context.core.baseRadius * t.radiusScale,
        ),
      ),
      child: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _buildBody(),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        if (widget.mode == PickerMode.gif)
          Row(
            children: [
              Expanded(
                child: AnimatedFilterButton(
                  label: 'Giphy',
                  isSelected: _provider == GifProvider.giphy,
                  onTap: () => _setProvider(GifProvider.giphy),
                  icon: Icons.gif,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AnimatedFilterButton(
                  label: 'Tenor',
                  isSelected: _provider == GifProvider.tenor,
                  onTap: () => _setProvider(GifProvider.tenor),
                  icon: Icons.gif,
                ),
              ),
            ],
          ),

        Padding(
          padding: const EdgeInsets.all(12),
          child: TextField(
            controller: _search,
            decoration: InputDecoration(
              hintText: _hintText(),
              prefixIcon: const Icon(Icons.search),
            ),
            onChanged: _onSearchChanged,
          ),
        ),
      ],
    );
  }

  String _hintText() {
    switch (widget.mode) {
      case PickerMode.gif:
        return 'Mozgókép keresés...';
      case PickerMode.sticker:
        return 'Matrica keresés...';
      case PickerMode.forward:
        return 'Ismerős keresés...';
    }
  }

  Widget _buildBody() {
    switch (widget.mode) {
      case PickerMode.gif:
      case PickerMode.sticker:
        return _buildMediaGrid();

      case PickerMode.forward:
        return _buildForwardList();
    }
  }

  Widget _buildMediaGrid() {
    final t = context.adaptive;
    final device = context.adaptive.device;
    final crossAxisCount = device == DeviceType.desktop
        ? 5
        : device == DeviceType.tablet
        ? 4
        : 3;

    return GridView.builder(
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
      ),
      itemCount: _items.length,
      itemBuilder: (_, i) {
        final item = _items[i];

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              widget.onSelected(item);
              Navigator.pop(context);
            },
            child: widget.mode == PickerMode.gif
                ? Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.core.colors.surface),
                    ),
                    child: GifBubble(
                      gif: item,
                      autoplay: true,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  )
                : Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: context.core.colors.surface),
                    ),
                    child: Image.network(
                      item.previewUrl.isNotEmpty ? item.previewUrl : item.url,
                    ),
                  ),
          ),
        );
      },
    );
  }

  Widget _buildForwardList() {
    return ListView.builder(
      itemCount: _users.length,
      itemBuilder: (_, i) {
        final data = _users[i].data() as Map<String, dynamic>;
        final userId = _users[i].id;
        final view = buildSidebarUserView(data);

        return ListTile(
          leading: Avatar(
            photoUrl: view.photoUrl,
            name: view.name,
            presence: view.presence,
          ),
          title: Text(view.name),
          trailing: TextButton(
            child: const Text('Send'),
            onPressed: () {
              widget.onSelected(userId);
              Navigator.pop(context);
            },
          ),
        );
      },
    );
  }
}

Future<void> showPicker({
  required BuildContext context,
  required PickerMode mode,
  required ValueChanged<dynamic> onSelected,
}) {
  final device = context.adaptive.device;

  if (device == DeviceType.desktop || device == DeviceType.tablet) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) => Dialog(
        insetPadding: const EdgeInsets.all(24),
        child: SizedBox(
          width: 720,
          height: 560,
          child: Picker(mode: mode, onSelected: onSelected),
        ),
      ),
    );
  }

  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => SafeArea(
      child: Container(
        height: MediaQuery.of(context).size.height * 0.75,
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Picker(mode: mode, onSelected: onSelected),
      ),
    ),
  );
}
