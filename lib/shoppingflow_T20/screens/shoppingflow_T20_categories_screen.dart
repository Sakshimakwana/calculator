import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/shoppingflow_T20_data.dart';
import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';
import '../widgets/shoppingflow_T20_product_card.dart';

class ShoppingFlowT20CategoriesScreen
    extends StatelessWidget {
  const ShoppingFlowT20CategoriesScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style:
          ShoppingFlowT20Typography.heading,
        ),
        actions: [
          IconButton(
            onPressed: () {
              context.push('/search');
            },
            icon: const Icon(Icons.search),
          ),
        ],
      ),

      body: Row(
        children: [
          SizedBox(
            width: 105,
            child: Container(
              color: ShoppingFlowT20Colors.surface,
              child: ListView(
                padding:
                const EdgeInsets.symmetric(
                  vertical: 12,
                ),
                children: [
                  _category(
                    context,
                    'Men',
                  ),
                  _category(
                    context,
                    'Women',
                  ),
                  _category(
                    context,
                    'Shoes',
                  ),
                  _category(
                    context,
                    'Bags',
                  ),
                  _category(
                    context,
                    'Watches',
                  ),
                  _category(
                    context,
                    'Accessories',
                  ),
                  _category(
                    context,
                    'Electronics',
                  ),
                  _category(
                    context,
                    'Beauty',
                  ),
                ],
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: GridView.builder(
                itemCount:
                shoppingFlowT20Products.length,
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                  childAspectRatio: .67,
                ),
                itemBuilder: (_, index) {
                  return ShoppingFlowT20ProductCard(
                    product:
                    shoppingFlowT20Products[index],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _category(
      BuildContext context,
      String name,
      ) {
    return InkWell(
      onTap: () {
        context.push('/categories/$name');
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 11,
          horizontal: 14,
        ),
        child: Text(
          name,
          style: ShoppingFlowT20Typography.body,
        ),
      ),
    );
  }
}