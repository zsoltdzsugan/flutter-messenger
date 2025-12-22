import 'package:flutter/material.dart';
import 'package:messenger/core/enums/icon_state.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';
import 'package:messenger/core/utils/icon_data.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String hint;
  final String focusColor;
  final Function()? onPressed;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final IconState state;
  final IconData? idleIcon;
  final List<AppIconData>? prefixIcons;

  const AppTextField({
    super.key,
    required this.controller,
    this.focusNode,
    required this.keyboardType,
    required this.hint,
    required this.state,
    this.focusColor = "primary",
    this.onPressed,
    this.onChanged,
    this.onSubmitted,
    this.idleIcon = Icons.save,
    this.prefixIcons,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late FocusNode _focusNode;

  @override
  void initState() {
    super.initState();
    _focusNode = widget.focusNode ?? FocusNode();

    _focusNode.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  Widget _buildPrefixIcon() {
    final icons = widget.prefixIcons;

    if (icons == null || icons.isEmpty) {
      return const SizedBox.shrink();
    }

    final dividerColor = context.resolveStateColor(InputDividerColors.bg);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ...widget.prefixIcons!.map((data) {
          return IconButton(
            onPressed: data.onTap,
            icon: Icon(data.icon),
            iconSize: data.iconSize,
          );
        }),
        VerticalDivider(indent: 10, endIndent: 10, color: dividerColor),
      ],
    );
  }

  Widget _buildSuffixIcon(IconState state, BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    switch (state) {
      case IconState.saving:
        return SizedBox(
          width: t.font(20),
          height: t.font(20),
          child: const CircularProgressIndicator(strokeWidth: 2),
        );
      case IconState.success:
        return Icon(Icons.check, color: Colors.green, size: t.font(20));
      case IconState.error:
        return Icon(Icons.close, color: Colors.red, size: t.font(20));
      default:
        return Icon(widget.idleIcon, size: t.font(20));
    }
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
      widget.focusColor == "primary"
          ? AuthInputColors.textPrimary
          : AuthInputColors.textSecondary,
      isSelected: isFocused,
    );
    final hintColor = context.resolveStateColor(
      widget.focusColor == "primary"
          ? AuthInputColors.hintPrimary
          : AuthInputColors.hintSecondary,
      isSelected: isFocused,
    );
    final borderColor = context.resolveStateColor(
      widget.focusColor == "primary"
          ? AuthInputColors.borderPrimary
          : AuthInputColors.borderSecondary,
      isSelected: isFocused,
    );

    return SizedBox(
      width: t.spacing(c.mainButtonWidth),
      height: t.spacing(c.mainButtonHeight),
      child: TextField(
        controller: widget.controller,
        focusNode: _focusNode,
        textInputAction: TextInputAction.send,
        keyboardType: widget.keyboardType,
        onChanged: widget.onChanged,
        onSubmitted: widget.onSubmitted,
        cursorColor: textColor,
        cursorHeight: t.font(16),
        textAlignVertical: TextAlignVertical(y: 0.75),
        style: TextStyle(
          height: t.spacing(1.0),
          color: textColor,
          fontSize: t.font(14),
          fontFamily: context.core.fontFamily,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColor,
          prefixIconColor: textColor,
          prefixIcon: Padding(
            padding: const EdgeInsets.only(left: 6.0),
            child: _buildPrefixIcon(),
          ),
          prefixIconConstraints: const BoxConstraints(
            minWidth: 0,
            minHeight: 0,
          ),
          suffixIconColor: textColor,
          suffixIcon: Padding(
            padding: const EdgeInsets.only(right: 4.0),
            child: IconButton(
              icon: _buildSuffixIcon(widget.state, context),
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
            borderSide: BorderSide(color: borderColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
            borderSide: BorderSide(color: borderColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(
              context.core.baseRadius * t.radiusScale,
            ),
            borderSide: BorderSide(color: borderColor),
          ),
        ),
      ),
    );
  }
}
