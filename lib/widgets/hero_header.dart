import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class HeroHeader extends StatelessWidget {
  final String logoTag;
  final String logoPath;
  final String animatedTitle;
  final double logoHeight;
  final double titleSize;
  final double lineWidth;

  const HeroHeader({
    super.key,
    required this.logoTag,
    required this.logoPath,
    required this.animatedTitle,
    required this.logoHeight,
    required this.titleSize,
    required this.lineWidth,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final colors = context.core.colors;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Hero(
          tag: logoTag,
          child: SizedBox(
            height: t.spacing(logoHeight),
            child: Image.asset(logoPath),
          ),
        ),
        SizedBox(height: t.spacing(c.spaceXSmall)),
        Center(
          child: Container(
            height: 2.0,
            width: t.spacing(lineWidth),
            color: colors.onBackground,
          ),
        ),
        Center(
          child: Text(
            animatedTitle,
            style: TextStyle(
              fontSize: t.spacing(titleSize),
              color: colors.onBackground,
              fontFamily: context.core.fontFamily,
              fontWeight: FontWeight.w400,
              letterSpacing: 1.25,
            ),
          ),
        ),
      ],
    );
  }
}
