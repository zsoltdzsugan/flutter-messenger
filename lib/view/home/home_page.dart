import 'package:flutter/material.dart';
import 'package:messenger/core/design/responsive_layout.dart';
import 'package:messenger/view/home/layouts/desktop.dart';
import 'package:messenger/view/home/layouts/mobile.dart';
import 'package:messenger/view/home/layouts/tablet.dart';

class HomePage extends StatelessWidget {
  static const String route = "HomePage";

  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ResponsiveLayout(
      mobile: HomeMobileLayout(),
      tablet: HomeTabletLayout(),
      desktop: HomeDesktopLayout(),
    );
  }
}
