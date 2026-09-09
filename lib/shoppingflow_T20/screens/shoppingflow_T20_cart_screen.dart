import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_typography.dart';
import '../widgets/shoppingflow_T20_cart_tile.dart';

class ShoppingFlowT20CartScreen
    extends StatelessWidget {
  const ShoppingFlowT20CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Cart',
          style:
          ShoppingFlowT20Typography.heading,
        ),
      ),

      body: AnimatedBuilder(
        animation: shoppingFlowT20State,
        builder: (context, child) {
          final products =
              shoppingFlowT20State.cartProducts;

          if (products.isEmpty) {
            return const Center(
              child: Text(
                'Your cart is empty',
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding:
                  const EdgeInsets.all(16),
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                  const Divider(
                    height: 24,
                  ),
                  itemBuilder: (_, index) {
                    return ShoppingFlowT20CartTile(
                      product: products[index],
                    );
                  },
                ),
              ),

              Padding(
                padding:
                const EdgeInsets.all(16),
                child: Column(
                  children: [
                    _row(
                      'Subtotal',
                      shoppingFlowT20State
                          .subtotal,
                    ),
                    const SizedBox(height: 8),
                    _row(
                      'Shipping',
                      shoppingFlowT20State
                          .shipping,
                    ),
                    const Divider(
                      height: 24,
                    ),
                    _row(
                      'Total',
                      shoppingFlowT20State
                          .total,
                      bold: true,
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: FilledButton(
                        onPressed: () {
                          context.push(
                            '/checkout',
                          );
                        },
                        child:
                        const Text('Checkout'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _row(
      String title,
      double value, {
        bool bold = false,
      }) {
    return Row(
      mainAxisAlignment:
      MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
        Text(
          '\$${value.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: bold
                ? FontWeight.w700
                : FontWeight.w400,
          ),
        ),
      ],
    );
  }
}