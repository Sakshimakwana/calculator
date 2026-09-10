import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveDashboardT22BottomNavigation
    extends StatelessWidget {
  const ResponsiveDashboardT22BottomNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final path = GoRouterState.of(context).uri.path;

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _Item(
            icon: Icons.home_rounded,
            label: 'Home',
            path: '/responsive-dashboard',
            selected: path == '/responsive-dashboard',
          ),

          _Item(
            icon: Icons.check_box_rounded,
            label: 'Tasks',
            path: '/responsive-dashboard/tasks',
            selected:
            path == '/responsive-dashboard/tasks',
          ),

          _Item(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            path: '/responsive-dashboard/calendar',
            selected:
            path == '/responsive-dashboard/calendar',
          ),

          _Item(
            icon: Icons.person_rounded,
            label: 'Profile',
            path: '/responsive-dashboard/profile',
            selected:
            path == '/responsive-dashboard/profile',
          ),
        ],
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    required this.icon,
    required this.label,
    required this.path,
    required this.selected,
  });

  final IconData icon;
  final String label;
  final String path;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final color = selected
        ? theme.colorScheme.primary
        : theme.colorScheme.onSurface.withValues(
      alpha: 0.60,
    );

    return InkWell(
      onTap: () {
        context.go(path);
      },
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 20,
              color: color,
            ),

            const SizedBox(height: 3),

            Text(
              label,
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 9,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}