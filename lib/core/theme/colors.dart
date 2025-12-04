import 'package:flutter/material.dart';

@immutable
class AppColors {
  final Color primary;
  final Color onPrimary;

  final Color secondary;
  final Color onSecondary;

  final Color surface;
  final Color onSurface;

  final Color background;
  final Color onBackground;

  final Color textPrimary;
  final Color textSecondary;

  final Color accent;
  final Color success;
  final Color danger;

  final Color divider;

  final Color bubbleIncoming;
  final Color bubbleOutgoing;

  final Color bubbleIncomingText;
  final Color bubbleOutgoingText;

  const AppColors({
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.surface,
    required this.onSurface,
    required this.background,
    required this.onBackground,
    required this.textPrimary,
    required this.textSecondary,
    required this.accent,
    required this.success,
    required this.danger,
    required this.divider,
    required this.bubbleIncoming,
    required this.bubbleOutgoing,
    required this.bubbleIncomingText,
    required this.bubbleOutgoingText,
  });

  static const light = AppColors(
    primary: Color(0xFF713f52),
    onPrimary: Color(0xFFd1bfb0),

    secondary: Color(0xFF486b7f),
    onSecondary: Color(0xFFd1bfb0),

    surface: Color(0xFF392b35),
    onSurface: Color(0xFFd1bfb0),

    background: Color(0xFFd1bfb0),
    onBackground: Color(0xFF392b35),

    textPrimary: Color(0xFFd1bfb0),
    textSecondary: Color(0xFF333333),

    accent: Color(0xFF7a9c96),
    success: Color(0xFF7FA886),
    danger: Color(0xFFbb474f),

    divider: Color(0xffb3a08f),

    bubbleIncoming: Color(0xFF423952),
    bubbleOutgoing: Color(0xFF444760),
    bubbleIncomingText: Color(0xFFDDDDDD),
    bubbleOutgoingText: Color(0xFFDDDDDD),
  );

  static const dark = AppColors(
    primary: Color(0xFF486b7f),
    onPrimary: Color(0xFFd1bfb0),

    secondary: Color(0xFF713f52),
    onSecondary: Color(0xFFd1bfb0),

    surface: Color(0xFFd1bfb0),
    onSurface: Color(0xFF392b35),

    background: Color(0xFF392b35),
    onBackground: Color(0xFFd1bfb0),

    textPrimary: Color(0xFFd1bfb0),
    textSecondary: Color(0xFF333333),

    accent: Color(0xFF7a9c96),
    success: Color(0xFF7FA886),
    danger: Color(0xFFbb474f),

    divider: Color(0xffb3a08f),

    bubbleIncoming: Color(0xFF423952),
    bubbleOutgoing: Color(0xFF444760),
    bubbleIncomingText: Color(0xFFDDDDDD),
    bubbleOutgoingText: Color(0xFFDDDDDD),
  );
}
