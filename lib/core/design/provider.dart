import 'package:flutter/material.dart';
import 'package:messenger/core/design/devices.dart';
import 'package:messenger/core/design/tokens/accessibility.dart';

class DesignProvider extends ChangeNotifier {
  DeviceClass device = DeviceClass.mobile;
  AccessibilitySettings accessibilitySettings = AccessibilitySettings(
    textScale: 1.0,
    highContrast: false,
    reduceMotion: false,
  );

  void updateAccessibility(AccessibilitySettings settings) {
    accessibilitySettings = settings;
    notifyListeners();
  }
}
