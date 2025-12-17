import 'package:flutter/material.dart';
import 'package:messenger/core/enums/devices.dart';
import 'package:messenger/core/extensions/design_extension.dart';

class ResponsiveLayout extends StatelessWidget {
  final Widget mobile;
  final Widget tablet;
  final Widget desktop;

  const ResponsiveLayout({
    super.key,
    required this.mobile,
    required this.tablet,
    required this.desktop,
  });

  @override
  Widget build(BuildContext context) {
    final device = context.adaptive.device;

    return switch (device) {
      DeviceType.mobile => mobile,
      DeviceType.tablet => tablet,
      DeviceType.desktop => desktop,
    };
  }
}
