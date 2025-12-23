import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/services/bug_report.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

Future<void> showBugReportDialog(BuildContext context) async {
  final t = context.adaptive;
  final c = context.components;
  final controller = TextEditingController();
  bool loading = false;
  bool _isSelected = false;
  final _focusNode = FocusNode();

  final textColor = context.resolveStateColor(AuthInputColors.textPrimary);
  final borderColor = context.resolveStateColor(
    AuthInputColors.borderPrimary,
    isSelected: _isSelected,
  );
  final bgColor = context.resolveStateColor(MainBgColors.bg);

  await showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: bgColor,
            title: Text(
              'Hiba jelentése',
              style: TextStyle(
                fontSize: t.font(20),
                fontFeatures: [FontFeature.enable('smcp')],
                letterSpacing: 1.25,
                color: textColor,
              ),
            ),
            content: SizedBox(
              width: t.spacing(c.mainButtonWidth),
              child: TextField(
                focusNode: _focusNode,
                controller: controller,
                maxLines: 10,
                decoration: InputDecoration(
                  hintText: 'Írd le a problémát...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    borderSide: BorderSide(color: borderColor),
                  ),
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: loading ? null : () => Navigator.pop(context),
                child: Text(
                  'Mégse',
                  style: TextStyle(color: context.core.colors.textPrimary),
                ),
              ),
              FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: context.core.colors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(
                      context.core.baseRadius * t.radiusScale,
                    ),
                  ),
                ),
                onPressed: loading
                    ? null
                    : () async {
                        final text = controller.text.trim();
                        if (text.isEmpty) return;
                        setState(() => loading = true);

                        try {
                          final rest = await BugReportService.submit(text);
                          Navigator.pop(context);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Hiba jelentés sikeresen elküldve'),
                            ),
                          );
                        } catch (_) {
                          setState(() => loading = false);
                        }
                      },
                child: loading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'Küldés',
                        style: TextStyle(color: context.core.colors.onPrimary),
                      ),
              ),
            ],
          );
        },
      );
    },
  );
}
