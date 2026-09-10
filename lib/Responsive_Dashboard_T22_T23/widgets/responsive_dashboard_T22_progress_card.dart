import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22ProgressCard
    extends StatelessWidget {
  const ResponsiveDashboardT22ProgressCard({
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Project Progress',
            style: theme.textTheme.titleMedium?.copyWith(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),

          const SizedBox(height: 14),

          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              7,
                  (index) => Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height: 25.0 + (index % 4) * 13,
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),

                      const SizedBox(height: 5),

                      Text(
                        [
                          'M',
                          'T',
                          'W',
                          'T',
                          'F',
                          'S',
                          'S',
                        ][index],
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: 9,
                          color: theme.colorScheme.onSurface
                              .withValues(alpha: 0.65),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}