import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import 'milestone_app_6_image.dart';

class MilestoneApp6FoodCard extends StatelessWidget {
  final MilestoneApp6Food food;
  final MilestoneApp6State state;
  final VoidCallback? onTap;
  final bool restaurantIsOpen;

  const MilestoneApp6FoodCard({
    super.key,
    required this.food,
    required this.state,
    this.onTap,
    this.restaurantIsOpen = true,
  });

  // ==============================================================
  // CART KEY
  // ==============================================================

  String get _cartKey => '${food.id}_Small';

  // ==============================================================
  // CURRENT QUANTITY
  // ==============================================================

  int get _quantity {
    return state.cart[_cartKey]?.quantity ?? 0;
  }

  // ==============================================================
  // ADD FIRST ITEM
  // ==============================================================

  Future<void> _addItem(BuildContext context) async {
    final bool added = await state.addFoodToCart(
      context: context,
      food: food,
      size: 'Small',
      unitPrice: food.price,
      quantity: 1,
    );

    if (!context.mounted || !added) {
      return;
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(
                Icons.check_circle_rounded,
                color: Colors.white,
                size: 18,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  '${food.name} added to cart',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(milliseconds: 1200),
          margin: const EdgeInsets.fromLTRB(
            16,
            0,
            16,
            16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
  }

  // ==============================================================
  // INCREASE
  // ==============================================================

  void _increaseQuantity() {
    state.addToCart(
      food,
      size: 'Small',
      unitPrice: food.price,
      quantity: 1,
    );
  }

  // ==============================================================
  // DECREASE
  // ==============================================================

  void _decreaseQuantity() {
    state.removeFromCart(
      food,
      size: 'Small',
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool restaurantClosed = !restaurantIsOpen;
    final bool foodAvailable = food.isAvailable;

    final bool canAddToCart =
        restaurantIsOpen && foodAvailable;

    final String availabilityText = restaurantClosed
        ? 'Restaurant Closed'
        : foodAvailable
        ? 'Available'
        : 'Not Available';

    final Color availabilityColor = restaurantClosed
        ? const Color(0xFF757575)
        : foodAvailable
        ? const Color(0xFF00A651)
        : const Color(0xFFE53935);

    final IconData availabilityIcon = restaurantClosed
        ? Icons.store_rounded
        : foodAvailable
        ? Icons.check_circle_rounded
        : Icons.cancel_rounded;

    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final int quantity = _quantity;

        return Hero(
          tag: 'food-${food.id}',
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              // onTap: restaurantClosed
              //     ? null
              //     : onTap ??
              //         () {
              //       context.push('/food/${food.id}');
              //     },
              borderRadius: BorderRadius.circular(16),
              child: Container(
                width: double.infinity,
                height: 245,

                decoration: BoxDecoration(
                  color: restaurantClosed
                      ? const Color(0xFFF1F1F1)
                      : theme.cardColor,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.black.withOpacity(0.04),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                clipBehavior: Clip.antiAlias,

                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // FOOD IMAGE
                    // ==================================================

                    SizedBox(
                      height: 115,
                      width: double.infinity,
                      child: restaurantClosed
                          ? ColorFiltered(
                        colorFilter:
                        const ColorFilter.matrix(
                          <double>[
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0.2126,
                            0.7152,
                            0.0722,
                            0,
                            0,
                            0,
                            0,
                            0,
                            1,
                            0,
                          ],
                        ),
                        child: MilestoneApp6Image(
                          url: food.image,
                          fit: BoxFit.cover,
                          borderRadius:
                          const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      )
                          : MilestoneApp6Image(
                        url: food.image,
                        fit: BoxFit.cover,
                        borderRadius:
                        const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),
                    ),

                    // ==================================================
                    // FOOD DETAILS
                    // ==================================================

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          10,
                          7,
                          10,
                          7,
                        ),
                        child: Column(
                          crossAxisAlignment:
                          CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            // ==========================================
                            // FOOD NAME
                            // ==========================================

                            SizedBox(
                              height: 18,
                              child: Text(
                                food.name,
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
                                style: theme
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(
                                  fontSize: 13,
                                  fontWeight:
                                  FontWeight.w800,
                                  color: restaurantClosed
                                      ? const Color(
                                    0xFF777777,
                                  )
                                      : null,
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // ==========================================
                            // AVAILABILITY
                            // ==========================================

                            Container(
                              height: 23,
                              padding:
                              const EdgeInsets.symmetric(
                                horizontal: 7,
                              ),
                              decoration: BoxDecoration(
                                color: availabilityColor
                                    .withOpacity(0.10),
                                borderRadius:
                                BorderRadius.circular(6),
                                border: Border.all(
                                  color: availabilityColor
                                      .withOpacity(0.20),
                                ),
                              ),
                              child: Row(
                                mainAxisSize:
                                MainAxisSize.min,
                                children: [
                                  Icon(
                                    availabilityIcon,
                                    size: 11,
                                    color:
                                    availabilityColor,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    availabilityText,
                                    style: TextStyle(
                                      fontSize: 9,
                                      fontWeight:
                                      FontWeight.w800,
                                      color:
                                      availabilityColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Spacer(),

                            // ==========================================
                            // PRICE
                            // ==========================================

                            SizedBox(
                              height: 20,
                              width: double.infinity,
                              child: Align(
                                alignment:
                                Alignment.centerRight,
                                child: Text(
                                  '\$${food.price.toStringAsFixed(2)}',
                                  style: theme
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                    fontSize: 14,
                                    fontWeight:
                                    FontWeight.w900,
                                    color: restaurantClosed
                                        ? const Color(
                                      0xFF888888,
                                    )
                                        : null,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 5),

                            // ==========================================
                            // CART CONTROL
                            // ==========================================

                            SizedBox(
                              height: 27,
                              width: double.infinity,
                              child: quantity > 0 &&
                                  canAddToCart
                                  ? _QuantityControl(
                                quantity: quantity,
                                onDecrease:
                                _decreaseQuantity,
                                onIncrease:
                                _increaseQuantity,
                              )
                                  : ElevatedButton(
                                onPressed:
                                canAddToCart
                                    ? () {
                                  _addItem(
                                    context,
                                  );
                                }
                                    : null,
                                style: ElevatedButton
                                    .styleFrom(
                                  padding:
                                  EdgeInsets.zero,
                                  elevation: 0,
                                  minimumSize:
                                  Size.zero,
                                  tapTargetSize:
                                  MaterialTapTargetSize
                                      .shrinkWrap,
                                  backgroundColor:
                                  canAddToCart
                                      ? theme
                                      .colorScheme
                                      .primary
                                      : const Color(
                                    0xFFE0E0E0,
                                  ),
                                  disabledBackgroundColor:
                                  const Color(
                                      0xFFE0E0E0),
                                  shape:
                                  RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius
                                        .circular(
                                      8,
                                    ),
                                  ),
                                ),
                                child: Text(
                                  restaurantClosed
                                      ? 'Restaurant Closed'
                                      : foodAvailable
                                      ? 'Add to cart'
                                      : 'Currently unavailable',
                                  style: TextStyle(
                                    fontSize: 9,
                                    fontWeight:
                                    FontWeight.w800,
                                    color: canAddToCart
                                        ? Colors.white
                                        : const Color(
                                      0xFF757575,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

// ============================================================================
// QUANTITY CONTROL
// ============================================================================

class _QuantityControl extends StatelessWidget {
  final int quantity;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityControl({
    required this.quantity,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final Color primary =
        Theme.of(context).colorScheme.primary;

    return Container(
      height: 27,
      width: double.infinity,
      decoration: BoxDecoration(
        color: primary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onDecrease,
                borderRadius:
                const BorderRadius.horizontal(
                  left: Radius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.remove_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            height: 16,
            color: Colors.white.withOpacity(0.35),
          ),

          Expanded(
            child: Center(
              child: Text(
                '$quantity',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
          ),

          Container(
            width: 1,
            height: 16,
            color: Colors.white.withOpacity(0.35),
          ),

          Expanded(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onIncrease,
                borderRadius:
                const BorderRadius.horizontal(
                  right: Radius.circular(8),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_rounded,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

