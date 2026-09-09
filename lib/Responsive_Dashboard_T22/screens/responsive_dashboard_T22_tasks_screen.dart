import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';
import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22TasksScreen
    extends StatelessWidget {
  const ResponsiveDashboardT22TasksScreen({
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
          'Tasks',
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
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              const Text(
                'Task Overview',
                style:
                ResponsiveDashboardT22Typography.title,
              ),

              const SizedBox(height: 6),

              const Text(
                'Track your tasks and progress',
                style:
                ResponsiveDashboardT22Typography.subtitle,
              ),

              const SizedBox(height: 20),

              const Row(
                children: [
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Completed',
                      value: '8',
                      icon: Icons.check_circle_rounded,
                      color:
                      ResponsiveDashboardT22Colors.green,
                      background:
                      ResponsiveDashboardT22Colors.greenCard,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'In Progress',
                      value: '4',
                      icon: Icons.pending_rounded,
                      color:
                      ResponsiveDashboardT22Colors.primary,
                      background:
                      ResponsiveDashboardT22Colors.blueCard,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 10),

              const Row(
                children: [
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Pending',
                      value: '3',
                      icon: Icons.schedule_rounded,
                      color:
                      ResponsiveDashboardT22Colors.orange,
                      background:
                      ResponsiveDashboardT22Colors.orangeCard,
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: _TaskSummaryCard(
                      title: 'Total Tasks',
                      value: '15',
                      icon: Icons.task_alt_rounded,
                      color:
                      ResponsiveDashboardT22Colors.pink,
                      background:
                      ResponsiveDashboardT22Colors.pinkCard,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              const Text(
                'All Tasks',
                style:
                ResponsiveDashboardT22Typography.section,
              ),

              const SizedBox(height: 12),

              _TaskTile(
                title: 'Complete dashboard UI',
                subtitle: 'Today • 10:00 AM',
                status: 'Completed',
                color:
                ResponsiveDashboardT22Colors.green,
              ),

              _TaskTile(
                title: 'Review project design',
                subtitle: 'Today • 02:00 PM',
                status: 'In Progress',
                color:
                ResponsiveDashboardT22Colors.primary,
              ),

              _TaskTile(
                title: 'Update documentation',
                subtitle: 'Tomorrow • 11:00 AM',
                status: 'Pending',
                color:
                ResponsiveDashboardT22Colors.orange,
              ),

              _TaskTile(
                title: 'Team discussion',
                subtitle: 'Tomorrow • 04:00 PM',
                status: 'In Progress',
                color:
                ResponsiveDashboardT22Colors.primary,
              ),

              _TaskTile(
                title: 'Final project testing',
                subtitle: 'Friday • 03:00 PM',
                status: 'Pending',
                color:
                ResponsiveDashboardT22Colors.orange,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TaskSummaryCard extends StatelessWidget {
  const _TaskSummaryCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.background,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final Color background;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: color,
            size: 25,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style:
                ResponsiveDashboardT22Typography.cardValue,
              ),
              Text(
                title,
                style:
                ResponsiveDashboardT22Typography.cardLabel,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  const _TaskTile({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
  });

  final String title;
  final String subtitle;
  final String status;
  final Color color;

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
            Icons.task_alt_rounded,
            color: color,
            size: 25,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color:
                    ResponsiveDashboardT22Colors.text,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style:
                  ResponsiveDashboardT22Typography.cardLabel,
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 9,
              vertical: 5,
            ),
            decoration: BoxDecoration(
              color: color.withValues(alpha: .10),
              borderRadius:
              BorderRadius.circular(20),
            ),
            child: Text(
              status,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}