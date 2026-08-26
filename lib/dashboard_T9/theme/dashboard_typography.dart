import 'package:flutter/material.dart';
import 'dashboard_colors.dart';

class DashboardTypography {
  static const TextStyle appBarTitle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: Colors.white,
  );

  static const TextStyle greeting = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w600,
    color: DashboardColors.textPrimary,
  );

  static const TextStyle subtitle = TextStyle(
    fontSize: 16,
    color: DashboardColors.textSecondary,
  );

  static const TextStyle cardTitle = TextStyle(
    fontSize: 16,
    color: DashboardColors.textSecondary,
  );

  static const TextStyle cardValue = TextStyle(
    fontSize: 26,
    fontWeight: FontWeight.w600,
    color: DashboardColors.textPrimary,
  );

  static const TextStyle activityTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: DashboardColors.textPrimary,
  );

  static const TextStyle activityTime = TextStyle(
    fontSize: 14,
    color: DashboardColors.textSecondary,
  );
}