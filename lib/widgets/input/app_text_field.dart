import 'package:flutter/material.dart';
import 'package:messenger/core/enums/icon_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hint;
  final String focusColor;
  final Function()? onPressed;
  final IconState state;

  const AppTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    required this.state,
    this.focusColor = "primary",
    this.onPressed,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode();

    _focusNode.addListener(() {
      setState(() {});
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
    final bool isFocused = _focusNode.hasFocus;

    final bgColor = context.resolveStateColor(
      widget.focusColor == "primary"
          ? AuthInputColors.bgPrimary
          : AuthInputColors.bgSecondary,
      isSelected: isFocused,
    );
    final textColor = context.resolveStateColor(
      AuthInputColors.text,
      isSelected: isFocused,
    );
    final hintColor = context.resolveStateColor(
      AuthInputColors.hint,
      isSelected: isFocused,
    );

    return SizedBox(
      width: t.spacing(c.mainButtonWidth),
      height: t.spacing(c.mainButtonHeight),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        keyboardType: widget.keyboardType,
        cursorColor: textColor,
        cursorHeight: t.font(16),
        textAlignVertical: TextAlignVertical(y: 0.75),
        style: TextStyle(
          color: textColor,
          fontSize: t.font(14),
          fontFamily: context.core.fontFamily,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColor,
          suffixIconColor: textColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 6.0),
            child: IconButton(
              icon: _buildSuffixIcon(widget.state),
              onPressed: widget.onPressed,
            ),
          ),
          hintText: widget.hint,
          hintStyle: TextStyle(
            color: hintColor,
            fontSize: t.font(14),
            fontFeatures: [FontFeature.enable('smcp')],
            letterSpacing: 1.25,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
            borderSide: BorderSide(color: textColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
            borderSide: BorderSide(color: textColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
            borderSide: BorderSide(color: textColor),
          ),
        ),
      ),
    );
  }
}

Widget _buildSuffixIcon(IconState state) {
  switch (state) {
    case IconState.saving:
      return const SizedBox(
        width: 20,
        height: 20,
        child: CircularProgressIndicator(strokeWidth: 2),
      );
    case IconState.success:
      return const Icon(Icons.check, color: Colors.green);
    case IconState.error:
      return const Icon(Icons.close, color: Colors.red);
    default:
      return const Icon(Icons.save);
  }
}
