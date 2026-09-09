import 'package:flutter/material.dart';

import 'product_image.dart';
import 'product_overlay.dart';
import 'product_back_button.dart';
import 'product_favorite_button.dart';
import 'product_discount_badge.dart';
import 'product_image_counter.dart';

class ProductHeader extends StatelessWidget {
  const ProductHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.2,

      child: Stack(
        children: const [
          // Background image
          ProductImage(),

          // Dark overlay
          ProductOverlay(),

          // Back button
          ProductBackButton(),

          // Favourite button
          ProductFavoriteButton(),

          // Discount badge
          ProductDiscountBadge(),

          // Image counter
          ProductImageCounter(),
        ],
      ),
    );
  }
}