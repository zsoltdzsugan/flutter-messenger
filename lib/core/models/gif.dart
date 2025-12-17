import 'package:messenger/core/enums/gif_provider.dart';

class Gif {
  final String previewUrl;
  final String url;
  final double width;
  final double height;
  final GifProvider provider; // giphy | tenor

  const Gif({
    required this.previewUrl,
    required this.url,
    required this.width,
    required this.height,
    required this.provider,
  });
}
