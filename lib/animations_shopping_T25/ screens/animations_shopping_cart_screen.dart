import 'package:flutter/material.dart';

import '../theme/animations_shopping_colors.dart';
import '../theme/animations_shopping_typography.dart';
import '../widgets/animations_shopping_quantity_button.dart';

class AnimationsShoppingCartScreen extends StatefulWidget {
  const AnimationsShoppingCartScreen({
    super.key,
  });

  @override
  State<AnimationsShoppingCartScreen> createState() =>
      _AnimationsShoppingCartScreenState();
}

class _AnimationsShoppingCartScreenState
    extends State<AnimationsShoppingCartScreen> {
  int quantity = 2;

  @override
  Widget build(BuildContext context) {
    final total = quantity * 2499;

    return Scaffold(
      backgroundColor: AnimationsShoppingColors.background,

      appBar: AppBar(
        backgroundColor: AnimationsShoppingColors.background,
        elevation: 0,

        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),

        title: const Text(
          'My Cart',
          style: AnimationsShoppingTypography.heading,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(12),

              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(
                  color: AnimationsShoppingColors.border,
                ),
              ),

              child: Row(
                children: [
                  Container(
                    width: 90,
                    height: 90,

                    decoration: BoxDecoration(
                      color:
                      AnimationsShoppingColors.imageBackground,
                      borderRadius: BorderRadius.circular(14),
                    ),

                    child: const Icon(
                      Icons.shopping_bag_rounded,
                      size: 48,
                      color: Color(0xFFE9899E),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        const Text(
                          'Elegant Handbag',
                          style: AnimationsShoppingTypography
                              .productName,
                        ),

                        const SizedBox(height: 5),

                        const Text(
                          '₹ 2,499',
                          style:
                          AnimationsShoppingTypography.price,
                        ),

                        const SizedBox(height: 8),

                        AnimationsShoppingQuantityButton(
                          quantity: quantity,

                          onMinus: () {
                            if (quantity > 1) {
                              setState(() {
                                quantity--;
                              });
                            }
                          },

                          onPlus: () {
                            setState(() {
                              quantity++;
                            });
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(
                    Icons.delete_outline,
                    color:
                    AnimationsShoppingColors.secondaryText,
                  ),
                ],
              ),
            ),

            const Spacer(),

            AnimatedContainer(
              duration: const Duration(
                milliseconds: 250,
              ),
              curve: Curves.easeOut,

              width: double.infinity,
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: quantity > 2
                    ? AnimationsShoppingColors.primaryLight
                    : Colors.white,

                borderRadius: BorderRadius.circular(18),

                border: Border.all(
                  color: AnimationsShoppingColors.border,
                ),
              ),

              child: Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,

                children: [
                  const Text(
                    'Subtotal',
                    style:
                    AnimationsShoppingTypography.productName,
                  ),

                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 250,
                    ),

                    transitionBuilder: (
                        child,
                        animation,
                        ) {
                      return ScaleTransition(
                        scale: animation,
                        child: child,
                      );
                    },

                    child: Text(
                      '₹ $total',
                      key: ValueKey(total),
                      style:
                      AnimationsShoppingTypography.price,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            SizedBox(
              width: double.infinity,
              height: 54,

              child: ElevatedButton(
                onPressed: () {},

                style: ElevatedButton.styleFrom(
                  backgroundColor:
                  AnimationsShoppingColors.primary,
                  elevation: 0,

                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),

                child: const Text(
                  'Checkout',
                  style:
                  AnimationsShoppingTypography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}