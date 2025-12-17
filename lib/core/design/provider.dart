import 'package:flutter/material.dart';
import 'package:messenger/core/design/tokens/accessibility.dart';
import 'package:messenger/core/enums/devices.dart';

class DesignProvider extends ChangeNotifier {
  DeviceType device = DeviceType.mobile;
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
