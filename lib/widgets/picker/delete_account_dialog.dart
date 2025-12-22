import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/controller/user.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/widgets/input/auth_text_field.dart';

class DeleteAccountDialog extends StatefulWidget {
  const DeleteAccountDialog({super.key});

  @override
  State<DeleteAccountDialog> createState() => _DeleteAccountDialogState();
}

class _DeleteAccountDialogState extends State<DeleteAccountDialog> {
  final TextEditingController _password = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _delete() async {
    final user = UserController.instance.currentUser;
    if (user == null || user.email == null) return;

    if (_password.text.trim().isEmpty) {
      setState(() => _error = 'Add meg a jelszavad!');
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: _password.text.trim(),
      );

      await UserController.instance.deleteAccount(
        password: _password.text.trim(),
      );

      if (!mounted) return;
      Navigator.of(context).pop(true);
    } catch (e) {
      setState(() {
        _loading = false;
        _error = 'Hiba történt a fiók törlésekor';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(MainBgColors.bg);
    final textColor = context.resolveStateColor(SettingsPageColors.text);
    final logoutBgColor = context.resolveStateColor(LogoutBtnColors.bg);
    final logoutTextColor = context.resolveStateColor(LogoutBtnColors.text);

    return AlertDialog(
      backgroundColor: bgColor,
      title: Text(
        'Fiók törlése',
        style: TextStyle(
          color: textColor,
          fontSize: t.font(24),
          fontFeatures: [FontFeature.enable('smcp')],
          letterSpacing: 1.25,
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Ez a művelet végleges! A fiókod és minden adatod törlődik!',
            style: TextStyle(fontSize: t.font(12)),
          ),
          const SizedBox(height: 12),

          AuthTextField(
            controller: _password,
            keyboardType: TextInputType.visiblePassword,
            hint: 'Jelszó',
            obscure: true,
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _loading ? null : () => Navigator.of(context).pop(false),
          child: Text(
            'Mégse',
            style: TextStyle(color: context.core.colors.primary),
          ),
        ),
        FilledButton(
          onPressed: _loading ? null : _delete,
          style: FilledButton.styleFrom(
            backgroundColor: logoutBgColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(
                context.core.baseRadius * t.radiusScale,
              ),
            ),
          ),
          child: _loading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text('Fiók törlése', style: TextStyle(color: logoutTextColor)),
        ),
      ],
    );
  }
}
