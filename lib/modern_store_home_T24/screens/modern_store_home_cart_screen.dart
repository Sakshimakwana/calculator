import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../state/modern_store_home_state.dart';
import '../theme/modern_store_home_colors.dart';
import '../widgets/modern_store_home_image.dart';

class ModernStoreHomeCartScreen extends StatelessWidget {
  const ModernStoreHomeCartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: ModernStoreHomeState.cart,
      builder: (context, cart, child) {
        final products = ModernStoreHomeProducts.products
            .where((p) => cart.contains(p.id))
            .toList();

        final total = products.fold<double>(
          0,
              (sum, product) => sum + product.price,
        );

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Cart',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          body: products.isEmpty
              ? const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.shopping_cart_outlined,
                  size: 70,
                  color: Colors.grey,
                ),
                SizedBox(height: 12),
                Text(
                  'Your cart is empty',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          )
              : Column(
            children: [
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.all(20),
                  itemCount: products.length,
                  separatorBuilder: (_, __) =>
                  const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    final product = products[index];

                    return Container(
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                        BorderRadius.circular(16),
                        border: Border.all(
                          color:
                          ModernStoreHomeColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 80,
                            child: ModernStoreHomeImage(
                              url: product.image,
                              borderRadius:
                              BorderRadius.circular(12),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              children: [
                                Text(
                                  product.name,
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  '₹${product.price.toStringAsFixed(0)}',
                                  style: const TextStyle(
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              ModernStoreHomeState
                                  .toggleCart(product.id);
                            },
                            icon: const Icon(
                              Icons.delete_outline,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  15,
                  20,
                  25,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 15,
                      color: Colors.black12,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              color: Colors.grey,
                            ),
                          ),
                          Text(
                            '₹${total.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        ModernStoreHomeColors.primary,
                        foregroundColor: Colors.white,
                        padding:
                        const EdgeInsets.symmetric(
                          horizontal: 30,
                          vertical: 15,
                        ),
                      ),
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}