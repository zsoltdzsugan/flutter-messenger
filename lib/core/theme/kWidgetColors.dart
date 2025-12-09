import 'package:messenger/core/design/state_colors.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class MainBgColors {
  static final bg = StateColor(
    light: (c) => c.background,
    dark: (c) => c.background.tone(12),
  );

  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );
}

class MainBtnColors {
  static final bg = StateColor(
    light: (c) => c.primary,
    dark: (c) => c.primary40,
    lightSelected: (c) => c.primary70,
    darkSelected: (c) => c.primary70,
  );
  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );
}

class HeroHeaderColors {
  static final text = StateColor(
    light: (c) => c.surface20,
    dark: (c) => c.surface70,
  );
}

class AuthInputColors {
  static final bgPrimary = StateColor(
    light: (c) => c.primary20,
    dark: (c) => c.primary20,
    lightSelected: (c) => c.primary30,
    darkSelected: (c) => c.primary30,
  );
  static final bgSecondary = StateColor(
    light: (c) => c.secondary20,
    dark: (c) => c.secondary20,
    lightSelected: (c) => c.secondary30,
    darkSelected: (c) => c.secondary30,
  );
  static final text = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background70,
    darkSelected: (c) => c.surface70,
  );
  static final hint = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background40,
    darkSelected: (c) => c.surface40,
  );
}

class FilterBtnColors {
  static final bg = StateColor(
    light: (c) => c.primary40,
    dark: (c) => c.primary20,
    lightSelected: (c) => c.primary,
    darkSelected: (c) => c.primary40,
  );

  static final text = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background70,
    darkSelected: (c) => c.surface70,
  );
}

class SearchBtnColors {
  static final bg = StateColor(
    light: (c) => c.primary40,
    dark: (c) => c.primary20,
    lightSelected: (c) => c.primary,
    darkSelected: (c) => c.primary40,
  );

  static final text = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );

  static final hint = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background40,
    darkSelected: (c) => c.surface40,
  );
}

class AvatarColors {
  static final bg = StateColor(
    light: (c) => c.primary80,
    dark: (c) => c.primary50,
  );

  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
  );
}

class SettingIconColors {
  static final bg = StateColor(
    light: (c) => c.primary80,
    dark: (c) => c.primary70,
  );
}

class SettingsPageColors {
  static final text = StateColor(
    light: (c) => c.surface20,
    dark: (c) => c.surface70,
  );
}

class NameColors {
  static final text = StateColor(
    light: (c) => c.surface20,
    dark: (c) => c.surface70,
  );
}
