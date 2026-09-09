import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_typography.dart';

class ShoppingFlowT20OrdersScreen extends StatelessWidget {
  const ShoppingFlowT20OrdersScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            context.go('/home');
          },
        ),
        title: const Text(
          'My Orders',
          style: ShoppingFlowT20Typography.heading,
        ),
      ),

      body: AnimatedBuilder(
        animation: shoppingFlowT20State,

        builder: (context, child) {
          // No real orders yet
          if (shoppingFlowT20State.orders.isEmpty) {
            return ListView(
              padding: const EdgeInsets.all(16),

              children: const [
                ShoppingFlowT20OrderCard(
                  orderId: '1234',
                  productName: 'T-Shirt',
                  status: 'Processing',
                  date: 'May 20, 2024',
                  quantity: 2,
                  price: 74.99,
                  total: 149.99,
                ),

                SizedBox(height: 16),

                ShoppingFlowT20OrderCard(
                  orderId: '1233',
                  productName: 'Shoes',
                  status: 'Shipped',
                  date: 'May 18, 2024',
                  quantity: 1,
                  price: 59.99,
                  total: 59.99,
                ),

                SizedBox(height: 16),

                ShoppingFlowT20OrderCard(
                  orderId: '1232',
                  productName: 'Jacket',
                  status: 'Delivered',
                  date: 'May 15, 2024',
                  quantity: 1,
                  price: 199.99,
                  total: 199.99,
                ),
              ],
            );
          }

          // Real orders
          return ListView.builder(
            padding: const EdgeInsets.all(16),

            itemCount:
            shoppingFlowT20State.orders.length,

            itemBuilder: (context, index) {
              final order =
              shoppingFlowT20State.orders[index];

              final double total =
              (order['total'] as num).toDouble();

              return ShoppingFlowT20OrderCard(
                orderId: '${order['id']}',
                productName:
                '${order['productName'] ?? 'Product'}',
                status:
                '${order['status']}',
                date:
                '${order['date'] ?? 'Order date'}',
                quantity:
                (order['quantity'] as num?)?.toInt() ?? 1,
                price:
                (order['price'] as num?)?.toDouble() ??
                    total,
                total: total,
              );
            },
          );
        },
      ),
    );
  }
}


// =====================================================
// ORDER CARD
// =====================================================

class ShoppingFlowT20OrderCard extends StatelessWidget {
  const ShoppingFlowT20OrderCard({
    super.key,
    required this.orderId,
    required this.productName,
    required this.status,
    required this.date,
    required this.quantity,
    required this.price,
    required this.total,
  });

  final String orderId;
  final String productName;
  final String status;
  final String date;
  final int quantity;
  final double price;
  final double total;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(
        color: Colors.white,

        borderRadius:
        BorderRadius.circular(16),

        border: Border.all(
          color: Colors.grey.shade300,
        ),

        boxShadow: [
          BoxShadow(
            color:
            Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: Column(
        crossAxisAlignment:
        CrossAxisAlignment.start,

        children: [

          // Order number + status
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              Text(
                'Order #$orderId',

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              Container(
                padding:
                const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),

                decoration: BoxDecoration(
                  color:
                  Colors.blue.shade50,
                  borderRadius:
                  BorderRadius.circular(20),
                ),

                child: Text(
                  status,

                  style: TextStyle(
                    color:
                    Colors.blue.shade700,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 5),

          Text(
            date,

            style: TextStyle(
              color:
              Colors.grey.shade600,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 12),

          // Product
          Row(
            children: [

              Container(
                width: 75,
                height: 75,

                decoration: BoxDecoration(
                  color:
                  Colors.grey.shade100,
                  borderRadius:
                  BorderRadius.circular(12),
                ),

                child: const Icon(
                  Icons.shopping_bag_outlined,
                  size: 35,
                ),
              ),

              const SizedBox(width: 14),

              Expanded(
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,

                  children: [

                    Text(
                      productName,

                      style:
                      const TextStyle(
                        fontSize: 16,
                        fontWeight:
                        FontWeight.w600,
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      'Quantity: $quantity',

                      style: TextStyle(
                        color:
                        Colors.grey.shade600,
                      ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      'Price: \$${price.toStringAsFixed(2)}',

                      style: TextStyle(
                        color:
                        Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 15),

          const Divider(),

          const SizedBox(height: 10),

          // Total
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,

            children: [

              const Text(
                'Total',

                style: TextStyle(
                  fontSize: 16,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),

              Text(
                '\$${total.toStringAsFixed(2)}',

                style:
                const TextStyle(
                  fontSize: 18,
                  fontWeight:
                  FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}