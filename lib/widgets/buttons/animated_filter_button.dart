import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class AnimatedFilterButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool isSelected;
  final VoidCallback onTap;
  final Duration animationDuration;

  const AnimatedFilterButton({
    super.key,
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.onTap,
    this.animationDuration = const Duration(milliseconds: 250),
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.core.colors;
    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(
      FilterBtnColors.bg,
      isSelected: isSelected,
    );
    final textColor = context.resolveStateColor(
      FilterBtnColors.text,
      isSelected: isSelected,
    );
    final double elevation = isSelected ? 5.0 : 0.0;
    final BorderRadius borderRadius = isSelected
        ? BorderRadius.circular(context.core.baseRadius * t.radiusScale)
        : BorderRadius.circular(0);

    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: animationDuration,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: borderRadius,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(elevation > 0 ? 20 : 0),
              spreadRadius: elevation / 5,
              blurRadius: elevation,
              offset: Offset(0, elevation / 2),
            ),
          ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            splashColor: colors.primary.withOpacity(0.3),
            highlightColor: colors.primary.withOpacity(0.15),
            onTap: onTap, // InkWell handles the tap feedback
            borderRadius: borderRadius, // Match the container's border radius
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: t.spacing(c.spaceSmall)),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final bool enoughWidth =
                      constraints.maxWidth > t.spacing(120);
                  final double iconSize = enoughWidth ? t.font(18) : t.font(22);

                  // AnimatedSwitcher can provide a smooth transition for the content
                  return AnimatedSwitcher(
                    duration: animationDuration,
                    transitionBuilder: (child, animation) {
                      return FadeTransition(opacity: animation, child: child);
                    },
                    child: enoughWidth
                        ? Row(
                            key: const ValueKey(
                              'row',
                            ), // Key is important for AnimatedSwitcher
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(icon, size: iconSize, color: textColor),
                              SizedBox(width: t.spacing(c.spaceXSmall)),
                              Text(
                                label,
                                style: TextStyle(
                                  fontSize: t.font(14),
                                  color: textColor,
                                  fontFamily: context.core.fontFamily,
                                  fontFeatures: const [
                                    FontFeature.enable('smcp'),
                                  ],
                                  letterSpacing: 1.25,
                                ),
                              ),
                            ],
                          )
                        : Icon(
                            icon,
                            key: const ValueKey(
                              'icon',
                            ), // Key is important for AnimatedSwitcher
                            size: iconSize,
                            color: textColor,
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
