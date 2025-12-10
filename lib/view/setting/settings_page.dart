import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/enums/icon_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/theme/provider.dart';
import 'package:messenger/widgets/input/app_text_field.dart';
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
  IconState suffixState = IconState.idle;
  bool _isDeleteAccountHovered = false;
  bool _isLogoutHovered = false;

  @override
  void initState() {
    super.initState();
    final userData = UserController.instance.currentUserData;
    nameController = TextEditingController(text: userData?['name'] ?? '');
  }

  Future<void> _saveName() async {
    setState(() {
      suffixState = IconState.saving;
    });
    final user = UserController.instance.currentUser;
    if (user == null) {
      setState(() {
        suffixState = IconState.error;
      });
      _resetSuffix();
      return;
    }

    try {
      await UserController.instance.update({
        'name': nameController.text.trim(),
      });
      setState(() {
        suffixState = IconState.success;
      });
    } catch (e) {
      setState(() {
        suffixState = IconState.error;
      });
    }
    _resetSuffix();
  }

  Future<void> _logout() async {
    await UserController.instance.logout();
    if (!mounted) return;
    Navigator.pushNamedAndRemoveUntil(context, 'WelcomePage', (_) => false);
  }

  void _resetSuffix() {
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() {
          suffixState = IconState.idle;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(MainBgColors.bg);
    final textColor = context.resolveStateColor(SettingsPageColors.text);

    final switchBgActive = context.resolveStateColor(
      ThemeSwitchColors.bgActive,
    );
    final switchBgInactive = context.resolveStateColor(
      ThemeSwitchColors.bgInactive,
    );
    final switchThumbActive = context.resolveStateColor(
      ThemeSwitchColors.thumbActive,
    );
    final switchThumbInactive = context.resolveStateColor(
      ThemeSwitchColors.thumbInactive,
    );
    final switchOutline = context.resolveStateColor(ThemeSwitchColors.outline);

    final deleteTextColor = context.resolveStateColor(
      DeleteAccountColors.text,
      isSelected: _isDeleteAccountHovered,
    );

    final logoutBgColor = context.resolveStateColor(
      LogoutBtnColors.bg,
      isSelected: _isLogoutHovered,
    );
    final logoutTextColor = context.resolveStateColor(
      LogoutBtnColors.text,
      isSelected: _isLogoutHovered,
    );

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
            hint: 'Felhasználónév',
            state: suffixState,
            onPressed: _saveName,
          ),

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
                  activeTrackColor: switchBgActive,
                  activeThumbColor: switchThumbActive,
                  inactiveTrackColor: switchBgInactive,
                  inactiveThumbColor: switchThumbInactive,
                  trackOutlineColor: WidgetStateProperty.all(switchOutline),
                  value: Theme.of(context).brightness == Brightness.dark,
                  onChanged: (val) {
                    final theme = context.read<ThemeProvider>();
                    theme.setThemeMode(val ? ThemeMode.dark : ThemeMode.light);
                  },
                ),
              ],
            ),
          ),

          Spacer(),

          Center(
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: t.spacing(c.spaceSmall)),
              child: MouseRegion(
                onEnter: (_) => setState(() => _isDeleteAccountHovered = true),
                onExit: (_) => setState(() => _isDeleteAccountHovered = false),
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
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
                  child: Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Icon(Icons.delete_rounded, color: deleteTextColor),
                      SizedBox(width: t.spacing(c.spaceXSmall)),
                      Text(
                        "Fiók törlése",
                        style: TextStyle(
                          color: deleteTextColor,
                          fontWeight: FontWeight.bold,
                          fontSize: t.font(10),
                          fontFeatures: [FontFeature.enable('smcp')],
                          letterSpacing: 1.25,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          MouseRegion(
            onEnter: (_) => setState(() => _isLogoutHovered = true),
            onExit: (_) => setState(() => _isLogoutHovered = false),
            cursor: SystemMouseCursors.click,
            child: GestureDetector(
              onTap: _logout,
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(t.spacing(c.spaceMedium)),
                color: logoutBgColor,
                child: Center(
                  child: Text(
                    "Kijelentkezés",
                    style: TextStyle(
                      color: logoutTextColor,
                      fontSize: t.font(14),
                      fontWeight: FontWeight.bold,
                      fontFeatures: [FontFeature.enable('smcp')],
                      letterSpacing: 1.25,
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
