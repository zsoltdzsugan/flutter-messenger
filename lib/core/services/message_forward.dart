import 'package:messenger/core/controller/conversation.dart';
import 'package:messenger/core/enums/message_type.dart';
import 'package:messenger/core/extensions/forward_payload.dart';
import 'package:messenger/core/models/message.dart';

class ForwardService {
  ForwardService._();
  static final instance = ForwardService._();

  Message? _message;

  void set(Message message) {
    _message = message;
  }

  Message? consume() {
    final msg = _message;
    _message = null;
    return msg;
  }

  Future<void> sendForwardMessage(String targetConversationId) async {
    final msg = consume();
    if (msg == null) return;

    final payload = msg.toForwardData();

    switch (payload.type) {
      case MessageType.text:
        await ConversationController.instance.send(
          targetConversationId,
          type: MessageType.text,
          text: payload.text,
        );
        break;

      case MessageType.image:
        // Images already uploaded → reuse URLs
        await ConversationController.instance.send(
          targetConversationId,
          type: MessageType.image,
          files: const [], // no re-upload
        );
        break;

      case MessageType.gif:
      case MessageType.sticker:
        await ConversationController.instance.send(
          targetConversationId,
          type: payload.type,
          gif: null, // not used anymore
        );
        break;

      default:
        throw UnsupportedError('Forward not supported for ${payload.type}');
    }
  }
}
