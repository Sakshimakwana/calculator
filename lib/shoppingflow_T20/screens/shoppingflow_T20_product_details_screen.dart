import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/shoppingflow_T20_data.dart';
import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';
import '../widgets/shoppingflow_T20_product_image.dart';

class ShoppingFlowT20ProductDetailsScreen extends StatefulWidget {
  final String id;

  const ShoppingFlowT20ProductDetailsScreen({
    super.key,
    required this.id,
  });

  @override
  State<ShoppingFlowT20ProductDetailsScreen> createState() =>
      _ShoppingFlowT20ProductDetailsScreenState();
}

class _ShoppingFlowT20ProductDetailsScreenState
    extends State<ShoppingFlowT20ProductDetailsScreen> {

  String? _selectedSize;

  final List<String> _sizes = [
    '7',
    '8',
    '9',
    '10',
    '11',
  ];

  @override
  Widget build(BuildContext context) {
    final product = shoppingFlowT20Products.firstWhere(
          (product) => product.id == widget.id,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),

        actions: [
          AnimatedBuilder(
            animation: shoppingFlowT20State,

            builder: (_, __) {
              final favourite =
              shoppingFlowT20State.isFavourite(product.id);

              return IconButton(
                onPressed: () {
                  shoppingFlowT20State.toggleFavourite(
                    product.id,
                  );
                },

                icon: Icon(
                  favourite
                      ? Icons.favorite
                      : Icons.favorite_border,

                  color: favourite
                      ? ShoppingFlowT20Colors.danger
                      : null,
                ),
              );
            },
          ),
        ],
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          // Product image
          ShoppingFlowT20ProductImage(
            image: product.image,
            height: 310,
          ),

          const SizedBox(height: 16),

          // Product name
          Text(
            product.name,
            style: ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 7),

          // Rating
          Text(
            '★ ${product.rating} (128)',
            style: const TextStyle(
              color: ShoppingFlowT20Colors.warning,
              fontSize: 13,
            ),
          ),

          const SizedBox(height: 8),

          // Price
          Text(
            '\$${product.price.toStringAsFixed(2)}',
            style: ShoppingFlowT20Typography.title,
          ),

          const SizedBox(height: 20),

          // Size
          const Text(
            'Size',
            style: ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 10),

          // Size buttons
          Wrap(
            spacing: 8,
            runSpacing: 8,

            children: _sizes.map(
                  (size) {

                final isSelected =
                    _selectedSize == size;

                return OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedSize = size;
                    });
                  },

                  style: OutlinedButton.styleFrom(
                    backgroundColor: isSelected
                        ? Colors.blue
                        : Colors.transparent,

                    foregroundColor: isSelected
                        ? Colors.white
                        : Colors.black,

                    side: BorderSide(
                      color: isSelected
                          ? Colors.blue
                          : Colors.grey,
                    ),
                  ),

                  child: Text(size),
                );
              },
            ).toList(),
          ),

          const SizedBox(height: 20),

          // Description
          const Text(
            'Description',
            style: ShoppingFlowT20Typography.heading,
          ),

          const SizedBox(height: 6),

          const Text(
            'Comfortable and stylish product designed '
                'for everyday use.',
            style: ShoppingFlowT20Typography.body,
          ),

          const SizedBox(height: 24),

          // Add to Cart
          SizedBox(
            height: 48,

            child: FilledButton(
              onPressed: () {

                // Check size
                if (_selectedSize == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Please select a size',
                      ),
                    ),
                  );

                  return;
                }

                // Add product
                shoppingFlowT20State.addToCart(
                  product.id,
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Size $_selectedSize added to cart',
                    ),
                    duration: const Duration(
                      seconds: 1,
                    ),
                  ),
                );
              },

              child: const Text(
                'Add to Cart',
              ),
            ),
          ),

          const SizedBox(height: 10),

          // View Cart
          SizedBox(
            height: 48,

            child: OutlinedButton(
              onPressed: () {
                context.go('/cart');
              },

              child: const Text(
                'View Cart',
              ),
            ),
          ),
        ],
      ),
    );
  }
}