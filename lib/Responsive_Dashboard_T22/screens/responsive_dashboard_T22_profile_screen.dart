import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';
import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22ProfileScreen
    extends StatelessWidget {
  const ResponsiveDashboardT22ProfileScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      ResponsiveDashboardT22Colors.background,
      appBar: AppBar(
        leading:
        const ResponsiveDashboardT22BackButton(),
        title: const Text(
          'Profile',
          style:
          ResponsiveDashboardT22Typography.section,
        ),
        backgroundColor:
        ResponsiveDashboardT22Colors.surface,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const CircleAvatar(
                radius: 50,
                backgroundColor:
                ResponsiveDashboardT22Colors.primarySoft,
                child: Icon(
                  Icons.person_rounded,
                  size: 55,
                  color:
                  ResponsiveDashboardT22Colors.primary,
                ),
              ),

              const SizedBox(height: 14),

              const Text(
                'Sakshi Darji',
                style:
                ResponsiveDashboardT22Typography.title,
              ),

              const SizedBox(height: 4),

              const Text(
                'Flutter Developer',
                style:
                ResponsiveDashboardT22Typography.subtitle,
              ),

              const SizedBox(height: 24),

              _ProfileItem(
                icon: Icons.email_rounded,
                title: 'Email',
                value: 'sakshi@example.com',
              ),

              _ProfileItem(
                icon: Icons.phone_rounded,
                title: 'Phone',
                value: '+91 98765 43210',
              ),

              _ProfileItem(
                icon: Icons.location_on_rounded,
                title: 'Location',
                value: 'Ahmedabad, India',
              ),

              _ProfileItem(
                icon: Icons.work_rounded,
                title: 'Role',
                value: 'Flutter Developer',
              ),

              _ProfileItem(
                icon: Icons.calendar_month_rounded,
                title: 'Joined',
                value: 'January 2025',
              ),

              const SizedBox(height: 18),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color:
                  ResponsiveDashboardT22Colors.surface,
                  borderRadius:
                  BorderRadius.circular(15),
                  border: Border.all(
                    color:
                    ResponsiveDashboardT22Colors.border,
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About',
                      style:
                      ResponsiveDashboardT22Typography.section,
                    ),
                    SizedBox(height: 8),
                    Text(
                      'Flutter developer working on responsive '
                          'mobile and tablet applications.',
                      style:
                      ResponsiveDashboardT22Typography.body,
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
  const _ProfileItem({
    required this.icon,
    required this.title,
    required this.value,
  });

  final IconData icon;
  final String title;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color:
        ResponsiveDashboardT22Colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color:
          ResponsiveDashboardT22Colors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color:
            ResponsiveDashboardT22Colors.primary,
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style:
                ResponsiveDashboardT22Typography.cardLabel,
              ),
              const SizedBox(height: 3),
              Text(
                value,
                style:
                ResponsiveDashboardT22Typography.body,
              ),
            ],
          ),
        ],
      ),
    );
  }
}