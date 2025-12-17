import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/models/gif.dart';

class GifBubble extends StatefulWidget {
  final Gif gif;
  final BorderRadius borderRadius;
  final int maxLoops;
  final bool autoplay;
  final bool limitLoops;

  const GifBubble({
    super.key,
    required this.gif,
    required this.borderRadius,
    this.maxLoops = 3,
    this.autoplay = false,
    this.limitLoops = true,
  });

  @override
  State<GifBubble> createState() => _GifBubbleState();
}

class _GifBubbleState extends State<GifBubble> {
  bool _playing = false;
  Timer? _timer;

  static const _estimatedDurationMs = 2000;

  @override
  void initState() {
    super.initState();

    if (widget.autoplay) {
      _startPlayback();
    }
  }

  void _startPlayback() {
    if (_playing) return;

    _timer?.cancel();

    setState(() => _playing = true);

    if (!widget.limitLoops) return;

    final totalMs = widget.maxLoops * _estimatedDurationMs;

    _timer = Timer(Duration(milliseconds: totalMs), () {
      if (mounted) {
        setState(() => _playing = false);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = {
      TargetPlatform.macOS,
      TargetPlatform.windows,
      TargetPlatform.linux,
    }.contains(Theme.of(context).platform);

    final imageUrl = _playing ? widget.gif.url : widget.gif.previewUrl;

    final image = ClipRRect(
      borderRadius: widget.borderRadius,
      child: CachedNetworkImage(
        key: ValueKey(imageUrl), // REQUIRED
        imageUrl: imageUrl,
        fit: BoxFit.cover,
        placeholder: (_, __) => const ColoredBox(color: Colors.black12),
      ),
    );

    if (isDesktop) {
      return MouseRegion(onEnter: (_) => _startPlayback(), child: image);
    }

    return GestureDetector(onTap: _startPlayback, child: image);
  }
}
