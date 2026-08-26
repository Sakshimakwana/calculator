import 'package:flutter/material.dart';
import '../models/product_catalogue_model.dart';

class CartScreen extends StatefulWidget {
  final List<ProductModel> products;

  const CartScreen({
    super.key,
    required this.products,
  });

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {

  double get totalPrice {
    double total = 0;

    for (final product in widget.products) {
      total += product.price * product.quantity;
    }

    return total;
  }

  @override
  Widget build(BuildContext context) {

    final cartProducts = widget.products
        .where((product) => product.quantity > 0)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
      ),

      body: cartProducts.isEmpty
          ? const Center(
        child: Text(
          'Your cart is empty',
          style: TextStyle(fontSize: 18),
        ),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: cartProducts.length,
        itemBuilder: (context, index) {

          final product = cartProducts[index];

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [

                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [

                        Text(
                          product.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                        ),

                        const SizedBox(height: 8),

                        Row(
                          children: [

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  if (product.quantity > 1) {
                                    product.quantity--;
                                  } else {
                                    product.quantity = 0;
                                  }
                                });
                              },
                              icon: const Icon(
                                Icons.remove_circle_outline,
                              ),
                            ),

                            Text(
                              '${product.quantity}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            IconButton(
                              onPressed: () {
                                setState(() {
                                  product.quantity++;
                                });
                              },
                              icon: const Icon(
                                Icons.add_circle_outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

      bottomNavigationBar: cartProducts.isEmpty
          ? null
          : Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
          children: [

            const Text(
              'Total:',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text(
              '₹${totalPrice.toStringAsFixed(0)}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}