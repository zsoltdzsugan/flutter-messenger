import 'dart:async';

import 'package:flutter/material.dart';
import 'package:messenger/core/controller/gif.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/enums/gif_provider.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/models/gif.dart';
import 'package:messenger/widgets/buttons/animated_filter_button.dart';
import 'package:messenger/widgets/gif/bubble.dart';

class GifPicker extends StatefulWidget {
  final ValueChanged<Gif> onSelected;

  const GifPicker({super.key, required this.onSelected});

  @override
  State<GifPicker> createState() => _GifPickerState();
}

class _GifPickerState extends State<GifPicker> {
  final _gifController = GifController();
  final _search = TextEditingController();

  GifProvider _provider = GifProvider.tenor;

  List<Gif> _gifs = [];
  bool _loading = true;
  bool _initialized = false;

  Timer? _debounce;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_initialized) return;
    _initialized = true;

    _loadTrending();
  }

  void _changeProvider(GifProvider provider) {
    if (_provider == provider) return;
    setState(() {
      _provider = provider;
      _search.clear();
    });
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    setState(() => _loading = true);

    final res = await _gifController.trending(
      _provider,
      device: context.adaptive.device,
    );

    if (!mounted) return;
    setState(() {
      _gifs = res;
      _loading = false;
    });
  }

  Future<void> _searchGifs(String q) async {
    if (q.trim().isEmpty) {
      return _loadTrending();
    }

    setState(() => _loading = true);

    final res = await _gifController.search(
      _provider,
      query: q,
      device: context.adaptive.device,
    );

    if (!mounted) return;
    setState(() {
      _gifs = res;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final device = t.device;

    return SafeArea(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: AnimatedFilterButton(
                  label: "Giphy",
                  isSelected: _provider == GifProvider.giphy,
                  onTap: () => _changeProvider(GifProvider.giphy),
                  icon: Icons.gif,
                ),
              ),
              SizedBox(width: t.spacing(c.spaceXSmall)),
              Expanded(
                child: AnimatedFilterButton(
                  label: "Tenor",
                  isSelected: _provider == GifProvider.tenor,
                  onTap: () => _changeProvider(GifProvider.tenor),
                  icon: Icons.gif,
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _search,
              decoration: const InputDecoration(
                hintText: 'Search GIFs',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (q) {
                _debounce?.cancel();
                _debounce = Timer(const Duration(milliseconds: 300), () {
                  _searchGifs(q);
                });
              },
            ),
          ),

          Expanded(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: device == DeviceType.desktop
                          ? 5
                          : device == DeviceType.tablet
                          ? 4
                          : 3,
                      crossAxisSpacing: 6,
                      mainAxisSpacing: 6,
                    ),
                    itemCount: _gifs.length,
                    itemBuilder: (_, i) {
                      final gif = _gifs[i];

                      return GestureDetector(
                        onTap: () {
                          widget.onSelected(gif);
                          Navigator.pop(context);
                        },
                        child: GifBubble(
                          gif: gif,
                          borderRadius: BorderRadius.circular(8),
                          autoplay: true,
                          limitLoops: false,
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
