import 'package:flutter/material.dart';
import 'package:messenger/core/constants.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/app_error.dart';
import 'package:messenger/view/home/home_page.dart';
import 'package:messenger/widgets/buttons/secondary_button.dart';
import 'package:messenger/widgets/hero_header.dart';
import 'package:messenger/widgets/input/auth_text_field.dart';

class RegisterPage extends StatefulWidget {
  static const String route = "RegisterPage";

  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final nameController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;
  String? errorMessage;

  Future<void> doRegister() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      await UserController.instance.register(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        name: nameController.text.trim() ?? '',
      );

      if (!mounted) return;
      Navigator.pushNamed(context, HomePage.route);
    } on AppError catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.message)));
      setState(() => errorMessage = e.toString());
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
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
              animatedTitle: "REGISZTRÁCIÓ",
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
                    AuthTextField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      hint: "Felhasználónév",
                      focusColor: "secondary",
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    AuthTextField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      hint: "Email cím",
                      focusColor: "secondary",
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    AuthTextField(
                      controller: passwordController,
                      keyboardType: TextInputType.visiblePassword,
                      hint: "Jelszó",
                      obscure: true,
                      focusColor: "secondary",
                    ),
                    SizedBox(height: t.spacing(c.spaceSmall)),
                    SecondaryButton(
                      label: "Regisztrálás",
                      onPressed: doRegister,
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
