import 'package:flutter/material.dart';
import 'package:messenger/core/theme/colors.dart';

@immutable
class CoreTokens extends ThemeExtension<CoreTokens> {
  final String fontFamily;
  final double baseRadius;
  final AppColors colors;
  final int gridUnit;

  const CoreTokens({
    required this.fontFamily,
    required this.baseRadius,
    required this.colors,
    required this.gridUnit,
  });

  @override
  ThemeExtension<CoreTokens> copyWith({
    String? fontFamily,
    double? baseRadius,
    AppColors? colors,
    int? gridUnit,
  }) {
    return CoreTokens(
      fontFamily: fontFamily ?? this.fontFamily,
      baseRadius: baseRadius ?? this.baseRadius,
      colors: colors ?? this.colors,
      gridUnit: gridUnit ?? this.gridUnit,
    );
  }

  @override
  ThemeExtension<CoreTokens> lerp(
    covariant ThemeExtension<CoreTokens>? other,
    double t,
  ) {
    if (other is! CoreTokens) return this;
    return CoreTokens(
      fontFamily: other.fontFamily,
      baseRadius: other.baseRadius,
      colors: other.colors,
      gridUnit: other.gridUnit,
    );
  }
}
