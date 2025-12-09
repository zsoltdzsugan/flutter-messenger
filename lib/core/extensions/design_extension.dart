import 'package:flutter/material.dart';
import 'package:messenger/core/design/state_colors.dart';
import 'package:messenger/core/design/tokens/adaptive.dart';
import 'package:messenger/core/design/tokens/component.dart';
import 'package:messenger/core/design/tokens/core.dart';

extension CoreDesignContext on BuildContext {
  CoreTokens get core => Theme.of(this).extension<CoreTokens>()!;
}

extension AdaptiveDesignContext on BuildContext {
  AdaptiveTokens get adaptive => resolveAdaptiveTokens(this);
}

extension ComponentDesignContext on BuildContext {
  ComponentTokens get components =>
      Theme.of(this).extension<ComponentTokens>()!;
}

extension StateColorContext on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;

  Color resolveStateColor(StateColor config, {bool isSelected = false}) {
    final colors = core.colors;
    final isDark = Theme.of(this).brightness == Brightness.dark;

    return config.resolve(
      colors: colors,
      isDark: isDark,
      isSelected: isSelected,
    );
  }
}

extension ColorTones on Color {
  Color lighten(double amount) {
    final hsv = HSVColor.fromColor(this);
    final v = (hsv.value + amount).clamp(0.0, 1.0);
    return hsv.withValue(v).toColor();
  }

  Color darken(double amount) {
    final hsv = HSVColor.fromColor(this);
    final v = (hsv.value - amount).clamp(0.0, 1.0);
    return hsv.withValue(v).toColor();
  }

  Color saturate(double amount) {
    final hsv = HSVColor.fromColor(this);
    final s = (hsv.saturation + amount).clamp(0.0, 1.0);
    return hsv.withSaturation(s).toColor();
  }

  Color desaturate(double amount) {
    final hsv = HSVColor.fromColor(this);
    final s = (hsv.saturation - amount).clamp(0.0, 1.0);
    return hsv.withSaturation(s).toColor();
  }
}

extension ColorTonePreset on Color {
  Color tone(int t) {
    final hsv = HSVColor.fromColor(this);
    final normalized = (t / 100).clamp(0.0, 1.0);
    return hsv.withValue(normalized).toColor();
  }
}
