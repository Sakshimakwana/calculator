import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_typography.dart';

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: DashboardColors.background,

      appBar: AppBar(
        backgroundColor: DashboardColors.primary,
        foregroundColor: Colors.white,
        title: const Text(
          'Reports',
          style: DashboardTypography.appBarTitle,
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Reports Overview',
              style: DashboardTypography.greeting,
            ),

            const SizedBox(height: 6),

            const Text(
              'Check your business performance.',
              style: DashboardTypography.subtitle,
            ),

            const SizedBox(height: 24),

            _ReportCard(
              title: 'Sales Report',
              value: '\$12,450',
              subtitle: '12.5% increase this month',
              icon: Icons.bar_chart_outlined,
              iconColor: DashboardColors.blueLight,
            ),

            const SizedBox(height: 16),

            _ReportCard(
              title: 'Orders Report',
              value: '248',
              subtitle: '8.2% increase this month',
              icon: Icons.shopping_bag_outlined,
              iconColor: DashboardColors.greenLight,
            ),

            const SizedBox(height: 16),

            _ReportCard(
              title: 'Customer Report',
              value: '1,240',
              subtitle: '6.5% increase this month',
              icon: Icons.people_outline,
              iconColor: DashboardColors.purpleLight,
            ),

            const SizedBox(height: 16),

            _ReportCard(
              title: 'Pending Tasks',
              value: '18',
              subtitle: '4.3% decrease this month',
              icon: Icons.access_time,
              iconColor: DashboardColors.orangeLight,
            ),
          ],
        ),
      ),
    );
  }
}

class _ReportCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color iconColor;

  const _ReportCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              icon,
              size: 28,
              color: DashboardColors.primary,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Colors.green,
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