import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/message_image.dart';

class ForwardData {
  final MessageType type;
  final String text;
  final List<MessageImage> images;
  final String url;
  final String previewUrl;
  final double? width;
  final double? height;

  ForwardData._({
    required this.type,
    this.text = '',
    this.images = const [],
    this.url = '',
    this.previewUrl = '',
    this.width,
    this.height,
  });

  factory ForwardData.text(String text) =>
      ForwardData._(type: MessageType.text, text: text);

  factory ForwardData.images(List<MessageImage> images) =>
      ForwardData._(type: MessageType.image, images: images);

  factory ForwardData.media({
    required MessageType type,
    required String url,
    required String previewUrl,
    double? width,
    double? height,
  }) => ForwardData._(
    type: type,
    url: url,
    previewUrl: previewUrl,
    width: width,
    height: height,
  );
}
