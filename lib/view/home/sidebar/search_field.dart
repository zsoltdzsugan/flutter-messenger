import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class SearchField extends StatefulWidget {
  final void Function(String)? onQueryChanged;
  final TextEditingController? controller;

  const SearchField({super.key, this.onQueryChanged, this.controller});

  @override
  State<SearchField> createState() => _SearchFieldState();
}

class _SearchFieldState extends State<SearchField> {
  List<DocumentSnapshot>? searchResults;
  final FocusNode _focusNode = FocusNode();
  late final TextEditingController _controller;
  bool _isFocused = false;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _controller = widget.controller ?? TextEditingController();
    _focusNode.addListener(() {
      setState(() {
        _isFocused = _focusNode.hasFocus;
      });
    });

    _controller.addListener(() {
      final text = _controller.text.trim();

      _debounce?.cancel();

      if (text.length > 1) {
        _debounce = Timer(const Duration(milliseconds: 500), () {
          widget.onQueryChanged?.call(text);
        });
      } else {
        widget.onQueryChanged?.call('');
      }
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
    final colors = context.core.colors;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    late final Color textColor;

    final bgColor = _isFocused ? colors.primary : colors.primary.withAlpha(50);

    if (_isFocused) {
      textColor = colors.onPrimary;
    } else {
      textColor = isDark ? colors.textPrimary : colors.textSecondary;
    }

    return Material(
      elevation: _isFocused ? 5.0 : 0.0,
      child: TextField(
        controller: _controller,
        focusNode: _focusNode,
        cursorColor: colors.textPrimary,
        cursorHeight: t.font(16),
        style: TextStyle(
          color: !_isFocused
              ? colors.textPrimary
              : isDark
              ? colors.textPrimary
              : colors.textSecondary,
        ),
        decoration: InputDecoration(
          filled: true,
          fillColor: bgColor,
          hintText: 'Keresés...',
          hintStyle: TextStyle(
            color: _isFocused ? textColor.withAlpha(100) : textColor,
            fontSize: t.font(14),
            fontFeatures: [FontFeature.enable('smcp')],
            letterSpacing: 1.25,
          ),
          suffixIcon: _controller.text.isNotEmpty
              ? Padding(
                  padding: const EdgeInsets.only(right: 4.0),
                  child: IconButton(
                    onPressed: () {
                      _controller.clear();
                      widget.onQueryChanged?.call('');
                      setState(() {
                        searchResults = null;
                      });
                    },
                    icon: Icon(Icons.close_rounded),
                    iconSize: t.font(c.avatarSize),
                  ),
                )
              : null,
          suffixIconColor: _isFocused
              ? colors.textSecondary
              : colors.textPrimary,
          border: InputBorder.none,
          focusedBorder: InputBorder.none,
          enabledBorder: InputBorder.none,
          contentPadding: EdgeInsets.only(
            left: t.spacing(c.spaceSmall),
            top: t.spacing(c.spaceMedium),
            bottom: t.spacing(c.spaceMedium),
          ),
          isDense: true,
        ),
      ),
    );
  }
}
