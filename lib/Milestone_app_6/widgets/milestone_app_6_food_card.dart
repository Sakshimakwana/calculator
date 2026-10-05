
import 'package:app_matic_tech_flutter_app/models/cart/cart_response_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import 'milestone_app_6_image.dart';
import 'package:provider/provider.dart';
import '../../controllers/cart_controller.dart';

class MilestoneApp6FoodCard extends StatelessWidget {
  final MilestoneApp6Food food;
  final MilestoneApp6State state;
  final bool restaurantIsOpen;
  final String restaurantId;

  const MilestoneApp6FoodCard({
    super.key,
    required this.food,
    required this.state,
    required this.restaurantId,
    this.restaurantIsOpen = true,
  });

  // ==============================================================
  // API CART ITEM
  // ==============================================================

  CartItemModel? _apiCartItem(BuildContext context) {
    final controller = context.read<CartController>();

    for (final item in controller.cartItems) {
      if (item.menuItem.id.toString() == food.id) {
        return item;
      }
    }

    return null;
  }

  int _apiQuantity(BuildContext context) {
    return _apiCartItem(context)?.quantity ?? 0;
  }

  // ==============================================================
  // ADD FIRST ITEM TO API CART
  // ==============================================================

  Future<void> _addItem(BuildContext context) async {
    // --------------------------------------------------------------
    // Convert Restaurant ID String -> int
    // --------------------------------------------------------------

    final int? parsedRestaurantId = int.tryParse(restaurantId);

    if (parsedRestaurantId == null) {
      debugPrint(
        'Invalid restaurant ID: $restaurantId',
      );
      return;
    }

    // --------------------------------------------------------------
    // Convert Food/Menu Item ID String -> int
    // --------------------------------------------------------------

    final int? parsedMenuItemId = int.tryParse(food.id);

    if (parsedMenuItemId == null) {
      debugPrint(
        'Invalid menu item ID: ${food.id}',
      );
      return;
    }

    debugPrint('');
    debugPrint('========================================');
    debugPrint('       FOOD CARD ADD TO CART');
    debugPrint('========================================');
    debugPrint('Food ID: ${food.id}');
    debugPrint('Parsed Menu Item ID: $parsedMenuItemId');
    debugPrint('Restaurant ID: $parsedRestaurantId');
    debugPrint('Food Name: ${food.name}');
    debugPrint('Quantity: 1');
    debugPrint('========================================');
    debugPrint('');

    // --------------------------------------------------------------
    // CALL CART API
    // --------------------------------------------------------------

    final bool added =
    await context.read<CartController>().addToCart(
      menuItemId: parsedMenuItemId,
      quantity: 1,
      restaurantId: parsedRestaurantId,
    );

    if (!context.mounted || !added) {
      return;
    }

    // --------------------------------------------------------------
    // SUCCESS MESSAGE
    // --------------------------------------------------------------

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
          duration: const Duration(
            milliseconds: 1200,
          ),
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

  Future<void> _increaseQuantity(BuildContext context) async {
    final cartItem = _apiCartItem(context);

    // If the item is not in the API cart yet, add it first.
    if (cartItem == null) {
      await _addItem(context);
      return;
    }

    await context.read<CartController>().updateCartQuantity(
      cartId: cartItem.id,
      quantity: cartItem.quantity + 1,
    );
  }

  // ==============================================================
  // DECREASE
  // ==============================================================

  Future<void> _decreaseQuantity(BuildContext context) async {
    final cartItem = _apiCartItem(context);

    if (cartItem == null) {
      return;
    }

    // DELETE API was not provided here.
    // Therefore quantity is kept at 1 instead of sending 0.
    if (cartItem.quantity <= 1) {
      return;
    }

    await context.read<CartController>().updateCartQuantity(
      cartId: cartItem.id,
      quantity: cartItem.quantity - 1,
    );
  }

  // ==============================================================
  // BUILD
  // ==============================================================

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

    return Consumer<CartController>(
      builder: (context, cartController, _) {
        final int quantity = _apiQuantity(context);

        return Hero(
          tag: 'food-${food.id}',
          child: Material(
            color: Colors.transparent,
            child: Container(
              width: double.infinity,
              height: 560,
              decoration: BoxDecoration(
                color: restaurantClosed
                    ? const Color(0xFFF1F1F1)
                    : theme.cardColor,
                borderRadius: BorderRadius.circular(10),
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
                  // IMAGE
                  // ==================================================

                  SizedBox(
                    height: 129,
                    width: double.infinity,
                    child: MilestoneApp6Image(
                      url: food.image,
                      fit: BoxFit.cover,
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(16),
                      ),
                    ),
                  ),

                  // ==================================================
                  // CONTENT
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
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // ==========================================
                          // FOOD NAME
                          // ==========================================

                          Text(
                            food.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall
                                ?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: restaurantClosed
                                  ? theme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.45)
                                  : theme
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),

                          const SizedBox(height: 4),

                          // ==========================================
                          // AVAILABILITY
                          // ==========================================

                          Container(
                            height: 21,
                            padding:
                            const EdgeInsets.symmetric(
                              horizontal: 6,
                            ),
                            decoration: BoxDecoration(
                              color:
                              availabilityColor.withOpacity(
                                theme.brightness ==
                                    Brightness.dark
                                    ? 0.14
                                    : 0.10,
                              ),
                              borderRadius:
                              BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize:
                              MainAxisSize.min,
                              children: [
                                Icon(
                                  availabilityIcon,
                                  size: 10,
                                  color:
                                  availabilityColor,
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  availabilityText,
                                  style: TextStyle(
                                    fontSize: 8,
                                    fontWeight:
                                    FontWeight.w800,
                                    color:
                                    availabilityColor,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 4),

                          // ==========================================
                          // PRICE
                          // ==========================================

                          Text(
                            '\$${food.price.toStringAsFixed(2)}',
                            style: theme.textTheme.titleSmall
                                ?.copyWith(
                              fontSize: 14,
                              fontWeight: FontWeight.w900,
                              color: restaurantClosed
                                  ? theme
                                  .colorScheme
                                  .onSurface
                                  .withOpacity(0.45)
                                  : theme
                                  .colorScheme
                                  .onSurface,
                            ),
                          ),

                          const SizedBox(height: 5),

                          // ==========================================
                          // ADD TO CART / QUANTITY
                          // ==========================================

                          SizedBox(
                            height: 27,
                            width: double.infinity,
                            child: quantity > 0 &&
                                canAddToCart
                                ? _QuantityControl(
                              quantity: quantity,
                              onDecrease: () => _decreaseQuantity(context),
                              onIncrease: () => _increaseQuantity(context),
                            )
                                : ElevatedButton(
                              onPressed:
                              canAddToCart
                                  ? () {
                                HapticFeedback
                                    .lightImpact();

                                _addItem(
                                  context,
                                );
                              }
                                  : null,
                              style:
                              ElevatedButton
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
                                  0xFFE0E0E0,
                                ),
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
                                maxLines: 1,
                                overflow:
                                TextOverflow.ellipsis,
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
        );
      },
    );
  }
}

// ============================================================================
// QUANTITY CONTROL
// ============================================================================

class _QuantityControl
    extends StatelessWidget {
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
          // ==========================================================
          // DECREASE
          // ==========================================================

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

          // ==========================================================
          // DIVIDER
          // ==========================================================

          Container(
            width: 1,
            height: 16,
            color: Colors.white.withOpacity(0.35),
          ),

          // ==========================================================
          // QUANTITY
          // ==========================================================

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

          // ==========================================================
          // DIVIDER
          // ==========================================================

          Container(
            width: 1,
            height: 16,
            color: Colors.white.withOpacity(0.35),
          ),

          // ==========================================================
          // INCREASE
          // ==========================================================

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
