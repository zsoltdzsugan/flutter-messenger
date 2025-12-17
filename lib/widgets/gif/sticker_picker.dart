import 'package:flutter/material.dart';
import 'package:messenger/core/controller/gif.dart';
import 'package:messenger/core/models/gif.dart';

class StickerPicker extends StatefulWidget {
  final void Function(Gif) onSelect;

  const StickerPicker({super.key, required this.onSelect});

  @override
  State<StickerPicker> createState() => _StickerPickerState();
}

class _StickerPickerState extends State<StickerPicker> {
  final _controller = GifController();
  final _search = TextEditingController();
  List<Gif> _stickers = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadTrending();
  }

  Future<void> _loadTrending() async {
    setState(() => _loading = true);
    _stickers = await _controller.trendingStickers();
    setState(() => _loading = false);
  }

  Future<void> _searchStickers(String q) async {
    if (q.isEmpty) return _loadTrending();
    _stickers = await _controller.searchStickers(q);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: TextField(
            controller: _search,
            decoration: const InputDecoration(
              hintText: 'Search stickers',
              prefixIcon: Icon(Icons.search),
            ),
            onChanged: _searchStickers,
          ),
        ),

        Expanded(
          child: _loading
              ? const Center(child: CircularProgressIndicator())
              : GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 4,
                    mainAxisSpacing: 6,
                    crossAxisSpacing: 6,
                  ),
                  itemCount: _stickers.length,
                  itemBuilder: (_, i) {
                    final s = _stickers[i];
                    return GestureDetector(
                      onTap: () => widget.onSelect(s),
                      child: Image.network(
                        s.previewUrl.isNotEmpty ? s.previewUrl : s.url,
                        fit: BoxFit.contain,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
