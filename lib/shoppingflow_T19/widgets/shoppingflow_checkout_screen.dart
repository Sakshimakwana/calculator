import 'package:flutter/material.dart';

import '../theme/shoppingflow_colors.dart';
import '../theme/shoppingflow_typography.dart';
import 'shoppingflow_order_success_screen.dart';

class ShoppingFlowCheckoutScreen extends StatefulWidget {
  final double total;

  const ShoppingFlowCheckoutScreen({
    super.key,
    required this.total,
  });

  @override
  State<ShoppingFlowCheckoutScreen> createState() =>
      _ShoppingFlowCheckoutScreenState();
}

class _ShoppingFlowCheckoutScreenState
    extends State<ShoppingFlowCheckoutScreen> {

  final TextEditingController nameController =
  TextEditingController();

  final TextEditingController addressController =
  TextEditingController();

  void _placeOrder() {

    if (nameController.text.trim().isEmpty ||
        addressController.text.trim().isEmpty) {

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Please enter name and address',
          ),
        ),
      );

      return;
    }

    Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return const ShoppingFlowOrderSuccessScreen();
        },
      ),
    );

    // Returning result to Cart can also be done
    // after the success screen.
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Checkout',
          style: ShoppingFlowTypography.appBarTitle,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            const Text(
              'Delivery Details',
              style: ShoppingFlowTypography.heading,
            ),

            const SizedBox(height: 25),

            TextField(
              controller: nameController,

              decoration: InputDecoration(
                labelText: 'Full Name',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 16),

            TextField(
              controller: addressController,

              maxLines: 3,

              decoration: InputDecoration(
                labelText: 'Delivery Address',
                border: OutlineInputBorder(
                  borderRadius:
                  BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: double.infinity,

              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: ShoppingFlowColors.primaryLight,
                borderRadius:
                BorderRadius.circular(14),
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [

                  const Text(
                    'Total Amount',
                    style:
                    ShoppingFlowTypography.productName,
                  ),

                  Text(
                    '₹${widget.total.toStringAsFixed(0)}',
                    style:
                    ShoppingFlowTypography.price,
                  ),
                ],
              ),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              height: 52,

              child: ElevatedButton(
                onPressed: _placeOrder,

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  ShoppingFlowColors.primary,

                  shape: RoundedRectangleBorder(
                    borderRadius:
                    BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'Place Order',
                  style: ShoppingFlowTypography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}