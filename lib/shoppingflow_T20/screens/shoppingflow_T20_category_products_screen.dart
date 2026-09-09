import 'package:flutter/material.dart';

import '../data/shoppingflow_T20_data.dart';
import '../theme/shoppingflow_T20_typography.dart';
import '../widgets/shoppingflow_T20_product_card.dart';

class ShoppingFlowT20CategoryProductsScreen
    extends StatelessWidget {
  final String category;

  const ShoppingFlowT20CategoryProductsScreen({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    final products =
    shoppingFlowT20Products.where(
          (product) =>
      product.category.toLowerCase() ==
          category.toLowerCase(),
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(category),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: products.isEmpty
          ? const Center(
        child: Text(
          'No products found',
        ),
      )
          : GridView.builder(
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
      ),
    );
  }
}