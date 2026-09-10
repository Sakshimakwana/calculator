import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/animations_shopping_colors.dart';
import '../theme/animations_shopping_typography.dart';
import 'animations_shopping_favourite_button.dart';

class AnimationsShoppingProductCard extends StatefulWidget {
  const AnimationsShoppingProductCard({
    super.key,
  });

  @override
  State<AnimationsShoppingProductCard> createState() =>
      _AnimationsShoppingProductCardState();
}

class _AnimationsShoppingProductCardState
    extends State<AnimationsShoppingProductCard> {
  bool isFavourite = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/animations-shopping/product-details',
        );
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: AnimationsShoppingColors.border,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'shopping-product',
                  child: Container(
                    height: 220,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AnimationsShoppingColors.imageBackground,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 120,
                      color: Color(0xFFE9899E),
                    ),
                  ),
                ),

                Positioned(
                  right: 8,
                  top: 8,
                  child: AnimationsShoppingFavouriteButton(
                    isFavourite: isFavourite,
                    onTap: () {
                      setState(() {
                        isFavourite = !isFavourite;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 14),

            const Text(
              'Elegant Handbag',
              style: AnimationsShoppingTypography.productName,
            ),

            const SizedBox(height: 5),

            const Text(
              '₹ 2,499',
              style: AnimationsShoppingTypography.price,
            ),

            const SizedBox(height: 5),

            const Row(
              children: [
                Icon(
                  Icons.star_rounded,
                  size: 18,
                  color: AnimationsShoppingColors.yellow,
                ),
                SizedBox(width: 4),
                Text(
                  '4.5 (120)',
                  style: AnimationsShoppingTypography.body,
                ),
              ],
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  context.push(
                    '/animations-shopping/cart',
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AnimationsShoppingColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(
                    vertical: 15,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Add to Cart',
                  style: AnimationsShoppingTypography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}