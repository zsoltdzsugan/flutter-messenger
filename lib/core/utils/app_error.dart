class AppError implements Exception {
  final String code;
  final String message;

  AppError(this.code, this.message);

  @override
  String toString() => message;

  static String firebaseAuthMessage(String code) {
    const registerErrors = {
      'weak-password': 'A jelszónak legalább 6 karakternek kell lennie.',
      'email-already-in-use': 'Ez az email cím már foglalt.',
      'invalid-email': 'Érvénytelen email cím.',
    };

    const loginErrors = {
      'user-not-found': 'Nincs ilyen felhasználó.',
      'wrong-password': 'Hibás jelszó.',
      'invalid-credential': 'Hibás hitelesítési adatok.',
      'invalid-login-credentials': 'Hibás bejelentkezési adatok.',
    };

    return registerErrors[code] ??
        loginErrors[code] ??
        'Hitelesítési hiba történt. Próbáld meg újra.';
  }
}
