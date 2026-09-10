import 'package:flutter/material.dart';

class ResponsiveDashboardT22WelcomeBanner extends StatelessWidget {
  const ResponsiveDashboardT22WelcomeBanner({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          // Text Section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Welcome back!',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  'Here is an overview of your tasks and activities.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onPrimary.withValues(
                      alpha: 0.85,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 16),

          // Icon
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: theme.colorScheme.onPrimary.withValues(
                alpha: 0.15,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              Icons.waving_hand_rounded,
              size: 30,
              color: theme.colorScheme.onPrimary,
            ),
          ),
        ],
      ),
    );
  }
}