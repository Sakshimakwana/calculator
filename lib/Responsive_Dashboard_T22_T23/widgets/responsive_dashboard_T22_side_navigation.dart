import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ResponsiveDashboardT22SideNavigation
    extends StatelessWidget {
  const ResponsiveDashboardT22SideNavigation({
    super.key,
    this.compact = false,
  });

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: compact ? 76 : 190,
      padding: const EdgeInsets.fromLTRB(
        16,
        28,
        16,
        20,
      ),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          right: BorderSide(
            color: theme.colorScheme.outline,
          ),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo / Dashboard Title
          Row(
            mainAxisAlignment: compact
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: [
              Icon(
                Icons.send_rounded,
                color: theme.colorScheme.primary,
              ),

              if (!compact) ...[
                const SizedBox(width: 8),

                Text(
                  'Dashboard',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ],
          ),

          const SizedBox(height: 30),

          _NavItem(
            icon: Icons.home_rounded,
            label: 'Home',
            path: '/responsive-dashboard',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.check_box_rounded,
            label: 'Tasks',
            path: '/responsive-dashboard/tasks',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.calendar_month_rounded,
            label: 'Calendar',
            path: '/responsive-dashboard/calendar',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.chat_bubble_rounded,
            label: 'Messages',
            path: '/responsive-dashboard/messages',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.group_rounded,
            label: 'Team',
            path: '/responsive-dashboard/team',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.person_rounded,
            label: 'Profile',
            path: '/responsive-dashboard/profile',
            compact: compact,
          ),

          _NavItem(
            icon: Icons.settings_rounded,
            label: 'Settings',
            path: '/responsive-dashboard/settings',
            compact: compact,
          ),

          const Spacer(),

          if (!compact)
            Text(
              'Responsive T22',
              style: theme.textTheme.bodySmall?.copyWith(
                fontSize: 11,
                color: theme.colorScheme.onSurface.withValues(
                  alpha: 0.6,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.path,
    required this.compact,
  });

  final IconData icon;
  final String label;
  final String path;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final currentPath =
        GoRouterState.of(context).uri.path;

    final selected = currentPath == path;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      decoration: BoxDecoration(
        color: selected
            ? theme.colorScheme.primary.withValues(
          alpha: 0.12,
        )
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        dense: true,

        onTap: () {
          context.go(path);
        },

        contentPadding: EdgeInsets.symmetric(
          horizontal: compact ? 4 : 10,
        ),

        leading: Icon(
          icon,
          size: 18,
          color: selected
              ? theme.colorScheme.primary
              : theme.colorScheme.onSurface.withValues(
            alpha: 0.60,
          ),
        ),

        title: compact
            ? null
            : Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontSize: 12,
            fontWeight: selected
                ? FontWeight.w700
                : FontWeight.w500,
            color: selected
                ? theme.colorScheme.primary
                : theme.colorScheme.onSurface,
          ),
        ),

        minLeadingWidth: compact ? 0 : null,
      ),
    );
  }
}