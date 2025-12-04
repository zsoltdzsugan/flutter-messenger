import 'package:flutter/material.dart';
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
