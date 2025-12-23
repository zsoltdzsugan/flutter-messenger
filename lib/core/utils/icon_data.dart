import 'package:flutter/material.dart';

class AppIconData {
  final IconData icon;
  final VoidCallback onTap;
  final double? iconSize;
  final String tooltip;

  AppIconData({
    required this.icon,
    this.iconSize,
    required this.onTap,
    required this.tooltip,
  });
}
