import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';
import '../theme_T23/Theme_T23_app_colors.dart';


class ResponsiveDashboardT22StatCard extends StatelessWidget {
  const ResponsiveDashboardT22StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.type,
  });

  final String value;
  final String label;
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    // Card background
    final cardColor = switch (type) {
      'green' => isDark
          ? ThemeT23AppColors.darkGreenCard
          : ThemeT23AppColors.lightGreenCard,
      'pink' => isDark
          ? ThemeT23AppColors.darkPinkCard
          : ThemeT23AppColors.lightPinkCard,
      'orange' => isDark
          ? ThemeT23AppColors.darkOrangeCard
          : ThemeT23AppColors.lightOrangeCard,
      _ => isDark
          ? ThemeT23AppColors.darkBlueCard
          : ThemeT23AppColors.lightBlueCard,
    };

    // Icon color
    final iconColor = switch (type) {
      'green' => ThemeT23AppColors.green,
      'pink' => ThemeT23AppColors.pink,
      'orange' => ThemeT23AppColors.orange,
      _ => theme.colorScheme.primary,
    };

    // Icon
    final icon = switch (type) {
      'green' => Icons.check_rounded,
      'pink' => Icons.mail_rounded,
      'orange' => Icons.group_rounded,
      _ => Icons.folder_rounded,
    };

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(13),
        border: Border.all(
          color: theme.colorScheme.outline.withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            size: 19,
            color: iconColor,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.7,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}