import 'package:flutter/material.dart';
import 'package:messenger/core/constants.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/buttons/main_button.dart';
import 'package:messenger/widgets/hero_header.dart';
import 'package:messenger/widgets/input/text_field.dart';

class LoginPage extends StatefulWidget {
  static const String route = "LoginPage";

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;
  String? errorMessage;

  Future<void> doLogin() async {
    setState(() {
      loading = true;
      errorMessage = null;
    });

    try {
      await UserController.instance.login(
        emailController.text.trim(),
        passwordController.text.trim(),
      );

      await UserController.instance.getCurrentUserData();

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('HomePage');
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final colors = context.core.colors;

    final bgColor = context.resolveStateColor(MainBgColors.bg);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(backgroundColor: bgColor),
      body: SafeArea(
        child: Column(
          children: [
            //SizedBox(height: t.spacing(c.sectionTopPadding)),
            HeroHeader(
              logoTag: "mainLogo",
              logoPath: kLogoPath,
              animatedTitle: "BEJELENTKEZÉS",
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
                    AppTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hint: "Email",
                      focusColor: "primary",
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    AppTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hint: "Jelszó",
                      obscure: true,
                      focusColor: "primary",
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    MainButton(label: "Login", onPressed: doLogin),
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
