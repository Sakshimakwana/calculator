import 'package:flutter/material.dart';
import '../model/shoppingflow_T20_product.dart';
import '../state/shoppingflow_T20_state.dart';
import '../theme/shoppingflow_T20_colors.dart';
import '../theme/shoppingflow_T20_typography.dart';
import 'shoppingflow_T20_product_image.dart';

class ShoppingFlowT20CartTile
    extends StatelessWidget {
  final ShoppingFlowT20Product product;

  const ShoppingFlowT20CartTile({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: shoppingFlowT20State,
      builder: (context, child) {
        final quantity =
        shoppingFlowT20State.quantity(product.id);

        return Row(
          children: [
            SizedBox(
              width: 75,
              child: ShoppingFlowT20ProductImage(
                image: product.image,
                height: 75,
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
                    style:
                    ShoppingFlowT20Typography.body,
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style:
                    ShoppingFlowT20Typography.body.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    'Qty: $quantity',
                    style:
                    ShoppingFlowT20Typography.caption,
                  ),
                ],
              ),
            ),

            IconButton(
              onPressed: () {
                shoppingFlowT20State
                    .removeFromCart(product.id);
              },
              icon: const Icon(
                Icons.delete_outline,
                size: 19,
              ),
            ),

            GestureDetector(
              onTap: () {
                shoppingFlowT20State
                    .decreaseQuantity(product.id);
              },
              child: const Icon(
                Icons.remove_circle_outline,
                size: 19,
              ),
            ),

            Padding(
              padding:
              const EdgeInsets.symmetric(
                horizontal: 8,
              ),
              child: Text('$quantity'),
            ),

            GestureDetector(
              onTap: () {
                shoppingFlowT20State
                    .addToCart(product.id);
              },
              child: const Icon(
                Icons.add_circle_outline,
                size: 19,
                color: ShoppingFlowT20Colors.primary,
              ),
            ),
          ],
        );
      },
    );
  }
}