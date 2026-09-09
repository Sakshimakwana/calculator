import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_model.dart';
import 'package:flutter/material.dart';

import '../theme/shoppingflow_colors.dart';
import '../theme/shoppingflow_typography.dart';
import 'shoppingflow_checkout_screen.dart';

class ShoppingFlowCartScreen extends StatefulWidget {
  final List<ShoppingFlowProduct> cart;

  const ShoppingFlowCartScreen({
    super.key,
    required this.cart,
  });

  @override
  State<ShoppingFlowCartScreen> createState() =>
      _ShoppingFlowCartScreenState();
}

class _ShoppingFlowCartScreenState
    extends State<ShoppingFlowCartScreen> {

  // Calculate total cart price
  double get total {
    double amount = 0;

    for (final product in widget.cart) {
      amount += product.price;
    }

    return amount;
  }

  // Delete product with confirmation dialog
  Future<void> _deleteProduct(int index) async {
    final product = widget.cart[index];

    final bool? shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Delete Product?',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),

          content: Text(
            'Are you sure you want to remove '
                '"${product.name}" from your cart?',
          ),

          actions: [
            // Cancel button
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },

              child: const Text(
                'Cancel',
              ),
            ),

            // Delete button
            TextButton(
              onPressed: () {
                Navigator.pop(context, true);
              },

              child: const Text(
                'Delete',
                style: TextStyle(
                  color: ShoppingFlowColors.error,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        );
      },
    );

    // Delete only when user confirms
    if (shouldDelete == true) {
      setState(() {
        widget.cart.removeAt(index);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${product.name} removed from cart',
          ),
        ),
      );
    }
  }

  // Navigate to checkout
  Future<void> _checkout() async {
    // Check empty cart
    if (widget.cart.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Your cart is empty',
          ),
        ),
      );

      return;
    }

    // Navigate to Checkout
    final result = await Navigator.push(
      context,

      MaterialPageRoute(
        builder: (context) {
          return ShoppingFlowCheckoutScreen(
            total: total,
          );
        },
      ),
    );

    // Receive returned result from Checkout
    if (result != null && result is Map) {
      final bool orderPlaced =
          result['orderPlaced'] ?? false;

      if (orderPlaced) {
        if (!mounted) return;

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Order placed successfully!',
            ),
          ),
        );

        // Return true to Product List
        Navigator.pop(
          context,
          true,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'My Cart',
          style: ShoppingFlowTypography.appBarTitle,
        ),
      ),

      body: widget.cart.isEmpty
          ? const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [
            Icon(
              Icons.shopping_cart_outlined,
              size: 70,
              color: ShoppingFlowColors.grey,
            ),

            SizedBox(height: 15),

            Text(
              'Your cart is empty',
              style:
              ShoppingFlowTypography.productName,
            ),

            SizedBox(height: 5),

            Text(
              'Add some products to your cart',
              style:
              ShoppingFlowTypography.body,
            ),
          ],
        ),
      )

          : Column(
        children: [

          // Product List
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),

              itemCount: widget.cart.length,

              itemBuilder: (context, index) {
                final product =
                widget.cart[index];

                return Container(
                  margin:
                  const EdgeInsets.only(
                    bottom: 12,
                  ),

                  padding:
                  const EdgeInsets.all(10),

                  decoration: BoxDecoration(
                    color:
                    ShoppingFlowColors.white,

                    borderRadius:
                    BorderRadius.circular(14),

                    boxShadow: [
                      BoxShadow(
                        blurRadius: 8,

                        offset:
                        const Offset(0, 3),

                        color: Colors.black
                            .withValues(
                          alpha: 0.05,
                        ),
                      ),
                    ],
                  ),

                  child: Row(
                    children: [

                      // Product Image
                      ClipRRect(
                        borderRadius:
                        BorderRadius.circular(
                          10,
                        ),

                        child: Image.network(
                          product.image,

                          width: 80,
                          height: 80,

                          fit: BoxFit.cover,

                          errorBuilder:
                              (
                              context,
                              error,
                              stackTrace,
                              ) {
                            return Container(
                              width: 80,
                              height: 80,

                              color:
                              ShoppingFlowColors
                                  .lightGrey,

                              child:
                              const Icon(
                                Icons
                                    .image_not_supported,
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(width: 12),

                      // Product Information
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                          children: [

                            Text(
                              product.name,

                              style:
                              ShoppingFlowTypography
                                  .productName,
                            ),

                            const SizedBox(
                              height: 8,
                            ),

                            Text(
                              '₹${product.price.toStringAsFixed(0)}',

                              style:
                              ShoppingFlowTypography
                                  .price,
                            ),
                          ],
                        ),
                      ),

                      // Delete Button
                      IconButton(
                        onPressed: () {
                          _deleteProduct(index);
                        },

                        icon: const Icon(
                          Icons.delete_outline,

                          color:
                          ShoppingFlowColors
                              .error,
                        ),

                        tooltip:
                        'Remove product',
                      ),
                    ],
                  ),
                );
              },
            ),
          ),

          // Bottom Total Section
          Container(
            padding:
            const EdgeInsets.all(20),

            decoration:
            const BoxDecoration(
              color:
              ShoppingFlowColors.white,
            ),

            child: Column(
              children: [

                // Total Row
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment
                      .spaceBetween,

                  children: [

                    const Text(
                      'Total',

                      style:
                      ShoppingFlowTypography
                          .productName,
                    ),

                    Text(
                      '₹${total.toStringAsFixed(0)}',

                      style:
                      ShoppingFlowTypography
                          .price,
                    ),
                  ],
                ),

                const SizedBox(height: 15),

                // Checkout Button
                SizedBox(
                  width: double.infinity,
                  height: 52,

                  child: ElevatedButton(
                    onPressed: _checkout,

                    style:
                    ElevatedButton.styleFrom(
                      backgroundColor:
                      ShoppingFlowColors
                          .primary,

                      shape:
                      RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(
                          14,
                        ),
                      ),
                    ),

                    child: const Text(
                      'Proceed to Checkout',

                      style:
                      ShoppingFlowTypography
                          .button,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}