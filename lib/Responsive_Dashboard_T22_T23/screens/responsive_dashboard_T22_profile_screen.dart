import 'package:flutter/material.dart';

import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22ProfileScreen extends StatelessWidget {
  const ResponsiveDashboardT22ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        leading: const ResponsiveDashboardT22BackButton(),
        title: Text(
          'Profile',
          style: theme.textTheme.titleLarge,
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundColor:
                theme.colorScheme.primary.withValues(alpha: 0.12),
                child: Icon(
                  Icons.person_rounded,
                  size: 55,
                  color: theme.colorScheme.primary,
                ),
              ),

              const SizedBox(height: 14),

              // Name
              Text(
                'Sakshi Darji',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),

              const SizedBox(height: 4),

              // Job Role
              Text(
                'Flutter Developer',
                style: theme.textTheme.bodyMedium,
              ),

              const SizedBox(height: 24),

              // Profile Information
              _ProfileItem(
                context: context,
                icon: Icons.email_outlined,
                title: 'Email',
                value: 'sakshi@example.com',
              ),

              const SizedBox(height: 12),

              _ProfileItem(
                context: context,
                icon: Icons.phone_outlined,
                title: 'Phone',
                value: '+91 98765 43210',
              ),

              const SizedBox(height: 12),

              _ProfileItem(
                context: context,
                icon: Icons.location_on_outlined,
                title: 'Location',
                value: 'Ahmedabad, Gujarat',
              ),

              const SizedBox(height: 12),

              _ProfileItem(
                context: context,
                icon: Icons.work_outline,
                title: 'Role',
                value: 'Flutter Developer',
              ),

              const SizedBox(height: 12),

              _ProfileItem(
                context: context,
                icon: Icons.calendar_month_outlined,
                title: 'Joined',
                value: 'January 2025',
              ),

              const SizedBox(height: 18),

              // About Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
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
                      'About',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Flutter developer working on responsive mobile '
                          'and tablet applications.',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileItem extends StatelessWidget {
  final BuildContext context;
  final IconData icon;
  final String title;
  final String value;

  const _ProfileItem({
    required this.context,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: theme.colorScheme.outline,
        ),
      ),
      child: Row(
        children: [
          // Icon
          Icon(
            icon,
            color: theme.colorScheme.primary,
            size: 24,
          ),

          const SizedBox(width: 14),

          // Text
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.labelMedium,
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
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