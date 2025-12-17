class ChatImage {
  final String url;
  final double width;
  final double height;

  ChatImage({required this.url, required this.width, required this.height});

  String get heroTag => url;
}
