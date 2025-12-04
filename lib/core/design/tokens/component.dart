import 'package:flutter/material.dart';

@immutable
class ComponentTokens extends ThemeExtension<ComponentTokens> {
  final double mainButtonWidth;
  final double mainButtonHeight;
  final double sectionTopPadding;
  final double sectionBottomPadding;
  final double avatarSize;
  final double mainLogoHeight;
  final double spaceXSmall;
  final double spaceSmall;
  final double spaceMedium;
  final double spaceLarge;
  final double titleLarge;
  final double mainButtonFontSize;
  final double heroSeparatorWidth;
  final double sidebarWidth;
  final double searchbarHeight;

  const ComponentTokens({
    required this.mainButtonWidth,
    required this.mainButtonHeight,
    required this.sectionTopPadding,
    required this.sectionBottomPadding,
    required this.avatarSize,
    required this.mainLogoHeight,
    required this.spaceXSmall,
    required this.spaceSmall,
    required this.spaceMedium,
    required this.spaceLarge,
    required this.titleLarge,
    required this.mainButtonFontSize,
    required this.heroSeparatorWidth,
    required this.sidebarWidth,
    required this.searchbarHeight,
  });

  @override
  ComponentTokens copyWith({
    double? mainButtonWidth,
    double? mainButtonHeight,
    double? sectionTopPadding,
    double? sectionBottomPadding,
    double? avatarSize,
    double? mainLogoHeight,
    double? spaceXSmall,
    double? spaceSmall,
    double? spaceMedium,
    double? spaceLarge,
    double? titleLarge,
    double? mainButtonFontSize,
    double? heroSeparatorWidth,
    double? sidebarWidth,
    double? searchbarHeight,
  }) {
    return ComponentTokens(
      mainButtonWidth: mainButtonWidth ?? this.mainButtonWidth,
      mainButtonHeight: mainButtonHeight ?? this.mainButtonHeight,
      sectionTopPadding: sectionTopPadding ?? this.sectionTopPadding,
      sectionBottomPadding: sectionTopPadding ?? this.sectionBottomPadding,
      avatarSize: avatarSize ?? this.avatarSize,
      mainLogoHeight: mainLogoHeight ?? this.mainLogoHeight,
      spaceXSmall: spaceXSmall ?? this.spaceXSmall,
      spaceSmall: spaceSmall ?? this.spaceSmall,
      spaceMedium: spaceMedium ?? this.spaceMedium,
      spaceLarge: spaceLarge ?? this.spaceLarge,
      titleLarge: titleLarge ?? this.titleLarge,
      mainButtonFontSize: mainButtonFontSize ?? this.mainButtonFontSize,
      heroSeparatorWidth: heroSeparatorWidth ?? this.heroSeparatorWidth,
      sidebarWidth: sidebarWidth ?? this.sidebarWidth,
      searchbarHeight: searchbarHeight ?? this.searchbarHeight,
    );
  }

  @override
  ComponentTokens lerp(ThemeExtension<ComponentTokens>? other, double t) {
    if (other is! ComponentTokens) return this;
    return this;
  }
}
