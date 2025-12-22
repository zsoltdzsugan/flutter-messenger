import 'package:flutter/material.dart';
import 'package:messenger/core/enums/sidebar_filter.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/widgets/buttons/animated_filter_button.dart';

class SidebarFilterBar extends StatelessWidget {
  final SidebarFilter filter;
  final ValueChanged<SidebarFilter> onChanged;

  const SidebarFilterBar({
    super.key,
    required this.filter,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final t = context.adaptive;
    final c = context.components;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: t.spacing(c.spaceXSmall),
        horizontal: t.spacing(c.spaceXSmall),
      ),
      child: Row(
        children: [
          Expanded(
            child: AnimatedFilterButton(
              label: "Ismerősök",
              isSelected: filter == SidebarFilter.users,
              onTap: () => onChanged(SidebarFilter.users),
              icon: Icons.group,
            ),
          ),
          SizedBox(width: t.spacing(c.spaceXSmall)),
          Expanded(
            child: AnimatedFilterButton(
              label: "Üzenetek",
              isSelected: filter == SidebarFilter.messages,
              onTap: () => onChanged(SidebarFilter.messages),
              icon: Icons.inbox,
            ),
          ),
        ],
      ),
    );
  }
}
