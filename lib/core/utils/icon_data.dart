import 'package:flutter/material.dart';

class AppIconData {
  final IconData icon;
  final VoidCallback onTap;
  final double? iconSize;

  AppIconData({required this.icon, this.iconSize, required this.onTap});
}
