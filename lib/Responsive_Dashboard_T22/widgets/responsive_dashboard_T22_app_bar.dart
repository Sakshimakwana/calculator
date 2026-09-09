import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';

class ResponsiveDashboardT22AppBar extends StatelessWidget {
  const ResponsiveDashboardT22AppBar({
    super.key,
    this.showMenu = false,
  });

  final bool showMenu;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (showMenu)
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.menu_rounded),
            color: ResponsiveDashboardT22Colors.text,
          ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello, Sakshi 👋',
                style: ResponsiveDashboardT22Typography.title,
              ),
              const SizedBox(height: 3),
              Text(
                'Let’s make today productive!',
                style: ResponsiveDashboardT22Typography.subtitle,
              ),
            ],
          ),
        ),
        const CircleAvatar(
          radius: 19,
          backgroundColor:
          ResponsiveDashboardT22Colors.primarySoft,
          child: Icon(
            Icons.person_rounded,
            color: ResponsiveDashboardT22Colors.primary,
          ),
        ),
      ],
    );
  }
}