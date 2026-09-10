import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../widgets/modern_store_home_bottom_nav.dart';
import '../widgets/modern_store_home_product_card.dart';

class ModernStoreHomeDealsScreen extends StatelessWidget {
  const ModernStoreHomeDealsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deals = ModernStoreHomeProducts.products
        .where((product) => product.discount >= 28)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Deals',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: deals.length,
        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: .68,
        ),
        itemBuilder: (context, index) {
          return ModernStoreHomeProductCard(
            product: deals[index],
          );
        },
      ),
      bottomNavigationBar:
      const ModernStoreHomeBottomNav(currentIndex: 2),
    );
  }
}