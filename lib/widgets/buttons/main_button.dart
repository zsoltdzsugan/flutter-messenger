import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class MainButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const MainButton({super.key, required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final colors = context.core.colors;

    return SizedBox(
      width: t.spacing(c.mainButtonWidth),
      height: t.spacing(c.mainButtonHeight),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          elevation: 5.0,
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          side: BorderSide(color: colors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
          ),
        ),
        onPressed: onPressed,
        child: Text(
          label,
          style: TextStyle(
            fontSize: t.font(c.mainButtonFontSize),
            fontFamily: context.core.fontFamily,
            fontFeatures: [FontFeature.enable('smcp')],
            letterSpacing: 1.25,
          ),
        ),
      ),
    );
  }
}
