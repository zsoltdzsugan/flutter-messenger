import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/theme/provider.dart';
import 'package:messenger/widgets/buttons/animated_filter_button.dart';
import 'package:messenger/widgets/input/text_field.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  static const String route = 'SettingsPage';
  final VoidCallback onClose;

  const SettingsPage({super.key, required this.onClose});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  late final TextEditingController nameController;
  var test = false;

  @override
  void initState() {
    super.initState();
    final userData = UserController.instance.currentUserData;
    nameController = TextEditingController(text: userData?['name'] ?? '');
  }

  Future<void> _saveName() async {
    final user = UserController.instance.currentUser;
    if (user == null) return;

    await UserController.instance.update({'name': nameController.text.trim()});
    setState(() {});
  }

  Future<void> _logout() async {
    await UserController.instance.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'WelcomePage', (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;
    final colors = context.core.colors;

    final bgColor = context.resolveStateColor(MainBgColors.bg);
    final textColor = context.resolveStateColor(SettingsPageColors.text);

    return Container(
      decoration: BoxDecoration(color: bgColor),
      padding: EdgeInsets.symmetric(
        vertical: t.spacing(c.spaceSmall),
        horizontal: t.spacing(c.spaceSmall),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Beállítások",
            style: TextStyle(
              color: textColor,
              fontSize: t.font(c.titleLarge),
              fontFeatures: [FontFeature.enable('smcp')],
              letterSpacing: 1.25,
            ),
          ),

          SizedBox(height: t.spacing(c.spaceMedium)),

          Text(
            "Felhasználónév",
            style: TextStyle(
              color: textColor,
              fontSize: t.font(14),
              fontFeatures: [FontFeature.enable('smcp')],
              letterSpacing: 1.25,
            ),
          ),

          SizedBox(height: t.spacing(c.spaceXSmall)),

          AppTextField(
            controller: nameController,
            keyboardType: TextInputType.name,
            focusColor: "primary",
            hint: '',
          ),

          SizedBox(height: t.spacing(c.spaceMedium)),

          IconButton(onPressed: _saveName, icon: Icon(Icons.save)),
          ElevatedButton(onPressed: _saveName, child: Text("Mentés")),

          SizedBox(height: t.spacing(c.spaceMedium)),

          Padding(
            padding: EdgeInsets.only(bottom: t.spacing(c.spaceMedium)),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Téma",
                  style: TextStyle(
                    color: textColor,
                    fontSize: t.font(14),
                    fontFeatures: [FontFeature.enable('smcp')],
                    letterSpacing: 1.25,
                  ),
                ),

                Switch(
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (val) {
                    final theme = context.read<ThemeProvider>();
                    theme.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),

          AnimatedFilterButton(
            label: 'label',
            icon: Icons.tab,
            isSelected: test,
            onTap: () {
              setState(() {
                test = !test;
              });
            },
          ),
          Spacer(),

          GestureDetector(
            onTap: () async {
              await UserController.instance.delete();
              // Navigate back to welcome/login
              if (!mounted) return;
              Navigator.pushNamedAndRemoveUntil(
                context,
                'WelcomePage',
                (_) => false,
              );
            },
            child: Container(
              padding: EdgeInsets.all(t.spacing(c.spaceMedium)),
              color: colors.danger.withAlpha(150),
              child: Center(
                child: Text(
                  "Fiók törlése",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),

          MouseRegion(
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _logout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(t.spacing(c.spaceMedium)),
                color: colors.danger,
                child: Center(
                  child: Text(
                    "Kijelentkezés",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: t.font(14),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
