import 'package:flutter/material.dart';
import '../theme/dashboard_colors.dart';
import '../theme/dashboard_typography.dart';

class DashboardAppBar {
  static AppBar build(BuildContext context) {
    return AppBar(
      backgroundColor: DashboardColors.primary,
      foregroundColor: Colors.white,
      title: const Text(
        'Dashboard',
        style: DashboardTypography.appBarTitle,
      ),
      centerTitle: true,
      actions: [
        IconButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showMaterialBanner(
              MaterialBanner(
                content: const Text('No new notifications'),
                actions: [
                  TextButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context)
                          .hideCurrentMaterialBanner();
                    },
                    child: const Text('DISMISS'),
                  ),
                ],
              ),
            );
          },
          icon: const Icon(Icons.notifications_outlined),
        ),
      ],
    );
  }
}