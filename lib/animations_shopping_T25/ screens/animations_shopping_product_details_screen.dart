import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../animations_shopping_routes.dart';
import '../theme/animations_shopping_colors.dart';
import '../theme/animations_shopping_typography.dart';
import '../widgets/animations_shopping_quantity_button.dart';

class AnimationsShoppingProductDetailsScreen extends StatefulWidget {
  const AnimationsShoppingProductDetailsScreen({super.key});

  @override
  State<AnimationsShoppingProductDetailsScreen> createState() =>
      _AnimationsShoppingProductDetailsScreenState();
}

class _AnimationsShoppingProductDetailsScreenState
    extends State<AnimationsShoppingProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnimationsShoppingColors.background,
      appBar: AppBar(
        backgroundColor: AnimationsShoppingColors.background,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back),
        ),
        actions: const [
          Icon(Icons.favorite_border_rounded),
          SizedBox(width: 18),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Hero(
            tag: 'shopping-product',
            child: Container(
              height: 360,
              decoration: BoxDecoration(
                color: AnimationsShoppingColors.imageBackground,
                borderRadius: BorderRadius.circular(24),
              ),
              child: const Icon(
                Icons.shopping_bag_rounded,
                size: 190,
                color: Color(0xFFE9899E),
              ),
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Elegant Handbag',
            style: AnimationsShoppingTypography.title,
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '₹ 2,499',
                style: AnimationsShoppingTypography.price,
              ),
              Row(
                children: const [
                  Icon(
                    Icons.star_rounded,
                    color: AnimationsShoppingColors.yellow,
                  ),
                  SizedBox(width: 4),
                  Text(
                    '4.5 (120)',
                    style: AnimationsShoppingTypography.body,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            'Stylish and premium quality handbag for everyday use. '
                'A perfect blend of fashion and functionality.',
            style: AnimationsShoppingTypography.body,
          ),

          const SizedBox(height: 24),

          const Text(
            'Color',
            style: AnimationsShoppingTypography.productName,
          ),

          const SizedBox(height: 12),

          Row(
            children: [
              _colorCircle(const Color(0xFFFFB6C4)),
              _colorCircle(Colors.black),
              _colorCircle(const Color(0xFFE8D8C5)),
              _colorCircle(const Color(0xFF9FD4F2)),
            ],
          ),

          const SizedBox(height: 24),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Quantity',
                style: AnimationsShoppingTypography.productName,
              ),
              AnimationsShoppingQuantityButton(
                quantity: quantity,
                onMinus: () {
                  if (quantity > 1) {
                    setState(() => quantity--);
                  }
                },
                onPlus: () {
                  setState(() => quantity++);
                },
              ),
            ],
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 54,
            child: ElevatedButton(
              onPressed: () {
                context.push(
                  '/animations-shopping/cart',
                );
              },
              child: const Text('Add to Cart'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AnimationsShoppingColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),

            ),
          )
        ],
      ),
    );
  }

  Widget _colorCircle(Color color) {
    return Container(
      width: 38,
      height: 38,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 3,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.08),
            blurRadius: 5,
          ),
        ],
      ),
    );
  }
}