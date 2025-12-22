import 'dart:async';

class SessionController {
  static final SessionController instance = SessionController._();
  SessionController._();

  final List<StreamSubscription> _subs = [];

  void register(StreamSubscription sub) {
    _subs.add(sub);
  }

  Future<void> clear() async {
    for (final sub in _subs) {
      await sub.cancel();
    }
    _subs.clear();
  }
}
