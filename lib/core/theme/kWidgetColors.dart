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

  static final border = StateColor(
    light: (c) => c.background80,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );
}

class SecondaryBtnColors {
  static final bg = StateColor(
    light: (c) => c.secondary,
    dark: (c) => c.secondary70,
    lightSelected: (c) => c.secondary80,
    darkSelected: (c) => c.secondary80,
  );
  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );

  static final border = StateColor(
    light: (c) => c.background80,
    dark: (c) => c.surface50,
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
    light: (c) => c.primary50,
    dark: (c) => c.primary20,
    lightSelected: (c) => c.primary60,
    darkSelected: (c) => c.primary30,
  );
  static final bgSecondary = StateColor(
    light: (c) => c.secondary50,
    dark: (c) => c.secondary20,
    lightSelected: (c) => c.secondary60,
    darkSelected: (c) => c.secondary30,
  );
  static final text = StateColor(
    light: (c) => c.background60,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background70,
    darkSelected: (c) => c.surface70,
  );
  static final hint = StateColor(
    light: (c) => c.background50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.background50,
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

class ThemeSwitchColors {
  static final bgActive = StateColor(
    light: (c) => c.primary50,
    dark: (c) => c.primary50,
  );
  static final bgInactive = StateColor(
    light: (c) => c.background80,
    dark: (c) => c.primary50,
  );
  static final thumbActive = StateColor(
    light: (c) => c.primary20,
    dark: (c) => c.primary20,
  );
  static final thumbInactive = StateColor(
    light: (c) => c.primary70,
    dark: (c) => c.primary20,
  );

  static final outline = StateColor(
    light: (c) => c.primary70,
    dark: (c) => c.primary30,
  );
}

class DeleteAccountColors {
  static final bg = StateColor(
    light: (c) => c.danger70,
    dark: (c) => c.danger20,
    lightSelected: (c) => c.danger50,
    darkSelected: (c) => c.danger30,
  );

  static final text = StateColor(
    light: (c) => c.surface70,
    dark: (c) => c.danger60,
    lightSelected: (c) => c.danger70,
    darkSelected: (c) => c.surface70,
  );
}

class LogoutBtnColors {
  static final bg = StateColor(
    light: (c) => c.danger60,
    dark: (c) => c.danger30,
    lightSelected: (c) => c.danger70,
    darkSelected: (c) => c.danger40,
  );

  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
  );
}
