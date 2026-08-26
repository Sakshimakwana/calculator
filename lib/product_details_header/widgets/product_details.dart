import 'package:flutter/material.dart';

import '../theme/product_details_header_colors.dart';
import '../theme/product_details_header_typography.dart';


class ProductDetails extends StatelessWidget {
  const ProductDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,

      padding: const EdgeInsets.all(20),

      color: ProductDetailsHeaderColors.white,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Noise Cancelling Headphones',
            style: ProductDetailsHeaderTypography.title,
          ),

          const SizedBox(height: 10),

          const Row(
            children: [
              Icon(
                Icons.star,
                color: ProductDetailsHeaderColors.star,
              ),
              Icon(
                Icons.star,
                color: ProductDetailsHeaderColors.star,
              ),
              Icon(
                Icons.star,
                color: ProductDetailsHeaderColors.star,
              ),
              Icon(
                Icons.star,
                color: ProductDetailsHeaderColors.star,
              ),
              Icon(
                Icons.star,
                color: ProductDetailsHeaderColors.star,
              ),

              SizedBox(width: 8),

              Text(
                '(128 reviews)',
                style: ProductDetailsHeaderTypography.reviews,
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Row(
            children: [
              Text(
                '₹2,799',
                style: ProductDetailsHeaderTypography.price,
              ),

              SizedBox(width: 15),

              Text(
                '₹3,499',
                style: ProductDetailsHeaderTypography.oldPrice,
              ),
            ],
          ),
        ],
      ),
    );
  }
}