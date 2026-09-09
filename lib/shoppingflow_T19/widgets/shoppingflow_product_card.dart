import 'package:app_matic_tech_flutter_app/shoppingflow_T19/widgets/shoppingflow_product_model.dart';
import 'package:flutter/material.dart';
import '../theme/shoppingflow_colors.dart';
import '../theme/shoppingflow_typography.dart';

class ShoppingFlowProductCard extends StatelessWidget {
  final ShoppingFlowProduct product;
  final VoidCallback onTap;

  const ShoppingFlowProductCard({
    super.key,
    required this.product,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        margin: const EdgeInsets.only(bottom: 16),

        decoration: BoxDecoration(
          color: ShoppingFlowColors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              blurRadius: 10,
              offset: const Offset(0, 4),
              color: Colors.black.withValues(alpha: 0.06),
            ),
          ],
        ),

        child: Row(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(18),
                bottomLeft: Radius.circular(18),
              ),

              child: Image.network(
                product.image,
                width: 120,
                height: 130,
                fit: BoxFit.cover,

                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: 120,
                    height: 130,
                    color: ShoppingFlowColors.lightGrey,
                    child: const Icon(Icons.image_not_supported),
                  );
                },
              ),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,

                  children: [
                    Text(
                      product.name,
                      style: ShoppingFlowTypography.productName,
                    ),

                    const SizedBox(height: 7),

                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          size: 17,
                          color: Colors.amber,
                        ),

                        const SizedBox(width: 4),

                        Text(
                          product.rating.toString(),
                          style: ShoppingFlowTypography.body,
                        ),
                      ],
                    ),

                    const SizedBox(height: 10),

                    Text(
                      '₹${product.price.toStringAsFixed(0)}',
                      style: ShoppingFlowTypography.price,
                    ),

                    const SizedBox(height: 6),

                    const Text(
                      'View Details →',
                      style: TextStyle(
                        color: ShoppingFlowColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}