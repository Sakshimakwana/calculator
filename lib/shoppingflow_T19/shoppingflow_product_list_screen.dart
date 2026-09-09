import 'package:app_matic_tech_flutter_app/shoppingflow_T19/theme/shoppingflow_typography.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_cart_screen.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_card.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_details_screen.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_model.dart';
import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_products_data.dart';
import 'package:flutter/material.dart';


class ShoppingFlowProductListScreen extends StatefulWidget {
  const ShoppingFlowProductListScreen({super.key});

  @override
  State<ShoppingFlowProductListScreen> createState() => _ShoppingFlowProductListScreenState();
}

class _ShoppingFlowProductListScreenState extends State<ShoppingFlowProductListScreen> {

  final List<ShoppingFlowProduct> cart = [];

  void _openProductDetails(ShoppingFlowProduct product) async {

    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return ShoppingFlowProductDetailsScreen(
            product: product,
          );
        },
      ),
    );

    // Returned result from Details screen
    if (result != null && result is ShoppingFlowProduct) {
      setState(() {
        cart.add(result);
      });
    }
  }

  void _openCart() async {

    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return ShoppingFlowCartScreen(
            cart: cart,
          );
        },
      ),
    );

    if (result == true) {
      setState(() {
        cart.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Shopping',
          style: ShoppingFlowTypography.appBarTitle,
        ),

        actions: [
          IconButton(
            onPressed: _openCart,

            icon: Badge(
              label: Text(cart.length.toString()),
              isLabelVisible: cart.isNotEmpty,
              child: const Icon(Icons.shopping_cart_outlined),
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const Text(
              'Discover Products',
              style: ShoppingFlowTypography.heading,
            ),

            const SizedBox(height: 6),

            const Text(
              'Choose your favorite products',
              style: ShoppingFlowTypography.body,
            ),

            const SizedBox(height: 20),

            Expanded(
              child: ListView.builder(
                itemCount: ShoppingFlowProducts.products.length,

                itemBuilder: (context, index) {

                  final product =
                  ShoppingFlowProducts.products[index];

                  return ShoppingFlowProductCard(
                    product: product,

                    onTap: () {
                      _openProductDetails(product);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}