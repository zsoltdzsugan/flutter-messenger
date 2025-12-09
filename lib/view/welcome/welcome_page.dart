import 'package:flutter/material.dart';
import 'package:messenger/core/constants.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/view/login/login_page.dart';
import 'package:messenger/view/register/register_page.dart';
import 'package:messenger/widgets/buttons/main_button.dart';
import 'package:messenger/widgets/buttons/secondary_button.dart';
import 'package:messenger/widgets/hero_header.dart';

class WelcomePage extends StatelessWidget {
  static const String route = "WelcomePage";

  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final bgColor = context.resolveStateColor(MainBgColors.bg);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        automaticallyImplyActions: false,
        backgroundColor: bgColor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            //SizedBox(height: t.spacing(c.sectionTopPadding)),
            HeroHeader(
              logoTag: "mainLogo",
              logoPath: kLogoPath,
              animatedTitle: "MESSENGER",
              logoHeight: c.mainLogoHeight,
              titleSize: c.titleLarge,
              lineWidth: c.heroSeparatorWidth,
            ),
            Spacer(),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: t.spacing(24)),
              child: Center(
                child: Column(
                  children: [
                    MainButton(
                      label: "Bejelentkezés",
                      onPressed: () {
                        Navigator.pushNamed(context, LoginPage.route);
                      },
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    SecondaryButton(
                      label: "Regisztráció",
                      onPressed: () {
                        Navigator.pushNamed(context, RegisterPage.route);
                      },
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: t.spacing(c.sectionBottomPadding)),
          ],
        ),
      ),
    );
  }
}
