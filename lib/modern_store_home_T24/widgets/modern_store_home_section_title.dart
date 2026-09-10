import 'package:flutter/material.dart';

import '../theme/modern_store_home_colors.dart';

class ModernStoreHomeSectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onViewAll;

  const ModernStoreHomeSectionTitle({
    super.key,
    required this.title,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 20, 14),
      child: Row(
        children: [
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w700,
                color: ModernStoreHomeColors.text,
              ),
            ),
          ),
          if (onViewAll != null)
            TextButton(
              onPressed: onViewAll,
              child: const Row(
                children: [
                  Text('View All'),
                  SizedBox(width: 3),
                  Icon(Icons.chevron_right),
                ],
              ),
            ),
        ],
      ),
    );
  }
}