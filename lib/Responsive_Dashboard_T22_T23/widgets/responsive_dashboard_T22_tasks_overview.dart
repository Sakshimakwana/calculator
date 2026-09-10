import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22TasksOverview
    extends StatelessWidget {
  const ResponsiveDashboardT22TasksOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: theme.colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          // Progress Circle
          SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: .72,
                  strokeWidth: 9,
                  color: theme.colorScheme.primary,
                  backgroundColor:
                  theme.colorScheme.primary.withValues(
                    alpha: 0.12,
                  ),
                ),

                Text(
                  '72%',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Task Information
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks Overview',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height: 10),

                const _Legend(
                  'Completed',
                  Color(0xFF2864E8),
                ),

                const _Legend(
                  'In Progress',
                  Color(0xFF20B978),
                ),

                const _Legend(
                  'Pending',
                  Color(0xFFD946A8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(
      this.label,
      this.color,
      );

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),

          const SizedBox(width: 7),

          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              fontSize: 10,
              color: theme.colorScheme.onSurface.withValues(
                alpha: 0.65,
              ),
            ),
          ),
        ],
      ),
    );
  }
}