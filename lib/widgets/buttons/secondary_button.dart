import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class SecondaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryButton({
    super.key,
    required this.label,
    required this.onPressed,
  });

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
          elevation: 2.5,
          backgroundColor: colors.secondary,
          foregroundColor: colors.onSecondary,
          side: BorderSide(color: colors.secondary),
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
