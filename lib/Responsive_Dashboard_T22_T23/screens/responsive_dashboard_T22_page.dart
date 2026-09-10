import 'package:flutter/material.dart';

import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22Page extends StatelessWidget {
  final String title;
  final IconData icon;

  const ResponsiveDashboardT22Page({
    super.key,
    required this.title,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const ResponsiveDashboardT22BackButton(),
        title: Text(
          title,
          style: theme.textTheme.titleLarge,
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.colorScheme.outline,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.primary.withValues(
                        alpha: 0.12,
                      ),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 34,
                      color: theme.colorScheme.primary,
                    ),
                  ),

                  const SizedBox(height: 18),

                  Text(
                    title,
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    'Manage your $title information here.',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium,
                  ),

                  const SizedBox(height: 20),

                  ElevatedButton.icon(
                    onPressed: () {},
                    icon: Icon(icon),
                    label: Text('Open $title'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}