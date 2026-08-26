import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_typography.dart';

class DashboardActivity extends StatelessWidget {
  const DashboardActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: DashboardColors.card,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Activity',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _item(
            Icons.check,
            'Payment received',
            '2 mins ago',
            DashboardColors.greenLight,
          ),
          _item(
            Icons.person_add,
            'New customer registered',
            '15 mins ago',
            DashboardColors.blueLight,
          ),
          _item(
            Icons.access_time,
            'Order #12345 is pending',
            '1 hour ago',
            DashboardColors.orangeLight,
          ),
        ],
      ),
    );
  }

  Widget _item(
      IconData icon,
      String title,
      String time,
      Color backgroundColor,
      ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: backgroundColor,
            child: Icon(icon),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: DashboardTypography.activityTitle,
              ),
              const SizedBox(height: 4),
              Text(
                time,
                style: DashboardTypography.activityTime,
              ),
            ],
          ),
        ],
      ),
    );
  }
}