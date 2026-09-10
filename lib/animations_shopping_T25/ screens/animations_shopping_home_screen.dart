import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/animations_shopping_colors.dart';
import '../theme/animations_shopping_typography.dart';
import '../widgets/animations_shopping_product_card.dart';

class AnimationsShoppingHomeScreen extends StatelessWidget {
  const AnimationsShoppingHomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AnimationsShoppingColors.background,

      appBar: AppBar(
        backgroundColor: AnimationsShoppingColors.background,
        elevation: 0,

        title: const Text(
          'Discover',
          style: AnimationsShoppingTypography.heading,
        ),

        actions: [
          IconButton(
            onPressed: () {
              context.push(
                '/animations-shopping/cart',
              );
            },
            icon: const Icon(
              Icons.shopping_bag_outlined,
            ),
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),

        children: [
          const Text(
            'Find your\nfavorite products',
            style: AnimationsShoppingTypography.title,
          ),

          const SizedBox(height: 24),

          Container(
            height: 52,

            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),

              border: Border.all(
                color: AnimationsShoppingColors.border,
              ),
            ),

            child: const Row(
              children: [
                Icon(
                  Icons.search,
                  color:
                  AnimationsShoppingColors.secondaryText,
                ),

                SizedBox(width: 10),

                Text(
                  'Search products',
                  style:
                  AnimationsShoppingTypography.body,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const AnimationsShoppingProductCard(),
        ],
      ),
    );
  }
}