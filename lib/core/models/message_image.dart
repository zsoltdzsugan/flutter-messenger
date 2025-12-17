class MessageImage {
  final String url;
  final double width;
  final double height;

  MessageImage({required this.url, required this.width, required this.height});

  factory MessageImage.fromMap(Map<String, dynamic> map) {
    return MessageImage(
      url: map['url'],
      width: (map['width'] as num).toDouble(),
      height: (map['height'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toMap() => {
    'url': url,
    'width': width,
    'height': height,
  };
}
