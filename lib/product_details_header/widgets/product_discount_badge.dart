import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';
import '../theme/product_details_header_typography.dart';


class ProductDiscountBadge extends StatelessWidget {
  const ProductDiscountBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 20,
      bottom: 20,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 18,
          vertical: 12,
        ),

        decoration: BoxDecoration(
          color: ProductDetailsHeaderColors.discount,
          borderRadius: BorderRadius.circular(12),
        ),

        child: const Text(
          '20% OFF',
          style: ProductDetailsHeaderTypography.discount,
        ),
      ),
    );
  }
}