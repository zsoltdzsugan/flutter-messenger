import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeMode _themeMode = ThemeMode.system;
  final String _themeKey = 'system';

  ThemeMode get currentTheme => _themeMode;

  Future<void> getThemeMode() async {
    final prefs = await SharedPreferences.getInstance();
    final themeString = prefs.getString(_themeKey);

    switch (themeString) {
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
      default:
        _themeMode = ThemeMode.system;
        break;
    }

    notifyListeners();
  }

  Future<void> setThemeMode(ThemeMode mode) async {
    final prefs = await SharedPreferences.getInstance();

    _themeMode = mode;

    switch (mode) {
      case ThemeMode.light:
        prefs.setString(_themeKey, 'light');
        break;
      case ThemeMode.dark:
        prefs.setString(_themeKey, 'dark');
        break;
      case ThemeMode.system:
        prefs.setString(_themeKey, 'system');
        break;
    }

    notifyListeners();
  }
}
