import 'package:flutter/material.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22ProgressCard
    extends StatelessWidget {
  const ResponsiveDashboardT22ProgressCard({super.key});

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
          const Text(
            'Project Progress',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color:
              ResponsiveDashboardT22Colors.text,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment:
            CrossAxisAlignment.end,
            children: List.generate(
              7,
                  (index) => Expanded(
                child: Padding(
                  padding:
                  const EdgeInsets.symmetric(
                    horizontal: 3,
                  ),
                  child: Column(
                    children: [
                      Container(
                        height:
                        25.0 + (index % 4) * 13,
                        decoration: BoxDecoration(
                          color:
                          ResponsiveDashboardT22Colors
                              .primary,
                          borderRadius:
                          BorderRadius.circular(5),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        [
                          'M',
                          'T',
                          'W',
                          'T',
                          'F',
                          'S',
                          'S'
                        ][index],
                        style: const TextStyle(
                          fontSize: 9,
                          color:
                          ResponsiveDashboardT22Colors
                              .mutedText,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}