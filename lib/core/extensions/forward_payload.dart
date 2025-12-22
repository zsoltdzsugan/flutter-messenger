import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/models/forward_data.dart';
import 'package:messenger/core/models/message.dart';

extension ForwardPayload on Message {
  ForwardData toForwardData() {
    switch (type) {
      case MessageType.text:
        return ForwardData.text(text);

      case MessageType.gif:
      case MessageType.sticker:
        return ForwardData.media(
          type: type,
          url: mediaUrl,
          previewUrl: previewUrl,
          width: width,
          height: height,
        );

      case MessageType.image:
        return ForwardData.images(images);

      default:
        throw UnsupportedError('Cannot forward message type $type');
    }
  }
}
