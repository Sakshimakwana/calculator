import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../model/shoppingflow_T20_product.dart';
import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';
import 'shoppingflow_T20_product_image.dart';

class ShoppingFlowT20ProductCard extends StatelessWidget {
  final ShoppingFlowT20Product product;

  const ShoppingFlowT20ProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shoppingFlowT20State,
      builder: (context, child) {
        final favourite =
        shoppingFlowT20State.isFavourite(product.id);

        return InkWell(
          onTap: () {
            context.push('/product/${product.id}');
          },
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: ShoppingFlowT20Colors.border,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    ShoppingFlowT20ProductImage(
                      image: product.image,
                      height: 92,
                    ),
                    Positioned(
                      top: 5,
                      right: 5,
                      child: GestureDetector(
                        onTap: () {
                          shoppingFlowT20State
                              .toggleFavourite(product.id);
                        },
                        child: Container(
                          padding:
                          const EdgeInsets.all(4),
                          decoration:
                          const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            favourite
                                ? Icons.favorite
                                : Icons.favorite_border,
                            size: 17,
                            color: favourite
                                ? ShoppingFlowT20Colors.danger
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style:
                  ShoppingFlowT20Typography.body,
                ),
                const SizedBox(height: 2),
                Text(
                  '\$${product.price.toStringAsFixed(2)}',
                  style:
                  ShoppingFlowT20Typography.body.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}