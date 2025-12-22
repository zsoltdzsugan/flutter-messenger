class ChatImage {
  final String url;
  final double width;
  final double height;
  final String messageId;

  ChatImage({
    required this.url,
    required this.width,
    required this.height,
    required this.messageId,
  });

  String get heroTag => url;
}
