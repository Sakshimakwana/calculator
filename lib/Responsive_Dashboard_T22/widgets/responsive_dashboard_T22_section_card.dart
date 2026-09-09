import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';
import '../theme/responsive_dashboard_T22_typography.dart';

class ResponsiveDashboardT22SectionCard extends StatelessWidget {
  const ResponsiveDashboardT22SectionCard({
    super.key,
    required this.title,
    required this.child,
    this.action,
  });

  final String title;
  final Widget child;
  final String? action;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: ResponsiveDashboardT22Colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ResponsiveDashboardT22Colors.border,
        ),
      ),
      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style:
                  ResponsiveDashboardT22Typography.section,
                ),
              ),
              if (action != null)
                Text(
                  action!,
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color:
                    ResponsiveDashboardT22Colors.primary,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}