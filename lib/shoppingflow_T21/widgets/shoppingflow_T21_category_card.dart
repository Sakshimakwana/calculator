import 'package:flutter/material.dart';

import '../theme/shoppingflow_T21_colors.dart';
import '../theme/shoppingflow_T21_typography.dart';

class ShoppingFlowT21CategoryCard extends StatelessWidget {
  final IconData icon;
  final String title;

  const ShoppingFlowT21CategoryCard({
    super.key,
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 58,
          height: 58,
          decoration: BoxDecoration(
            color: ShoppingFlowT21Colors.categoryBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(
            icon,
            color: ShoppingFlowT21Colors.primary,
            size: 28,
          ),
        ),

        const SizedBox(height: 6),

        Text(
          title,
          style: ShoppingFlowT21Typography.category,
        ),
      ],
    );
  }
}