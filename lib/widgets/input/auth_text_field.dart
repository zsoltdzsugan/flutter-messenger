import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

class AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String hint;
  final bool obscure;
  final String focusColor;

  const AuthTextField({
    super.key,
    required this.controller,
    required this.keyboardType,
    required this.hint,
    this.obscure = false,
    this.focusColor = "primary",
  });

  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<AuthTextField> {
  late bool _isObscured;
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _isObscured = widget.obscure;
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
        obscureText: _isObscured,
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
          suffixIcon: widget.obscure
              ? Padding(
                  padding: const EdgeInsets.only(top: 2, right: 6),
                  child: IconButton(
                    onPressed: () {
                      setState(() {
                        _isObscured = !_isObscured;
                      });
                    },
                    icon: _isObscured
                        ? const Icon(Icons.visibility_off)
                        : const Icon(Icons.visibility),
                  ),
                )
              : null,
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
