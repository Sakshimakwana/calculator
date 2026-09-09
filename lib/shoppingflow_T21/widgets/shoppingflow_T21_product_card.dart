import 'package:flutter/material.dart';

import '../theme/shoppingflow_T21_colors.dart';
import '../theme/shoppingflow_T21_typography.dart';

class ShoppingFlowT21ProductCard extends StatelessWidget {
  final IconData icon;
  final String name;
  final String price;

  const ShoppingFlowT21ProductCard({
    super.key,
    required this.icon,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 145,
          decoration: BoxDecoration(
            color: ShoppingFlowT21Colors.productBackground,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Center(
            child: Icon(
              icon,
              size: 76,
              color: ShoppingFlowT21Colors.primary,
            ),
          ),
        ),

        const SizedBox(height: 8),

        Text(
          name,
          style: ShoppingFlowT21Typography.productName,
        ),

        Text(
          price,
          style: ShoppingFlowT21Typography.productPrice,
        ),
      ],
    );
  }
}