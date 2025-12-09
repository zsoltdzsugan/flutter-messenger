import 'package:flutter/material.dart';
import 'package:messenger/core/theme/colors.dart';

@immutable
class StateColor {
  final Color Function(AppColors c) light;
  final Color Function(AppColors c) dark;
  final Color Function(AppColors c)? lightSelected;
  final Color Function(AppColors c)? darkSelected;

  const StateColor({
    required this.light,
    required this.dark,
    this.lightSelected,
    this.darkSelected,
  });

  Color resolve({
    required AppColors colors,
    required bool isDark,
    bool isSelected = false,
  }) {
    if (isSelected) {
      final selected = isDark ? darkSelected : lightSelected;

      if (selected != null) {
        return selected(colors);
      }

      return isDark ? dark(colors) : light(colors);
    }

    return isDark ? dark(colors) : light(colors);
  }
}
