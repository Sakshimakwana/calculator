import 'package:flutter/material.dart';

import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_typography.dart';
import '../widgets/shoppingflow_T20_product_card.dart';

class ShoppingFlowT20FavouritesScreen
    extends StatelessWidget {
  const ShoppingFlowT20FavouritesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Favourites',
          style:
          ShoppingFlowT20Typography.heading,
        ),
      ),

      body: AnimatedBuilder(
        animation: shoppingFlowT20State,
        builder: (_, __) {
          final products =
              shoppingFlowT20State
                  .favouriteProducts;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'No favourites yet',
              ),
            );
          }

          return GridView.builder(
            padding:
            const EdgeInsets.all(16),
            itemCount: products.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: .67,
            ),
            itemBuilder: (_, index) {
              return ShoppingFlowT20ProductCard(
                product: products[index],
              );
            },
          );
        },
      ),
    );
  }
}