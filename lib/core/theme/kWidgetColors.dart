import 'package:messenger/core/design/state_colors.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class MainBgColors {
  static final bg = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.background.tone(12),
  );

  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );

  static final chat = StateColor(
    light: (c) => c.background60,
    dark: (c) => c.background30,
  );
}

class MainBtnColors {
  static final bg = StateColor(
    light: (c) => c.primary,
    dark: (c) => c.primary40,
    lightSelected: (c) => c.primary80,
    darkSelected: (c) => c.primary70,
  );
  static final text = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.surface70,
    lightSelected: (c) => c.background90,
    darkSelected: (c) => c.surface90,
  );

  static final border = StateColor(
    light: (c) => c.surface50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.surface90,
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
    light: (c) => c.surface50,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.surface90,
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
    light: (c) => c.background90,
    dark: (c) => c.primary20,
    lightSelected: (c) => c.background80,
    darkSelected: (c) => c.primary30,
  );
  static final bgSecondary = StateColor(
    light: (c) => c.background90,
    dark: (c) => c.secondary20,
    lightSelected: (c) => c.background80,
    darkSelected: (c) => c.secondary30,
  );
  static final textPrimary = StateColor(
    light: (c) => c.primary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.primary50,
    darkSelected: (c) => c.surface70,
  );
  static final textSecondary = StateColor(
    light: (c) => c.secondary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.secondary50,
    darkSelected: (c) => c.surface70,
  );

  static final hintPrimary = StateColor(
    light: (c) => c.primary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.primary90,
    darkSelected: (c) => c.surface40,
  );
  static final hintSecondary = StateColor(
    light: (c) => c.secondary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.secondary90,
    darkSelected: (c) => c.surface40,
  );

  static final borderPrimary = StateColor(
    light: (c) => c.primary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.primary80,
    darkSelected: (c) => c.surface70,
  );

  static final borderSecondary = StateColor(
    light: (c) => c.secondary70,
    dark: (c) => c.surface50,
    lightSelected: (c) => c.secondary80,
    darkSelected: (c) => c.surface70,
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

  static final unreadBg = StateColor(
    light: (c) => c.accent60,
    dark: (c) => c.accent,
  );

  static final unreadText = StateColor(
    light: (c) => c.background90,
    dark: (c) => c.surface90,
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

class InputDividerColors {
  static final bg = StateColor(light: (c) => c.primary, dark: (c) => c.surface);
}

class ChatBubbleColors {
  static final incomingBg = StateColor(
    light: (c) => c.bubbleIncoming,
    dark: (c) => c.bubbleIncoming,
    lightSelected: (c) => c.bubbleIncoming,
    darkSelected: (c) => c.bubbleIncoming,
  );

  static final incomingText = StateColor(
    light: (c) => c.bubbleIncomingText,
    dark: (c) => c.bubbleIncomingText,
    lightSelected: (c) => c.bubbleIncomingText,
    darkSelected: (c) => c.bubbleIncomingText,
  );

  static final outgoingBg = StateColor(
    light: (c) => c.bubbleOutgoing,
    dark: (c) => c.bubbleOutgoing,
    lightSelected: (c) => c.bubbleOutgoing,
    darkSelected: (c) => c.bubbleOutgoing,
  );

  static final outgoingText = StateColor(
    light: (c) => c.bubbleOutgoingText,
    dark: (c) => c.bubbleOutgoingText,
    lightSelected: (c) => c.bubbleOutgoingText,
    darkSelected: (c) => c.bubbleOutgoingText,
  );

  static final timestamp = StateColor(
    light: (c) => c.surface50,
    dark: (c) => c.surface50,
  );
  static final seen = StateColor(
    light: (c) => c.textSecondary,
    dark: (c) => c.surface30,
    lightSelected: (c) => c.accent,
    darkSelected: (c) => c.accent60,
  );

  static final context = StateColor(
    light: (c) => c.background,
    dark: (c) => c.surface50,
  );
}

class ContextMenuColors {
  static final icon = StateColor(
    light: (c) => c.background,
    dark: (c) => c.surface,
  );
}

class PickerColors {
  static final bg = StateColor(
    light: (c) => c.background70,
    dark: (c) => c.primary20,
  );
  static final border = StateColor(
    light: (c) => c.surface20,
    dark: (c) => c.surface50,
  );
}
