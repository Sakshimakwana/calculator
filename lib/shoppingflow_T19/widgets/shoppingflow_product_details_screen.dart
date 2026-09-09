import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_model.dart';
import 'package:flutter/material.dart';
import '../theme/shoppingflow_colors.dart';
import '../theme/shoppingflow_typography.dart';

class ShoppingFlowProductDetailsScreen extends StatelessWidget {
  final ShoppingFlowProduct product;

  const ShoppingFlowProductDetailsScreen({
    super.key,
    required this.product,
  });

  void _addToCart(BuildContext context) {

    Navigator.pop(
      context,
      product,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Product Details',
          style: ShoppingFlowTypography.appBarTitle,
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Image.network(
              product.image,
              width: double.infinity,
              height: 320,
              fit: BoxFit.cover,

              errorBuilder: (context, error, stackTrace) {
                return Container(
                  height: 320,
                  color: ShoppingFlowColors.lightGrey,
                  child: const Center(
                    child: Icon(
                      Icons.image_not_supported,
                      size: 50,
                    ),
                  ),
                );
              },
            ),

            Padding(
              padding: const EdgeInsets.all(20),

              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,

                children: [

                  Text(
                    product.name,
                    style: ShoppingFlowTypography.heading,
                  ),

                  const SizedBox(height: 10),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),

                      const SizedBox(width: 5),

                      Text(
                        '${product.rating}',
                        style: ShoppingFlowTypography.body,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    '₹${product.price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                      color: ShoppingFlowColors.price,
                    ),
                  ),

                  const SizedBox(height: 20),

                  const Text(
                    'Description',
                    style: ShoppingFlowTypography.productName,
                  ),

                  const SizedBox(height: 8),

                  Text(
                    product.description,
                    style: ShoppingFlowTypography.body,
                  ),

                  const SizedBox(height: 35),

                  SizedBox(
                    width: double.infinity,
                    height: 52,

                    child: ElevatedButton(
                      onPressed: () {
                        _addToCart(context);
                      },

                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        ShoppingFlowColors.primary,

                        shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(14),
                        ),
                      ),

                      child: const Text(
                        'Add to Cart',
                        style: ShoppingFlowTypography.button,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}