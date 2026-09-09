import 'package:flutter/material.dart';

import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';

class ShoppingFlowT20SectionTitle extends StatelessWidget {
  final String title;
  final String? action;

  const ShoppingFlowT20SectionTitle({
    super.key,
    required this.title,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: ShoppingFlowT20Typography.heading,
        ),
        if (action != null)
          Text(
            action!,
            style: const TextStyle(
              color: ShoppingFlowT20Colors.primary,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
      ],
    );
  }
}