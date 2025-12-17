import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/core/theme/kWidgetColors.dart';

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
        child: TextField(
          controller: _controller,
          focusNode: _focusNode,
          cursorColor: textColor,
          cursorHeight: t.font(16),
          style: TextStyle(color: textColor),
          decoration: InputDecoration(
            filled: true,
            fillColor: bgColor,
            hintText: 'Keresés...',
            hintStyle: TextStyle(
              color: hintColor,
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
            suffixIconColor: textColor,
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
      ),
    );
  }
}
