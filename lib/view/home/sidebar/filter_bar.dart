import 'package:flutter/material.dart';
import 'package:messenger/core/extensions/design_extension.dart';
import 'package:messenger/view/home/sidebar/filter.dart';
import 'package:messenger/widgets/buttons/filter_button.dart';

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
    final colors = context.core.colors;

    return Padding(
      padding: EdgeInsets.symmetric(vertical: t.spacing(c.spaceSmall)),
      child: Row(
        children: [
          Expanded(
            child: FilterButton(
              label: "Users",
              selected: filter == SidebarFilter.users,
              onTap: () => onChanged(SidebarFilter.users),
              icon: Icons.group,
            ),
          ),
          //SizedBox(width: t.spacing(c.spaceSmall)),
          Expanded(
            child: FilterButton(
              label: "Messages",
              selected: filter == SidebarFilter.messages,
              onTap: () => onChanged(SidebarFilter.messages),
              icon: Icons.inbox,
            ),
          ),
        ],
      ),
    );
  }
}
