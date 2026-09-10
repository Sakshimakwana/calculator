import 'package:flutter/material.dart';

class ResponsiveDashboardT22AppBar extends StatelessWidget {
  const ResponsiveDashboardT22AppBar({
    super.key,
    this.showMenu = false,
  });

  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        if (showMenu)
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.menu_rounded,
            ),
            color: theme.colorScheme.onSurface,
          ),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Sakshi 👋',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 3),

              Text(
                'Let’s make today productive!',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(
                    alpha: 0.65,
                  ),
                ),
              ),
            ],
          ),
        ),

        CircleAvatar(
          radius: 19,
          backgroundColor:
          theme.colorScheme.primary.withValues(
            alpha: 0.12,
          ),
          child: Icon(
            Icons.person_rounded,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}