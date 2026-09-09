import 'package:flutter/material.dart';

import '../theme/shoppingflow_T21_colors.dart';

class ShoppingFlowT21PageIndicator extends StatelessWidget {
  final int currentPage;
  final int count;

  const ShoppingFlowT21PageIndicator({
    super.key,
    required this.currentPage,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        count,
            (index) {
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.symmetric(horizontal: 5),
            width: index == currentPage ? 10 : 8,
            height: index == currentPage ? 10 : 8,
            decoration: BoxDecoration(
              color: index == currentPage
                  ? ShoppingFlowT21Colors.primary
                  : ShoppingFlowT21Colors.indicatorInactive,
              shape: BoxShape.circle,
            ),
          );
        },
      ),
    );
  }
}