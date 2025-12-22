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
}
