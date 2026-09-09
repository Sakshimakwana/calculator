import 'package:flutter/material.dart';

import '../data/shoppingflow_T20_data.dart';
import '../widgets/shoppingflow_T20_product_card.dart';

class ShoppingFlowT20SearchScreen
    extends StatefulWidget {
  const ShoppingFlowT20SearchScreen({
    super.key,
  });

  @override
  State<ShoppingFlowT20SearchScreen>
  createState() =>
      _ShoppingFlowT20SearchScreenState();
}

class _ShoppingFlowT20SearchScreenState
    extends State<ShoppingFlowT20SearchScreen> {
  String search = '';

  @override
  Widget build(BuildContext context) {
    final products =
    shoppingFlowT20Products.where(
          (product) {
        return product.name
            .toLowerCase()
            .contains(search.toLowerCase()) ||
            product.category
                .toLowerCase()
                .contains(search.toLowerCase());
      },
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search products',
            border: InputBorder.none,
          ),
          onChanged: (value) {
            setState(() {
              search = value;
            });
          },
        ),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
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