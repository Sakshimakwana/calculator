import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../state/modern_store_home_state.dart';
import '../widgets/modern_store_home_bottom_nav.dart';
import '../widgets/modern_store_home_product_card.dart';

class ModernStoreHomeWishlistScreen extends StatelessWidget {
  const ModernStoreHomeWishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: ModernStoreHomeState.wishlist,
      builder: (context, wishlist, child) {
        final products = ModernStoreHomeProducts.products
            .where((p) => wishlist.contains(p.id))
            .toList();

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Wishlist',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: products.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.favorite_border,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Your wishlist is empty',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  'Add products you love',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
              : GridView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: products.length,
            gridDelegate:
            const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 14,
              crossAxisSpacing: 14,
              childAspectRatio: .68,
            ),
            itemBuilder: (context, index) {
              return ModernStoreHomeProductCard(
                product: products[index],
              );
            },
          ),
          bottomNavigationBar:
          const ModernStoreHomeBottomNav(currentIndex: 3),
        );
      },
    );
  }
}