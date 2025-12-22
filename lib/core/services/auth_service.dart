import 'package:firebase_auth/firebase_auth.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User? get currentUser => _auth.currentUser;

  Future<User?> register(String email, String password) async {
    final credentials = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credentials.user;
  }

  Future<User?> login(String email, String password) async {
    final credentials = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    return credentials.user;
  }

  Future<void> logout() => _auth.signOut();

  Future<void> reauthenticate({required AuthCredential credential}) async {
    final user = _auth.currentUser;
    if (user == null) {
      throw FirebaseAuthException(
        code: 'no-current-user',
        message: 'No authenticated user',
      );
    }

    await user.reauthenticateWithCredential(credential);
  }
}
