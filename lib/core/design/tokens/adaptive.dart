import 'package:flutter/material.dart';
import 'package:messenger/core/design/breakpoints.dart';
import 'package:messenger/core/design/devices.dart';

class AdaptiveTokens {
  final DeviceClass device;
  final Breakpoint breakpoint;
  final double spacingScale;
  final double typographyScale;
  final double radiusScale;

  const AdaptiveTokens({
    required this.device,
    required this.breakpoint,
    required this.spacingScale,
    required this.typographyScale,
    required this.radiusScale,
  });

  double spacing(double base) => base * spacingScale;
  double radius(double base) => base * radiusScale;
  double font(double base) => base * typographyScale;
}

AdaptiveTokens resolveAdaptiveTokens(BuildContext context) {
  final size = MediaQuery.of(context).size;
  final width = size.width;
  final height = size.height;

  late DeviceClass device;
  if (width >= 900 && height >= 700) {
    device = DeviceClass.desktop;
  } else if (width >= 600 && height >= 500) {
    device = DeviceClass.tablet;
  } else {
    device = DeviceClass.mobile;
  }

  final breakpoint = resolveBreakpoint(width, height);

  switch (breakpoint) {
    case Breakpoint.xs:
      return AdaptiveTokens(
        device: device,
        breakpoint: breakpoint,
        spacingScale: 1.0,
        typographyScale: 1.0,
        radiusScale: 1.0,
      );

    case Breakpoint.sm:
      return AdaptiveTokens(
        device: device,
        breakpoint: breakpoint,
        spacingScale: 1.25,
        typographyScale: 1.15,
        radiusScale: 1.0,
      );

    case Breakpoint.md:
      return AdaptiveTokens(
        device: device,
        breakpoint: breakpoint,
        spacingScale: 1.5,
        typographyScale: 1.25,
        radiusScale: 1.05,
      );

    case Breakpoint.lg:
      return AdaptiveTokens(
        device: device,
        breakpoint: breakpoint,
        spacingScale: 1.75,
        typographyScale: 1.5,
        radiusScale: 1.1,
      );

    case Breakpoint.xl:
      return AdaptiveTokens(
        device: device,
        breakpoint: breakpoint,
        spacingScale: 2,
        typographyScale: 1.5,
        radiusScale: 1.15,
      );
  }
}
