import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class SearchField extends StatefulWidget {
  final TextEditingController controller;

  const SearchField({super.key, required this.controller});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  final FocusNode _focusNode = FocusNode();
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();

    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    final bgColor = context.resolveStateColor(
      SearchBtnColors.bg,
      isSelected: _isFocused,
    );
    final textColor = context.resolveStateColor(
      SearchBtnColors.text,
      isSelected: _isFocused,
    );
    final hintColor = context.resolveStateColor(
      SearchBtnColors.hint,
      isSelected: _isFocused,
    );

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: t.spacing(c.spaceXSmall)),
      child: Material(
        elevation: _isFocused ? 5.0 : 0.0,
        child: ValueListenableBuilder<TextEditingValue>(
          valueListenable: widget.controller,
          builder: (_, value, __) {
            return TextField(
              controller: widget.controller,
              focusNode: _focusNode,
              cursorColor: textColor,
              cursorHeight: t.font(16),
              textAlignVertical: TextAlignVertical.center,
              style: TextStyle(
                color: textColor,
                fontSize: t.font(14),
                height: 1.2,
              ),
              decoration: InputDecoration(
                filled: true,
                fillColor: bgColor,
                hintText: 'Keresés...',
                hintStyle: TextStyle(
                  color: hintColor,
                  fontSize: t.font(14),
                  height: 1.2,
                  fontFeatures: const [FontFeature.enable('smcp')],
                  letterSpacing: 1.25,
                ),
                suffixIcon: value.text.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: IconButton(
                          onPressed: () => widget.controller.clear(),
                          icon: const Icon(Icons.close_rounded),
                          iconSize: t.font(20),
                        ),
                      )
                    : null,
                suffixIconColor: textColor,
                border: InputBorder.none,
                focusedBorder: InputBorder.none,
                enabledBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: t.spacing(c.spaceSmall),
                  vertical: t.spacing(c.spaceMedium),
                ),
                isDense: true,
              ),
            );
          },
        ),
      ),
    );
  }
}
