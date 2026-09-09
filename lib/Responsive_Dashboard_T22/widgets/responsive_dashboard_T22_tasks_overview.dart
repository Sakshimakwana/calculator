import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22TasksOverview
    extends StatelessWidget {
  const ResponsiveDashboardT22TasksOverview({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color:
        ResponsiveDashboardT22Colors.surface,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color:
          ResponsiveDashboardT22Colors.border,
        ),
      ),
      child: const Row(
        children: [
          SizedBox(
            width: 78,
            height: 78,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: .72,
                  strokeWidth: 9,
                  color:
                  ResponsiveDashboardT22Colors
                      .primary,
                  backgroundColor:
                  ResponsiveDashboardT22Colors
                      .primarySoft,
                ),
                Text(
                  '72%',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    color:
                    ResponsiveDashboardT22Colors
                        .text,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Text(
                  'Tasks Overview',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color:
                    ResponsiveDashboardT22Colors
                        .text,
                  ),
                ),
                SizedBox(height: 10),
                _Legend(
                  'Completed',
                  Color(0xFF2864E8),
                ),
                _Legend(
                  'In Progress',
                  Color(0xFF20B978),
                ),
                _Legend(
                  'Pending',
                  Color(0xFFD946A8),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  const _Legend(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 7),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color:
              ResponsiveDashboardT22Colors
                  .mutedText,
            ),
          ),
        ],
      ),
    );
  }
}