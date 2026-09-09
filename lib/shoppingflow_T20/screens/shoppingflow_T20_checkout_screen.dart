import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_typography.dart';

class ShoppingFlowT20CheckoutScreen
    extends StatelessWidget {
  const ShoppingFlowT20CheckoutScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style:
          ShoppingFlowT20Typography.heading,
        ),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Delivery Address',
            style:
            ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 10),

          const Card(
            child: Padding(
              padding: EdgeInsets.all(14),
              child: Text(
                'Sakshi Darji\n'
                    '123, Green Street.\n'
                    'Surat, Gujarat - 395001\n'
                    '+91 98765 43210',
              ),
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Payment Method',
            style:
            ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 8),

          const Card(
            child: Column(
              children: [
                RadioListTile(
                  value: true,
                  groupValue: true,
                  onChanged: null,
                  title:
                  Text('VISA •••• 4242'),
                ),
                RadioListTile(
                  value: false,
                  groupValue: true,
                  onChanged: null,
                  title: Text('UPI'),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          const Text(
            'Order Summary',
            style:
            ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 10),

          AnimatedBuilder(
            animation: shoppingFlowT20State,
            builder: (_, __) {
              return Column(
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
                ],
              );
            },
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 48,
            child: FilledButton(
              onPressed: () {
                shoppingFlowT20State
                    .placeOrder();

                context.go('/orders');
              },
              child:
              const Text('Place Order'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _row(
      String title,
      double amount, {
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
          '\$${amount.toStringAsFixed(2)}',
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