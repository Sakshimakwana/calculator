import 'package:flutter/material.dart';

import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';

class ShoppingFlowT20CategoryItem
    extends StatelessWidget {
  final String name;
  final IconData icon;
  final VoidCallback onTap;

  const ShoppingFlowT20CategoryItem({
    super.key,
    required this.name,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 60,
        child: Column(
          children: [
            CircleAvatar(
              radius: 23,
              backgroundColor:
              ShoppingFlowT20Colors.primaryLight,
              child: Icon(
                icon,
                color:
                ShoppingFlowT20Colors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              name,
              style:
              ShoppingFlowT20Typography.caption,
            ),
          ],
        ),
      ),
    );
  }
}