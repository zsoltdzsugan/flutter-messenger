import 'package:flutter/material.dart';
import 'package:messenger/core/design/tokens/component.dart';
import 'package:messenger/core/design/tokens/core.dart';
import 'package:messenger/core/theme/colors.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.light,
      ),
      extensions: const [
        CoreTokens(
          fontFamily: 'Inter',
          baseRadius: 12,
          colors: AppColors.light,
          gridUnit: 4,
        ),
        ComponentTokens(
          mainButtonWidth: 400,
          mainButtonHeight: 30,
          sectionTopPadding: 10,
          sectionBottomPadding: 30,
          avatarSize: 20.0,
          mainLogoHeight: 140,
          spaceXSmall: 6,
          spaceSmall: 10,
          spaceMedium: 14,
          spaceLarge: 18,
          titleLarge: 20.0,
          mainButtonFontSize: 16.0,
          heroSeparatorWidth: 140,
          sidebarWidth: 300,
          searchbarHeight: 70,
        ),
      ],
    );
  }

  static ThemeData dark() {
    return ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blueGrey,
        brightness: Brightness.dark,
      ),
      extensions: const [
        CoreTokens(
          fontFamily: 'Inter',
          baseRadius: 12,
          colors: AppColors.dark,
          gridUnit: 4,
        ),
        ComponentTokens(
          mainButtonWidth: 400,
          mainButtonHeight: 30,
          sectionTopPadding: 10,
          sectionBottomPadding: 30,
          avatarSize: 20.0,
          mainLogoHeight: 140,
          spaceXSmall: 6,
          spaceSmall: 10,
          spaceMedium: 14,
          spaceLarge: 18,
          titleLarge: 20.0,
          mainButtonFontSize: 16.0,
          heroSeparatorWidth: 160,
          sidebarWidth: 300,
          searchbarHeight: 60,
        ),
      ],
    );
  }
}
