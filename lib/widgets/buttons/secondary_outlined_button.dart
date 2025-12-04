import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class SecondaryOutlinedButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;

  const SecondaryOutlinedButton({
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
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.onBackground,
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
          ),
        ),
      ),
    );
  }
}
