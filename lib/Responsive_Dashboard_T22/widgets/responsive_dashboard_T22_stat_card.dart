import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';

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
    final cardColor = switch (type) {
      'green' => ResponsiveDashboardT22Colors.greenCard,
      'pink' => ResponsiveDashboardT22Colors.pinkCard,
      'orange' => ResponsiveDashboardT22Colors.orangeCard,
      _ => ResponsiveDashboardT22Colors.blueCard,
    };

    final iconColor = switch (type) {
      'green' => ResponsiveDashboardT22Colors.green,
      'pink' => ResponsiveDashboardT22Colors.pink,
      'orange' => ResponsiveDashboardT22Colors.orange,
      _ => ResponsiveDashboardT22Colors.primary,
    };

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
                  style:
                  ResponsiveDashboardT22Typography.cardValue,
                ),
                Text(
                  label,
                  style:
                  ResponsiveDashboardT22Typography.cardLabel,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}