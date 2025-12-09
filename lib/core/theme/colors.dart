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

  // ---------- PRIMARY TONES ----------
  Color get primary10 => _tone(primary, 10);
  Color get primary20 => _tone(primary, 20);
  Color get primary30 => _tone(primary, 30);
  Color get primary40 => _tone(primary, 40);
  Color get primary50 => _tone(primary, 50);
  Color get primary60 => _tone(primary, 60);
  Color get primary70 => primary; // anchor
  Color get primary80 => _tone(primary, 80);
  Color get primary90 => _tone(primary, 90);
  Color get primary100 => _tone(primary, 100);

  // ---------- SECONDARY TONES ----------
  Color get secondary10 => _tone(secondary, 10);
  Color get secondary20 => _tone(secondary, 20);
  Color get secondary30 => _tone(secondary, 30);
  Color get secondary40 => _tone(secondary, 40);
  Color get secondary50 => _tone(secondary, 50);
  Color get secondary60 => _tone(secondary, 60);
  Color get secondary70 => secondary;
  Color get secondary80 => _tone(secondary, 80);
  Color get secondary90 => _tone(secondary, 90);
  Color get secondary100 => _tone(secondary, 100);

  // ---------- BACKGROUND TONES ----------
  Color get background10 => _tone(background, 10);
  Color get background20 => _tone(background, 20);
  Color get background30 => _tone(background, 30);
  Color get background40 => _tone(background, 40);
  Color get background50 => _tone(background, 50);
  Color get background60 => _tone(background, 60);
  Color get background70 => background;
  Color get background80 => _tone(background, 80);
  Color get background90 => _tone(background, 90);
  Color get background100 => _tone(background, 100);

  // ---------- SURFACE TONES ----------
  Color get surface10 => _tone(surface, 10);
  Color get surface20 => _tone(surface, 20);
  Color get surface30 => _tone(surface, 30);
  Color get surface40 => _tone(surface, 40);
  Color get surface50 => _tone(surface, 50);
  Color get surface60 => _tone(surface, 60);
  Color get surface70 => surface;
  Color get surface80 => _tone(surface, 80);
  Color get surface90 => _tone(surface, 90);
  Color get surface100 => _tone(surface, 100);

  // ---------- ACCENT ----------
  Color get accent10 => _tone(accent, 10);
  Color get accent20 => _tone(accent, 20);
  Color get accent30 => _tone(accent, 30);
  Color get accent40 => _tone(accent, 40);
  Color get accent50 => _tone(accent, 50);
  Color get accent60 => _tone(accent, 60);
  Color get accent70 => accent;
  Color get accent80 => _tone(accent, 80);
  Color get accent90 => _tone(accent, 90);
  Color get accent100 => _tone(accent, 100);

  // ---------- SUCCESS ----------
  Color get success10 => _tone(success, 10);
  Color get success20 => _tone(success, 20);
  Color get success30 => _tone(success, 30);
  Color get success40 => _tone(success, 40);
  Color get success50 => _tone(success, 50);
  Color get success60 => _tone(success, 60);
  Color get success70 => success;
  Color get success80 => _tone(success, 80);
  Color get success90 => _tone(success, 90);
  Color get success100 => _tone(success, 100);

  // ---------- DANGER ----------
  Color get danger10 => _tone(danger, 10);
  Color get danger20 => _tone(danger, 20);
  Color get danger30 => _tone(danger, 30);
  Color get danger40 => _tone(danger, 40);
  Color get danger50 => _tone(danger, 50);
  Color get danger60 => _tone(danger, 60);
  Color get danger70 => danger;
  Color get danger80 => _tone(danger, 80);
  Color get danger90 => _tone(danger, 90);
  Color get danger100 => _tone(danger, 100);

  // ---------- TONE SHIFT ----------
  Color _tone(Color base, int t) {
    final hsv = HSVColor.fromColor(base);

    final factor = switch (t) {
      10 => 0.15,
      20 => 0.30,
      30 => 0.45,
      40 => 0.60,
      50 => 0.75,
      60 => 0.90,
      70 => 1.00,
      80 => 1.10,
      90 => 1.25,
      100 => 1.45,
      _ => 1.0,
    };

    return hsv.withValue((hsv.value * factor).clamp(0.0, 1.0)).toColor();
  }

  // ---------- LIGHT / DARK ----------
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
