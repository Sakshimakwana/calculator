import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_typography.dart';

class DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final String percentage;
  final IconData icon;
  final Color iconBackground;
  final bool isNegative;

  const DashboardCard({
    super.key,
    required this.title,
    required this.value,
    required this.percentage,
    required this.icon,
    required this.iconBackground,
    this.isNegative = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 20,
      width: 12,
      child: Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: DashboardColors.card,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 28,
              backgroundColor: iconBackground,
              child: Icon(
                icon,
                color: DashboardColors.primary,
              ),
            ),
            Text(
              title,
              style: DashboardTypography.cardTitle,
            ),

            Text(
              value,
              style: DashboardTypography.cardValue,
            ),

            Row(
              children: [
                Icon(
                  isNegative
                      ? Icons.arrow_downward
                      : Icons.arrow_upward,
                  size: 18,
                  color: isNegative
                      ? DashboardColors.error
                      : DashboardColors.success,
                ),

                Text(
                  percentage,
                  style: TextStyle(
                    color: isNegative
                        ? DashboardColors.error
                        : DashboardColors.success,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}