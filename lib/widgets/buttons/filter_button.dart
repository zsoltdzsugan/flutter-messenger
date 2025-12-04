import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class FilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.core.colors;
    final t = context.adaptive;
    final c = context.components;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return LayoutBuilder(
      builder: (context, constraints) {
        final bool enoughWidth = constraints.maxWidth > t.spacing(120);

        final double iconSize = enoughWidth ? t.font(18) : t.font(22);

        late final Color bgColor;
        late final Color textColor;
        if (selected) {
          bgColor = colors.primary;
          textColor = colors.onPrimary;
        } else {
          if (isDark) {
            bgColor = colors.primary.withAlpha(50);
            textColor = colors.textPrimary.withAlpha(150);
          } else {
            bgColor = colors.primary.withAlpha(50);
            textColor = colors.textSecondary;
          }
        }

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: onTap,
            child: Material(
              elevation: selected ? 5 : 0,
              child: Container(
                padding: EdgeInsets.symmetric(
                  vertical: t.spacing(c.spaceSmall),
                ),
                decoration: BoxDecoration(color: bgColor),
                child: Center(
                  child: enoughWidth
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(icon, size: iconSize, color: textColor),
                            SizedBox(width: t.spacing(c.spaceSmall)),
                            Text(
                              label,
                              style: TextStyle(
                                fontSize: t.font(14),
                                color: textColor,
                                fontFamily: context.core.fontFamily,
                                fontFeatures: [FontFeature.enable('smcp')],
                                letterSpacing: 1.25,
                              ),
                            ),
                          ],
                        )
                      : Icon(
                          icon,
                          size: iconSize,
                          color: selected
                              ? colors.onPrimary
                              : colors.textSecondary,
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
