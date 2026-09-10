import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22RecentActivityTile
    extends StatelessWidget {
  const ResponsiveDashboardT22RecentActivityTile({
    super.key,
    required this.title,
    required this.time,
    required this.type,
  });

  final String title;
  final String time;
  final String type;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final iconColor = switch (type) {
      'green' => ResponsiveDashboardT22Colors.green,
      'pink' => ResponsiveDashboardT22Colors.pink,
      _ => ResponsiveDashboardT22Colors.purple,
    };

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(
              Icons.bolt_rounded,
              size: 17,
              color: iconColor,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: theme.colorScheme.onSurface,
                  ),
                ),

                const SizedBox(height: 2),

                Text(
                  time,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    color: theme.colorScheme.onSurface.withValues(
                      alpha: 0.65,
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