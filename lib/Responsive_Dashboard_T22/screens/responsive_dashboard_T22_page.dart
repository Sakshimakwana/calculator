import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';
import '../widgets/responsive_dashboard_T22_back_button.dart';

class ResponsiveDashboardT22Page extends StatelessWidget {
  const ResponsiveDashboardT22Page({
    super.key,
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
      ResponsiveDashboardT22Colors.background,
      appBar: AppBar(
      leading:
      const ResponsiveDashboardT22BackButton(),
      title: Text(
        title,
        style:
        ResponsiveDashboardT22Typography.section,
      ),
      backgroundColor:
      ResponsiveDashboardT22Colors.surface,
    ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 60,
              color: ResponsiveDashboardT22Colors.primary,
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: ResponsiveDashboardT22Typography.title,
            ),
          ],
        ),
      ),
    );
  }
}