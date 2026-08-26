import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';
import '../theme/product_details_header_typography.dart';


class ProductImageCounter extends StatelessWidget {
  const ProductImageCounter({super.key});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 20,
      bottom: 20,

      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 8,
        ),

        decoration: BoxDecoration(
          color: ProductDetailsHeaderColors.counterBackground,
          borderRadius: BorderRadius.circular(20),
        ),

        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.image_outlined,
              color: ProductDetailsHeaderColors.white,
              size: 18,
            ),

            SizedBox(width: 6),

            Text(
              '1 / 5',
              style: ProductDetailsHeaderTypography.counter,
            ),
          ],
        ),
      ),
    );
  }
}