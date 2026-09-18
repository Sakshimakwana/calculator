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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bool isSaved = state.saved.contains(food.id);

    // Restaurant status
    final bool restaurantClosed = !restaurantIsOpen;

    // Food availability
    final bool foodAvailable = food.isAvailable;

    // Final order availability
    final bool canAddToCart = restaurantIsOpen && foodAvailable;

    // Availability text
    final String availabilityText = restaurantClosed
        ? 'Restaurant Closed'
        : foodAvailable
        ? 'Available'
        : 'Not Available';

    return Hero(
      tag: 'food-${food.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          // Closed restaurant => disable card navigation.
          // Open restaurant => use custom onTap if provided,
          // otherwise open food detail.
          onTap: restaurantClosed
              ? null
              : onTap ??
                  () {
                context.push('/food/${food.id}');
              },
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: double.infinity,
            height: 245,
            decoration: BoxDecoration(
              color: restaurantClosed
                  ? const Color(0xFFF1F1F1)
                  : theme.cardColor,
              borderRadius: BorderRadius.circular(16),
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
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ============================================================
                // FOOD IMAGE
                // ============================================================

                SizedBox(
                  height: 115,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      // ======================================================
                      // IMAGE
                      // ======================================================

                      restaurantClosed
                          ? ColorFiltered(
                        colorFilter: const ColorFilter.matrix(
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
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(16),
                          ),
                        ),
                      )
                          : MilestoneApp6Image(
                        url: food.image,
                        fit: BoxFit.cover,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(16),
                        ),
                      ),

                      // ======================================================
                      // CLOSED IMAGE OVERLAY
                      // ======================================================

                      if (restaurantClosed)
                        Positioned.fill(
                          child: Container(
                            color: Colors.black.withOpacity(0.20),
                          ),
                        ),

                      // ======================================================
                      // BOTTOM GRADIENT
                      // ======================================================

                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 45,
                        child: IgnorePointer(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.55),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ======================================================
                      // FAVORITE
                      // ======================================================

                      Positioned(
                        top: 7,
                        right: 7,
                        child: Material(
                          color: Colors.white.withOpacity(0.94),
                          shape: const CircleBorder(),
                          elevation: 1,
                          child: InkWell(
                            customBorder: const CircleBorder(),
                            onTap: () {
                              state.toggleSaved(food.id);
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(6),
                              child: AnimatedSwitcher(
                                duration: const Duration(
                                  milliseconds: 180,
                                ),
                                transitionBuilder: (
                                    Widget child,
                                    Animation<double> animation,
                                    ) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  isSaved
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  key: ValueKey<bool>(isSaved),
                                  size: 17,
                                  color: isSaved
                                      ? Colors.red
                                      : Colors.black87,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      // ======================================================
                      // AVAILABILITY
                      // ======================================================

                      Positioned(
                        left: 7,
                        bottom: 7,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: restaurantClosed
                                ? const Color(0xFF757575)
                                : foodAvailable
                                ? const Color(0xFF00A651)
                                : const Color(0xFFE53935),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                restaurantClosed
                                    ? Icons.store_rounded
                                    : foodAvailable
                                    ? Icons.check_circle_rounded
                                    : Icons.cancel_rounded,
                                color: Colors.white,
                                size: 11,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                availabilityText,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // ============================================================
                // FOOD DETAILS
                // ============================================================

                SizedBox(
                  height: 130,
                  width: double.infinity,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(
                      10,
                      7,
                      10,
                      7,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ====================================================
                        // FOOD NAME
                        // ====================================================

                        SizedBox(
                          height: 16,
                          child: Text(
                            food.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: restaurantClosed
                                  ? const Color(0xFF777777)
                                  : null,
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        // ====================================================
                        // RESTAURANT
                        // ====================================================

                        SizedBox(
                          height: 15,
                          child: GestureDetector(
                            onTap: restaurantClosed
                                ? null
                                : () {
                              context.push(
                                '/restaurant/${Uri.encodeComponent(
                                  food.restaurant,
                                )}',
                              );
                            },
                            child: Row(
                              children: [
                                Icon(
                                  Icons.restaurant_rounded,
                                  size: 11,
                                  color: restaurantClosed
                                      ? const Color(0xFF999999)
                                      : theme.colorScheme.primary,
                                ),
                                const SizedBox(width: 3),
                                Expanded(
                                  child: Text(
                                    food.restaurant,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style:
                                    theme.textTheme.bodySmall?.copyWith(
                                      fontSize: 9,
                                      fontWeight: FontWeight.w600,
                                      color: restaurantClosed
                                          ? const Color(0xFF999999)
                                          : theme.colorScheme.primary,
                                    ),
                                  ),
                                ),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 12,
                                  color: restaurantClosed
                                      ? const Color(0xFF999999)
                                      : theme.colorScheme.primary,
                                ),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 2),

                        // ====================================================
                        // CATEGORY
                        // ====================================================

                        SizedBox(
                          height: 13,
                          child: Text(
                            food.category,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              fontSize: 9,
                              color: restaurantClosed
                                  ? const Color(0xFF999999)
                                  : theme.textTheme.bodySmall?.color
                                  ?.withOpacity(0.55),
                            ),
                          ),
                        ),

                        const SizedBox(height: 5),

                        // ====================================================
                        // RATING + PRICE
                        // ====================================================

                        SizedBox(
                          height: 20,
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: restaurantClosed
                                      ? const Color(0xFF9E9E9E)
                                      : Colors.green.shade600,
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.star_rounded,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      food.rating.toString(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 9,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '\$${food.price.toStringAsFixed(2)}',
                                style: theme.textTheme.titleSmall?.copyWith(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                  color: restaurantClosed
                                      ? const Color(0xFF888888)
                                      : null,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 5),

                        // ====================================================
                        // ADD TO CART
                        // ====================================================

                        SizedBox(
                          height: 27,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: canAddToCart
                                ? () {
                              state.addToCart(food);

                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 19,
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            '${food.name} added to cart successfully!',
                                            maxLines: 2,
                                            overflow:
                                            TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    behavior:
                                    SnackBarBehavior.floating,
                                    duration:
                                    const Duration(seconds: 2),
                                    margin:
                                    const EdgeInsets.fromLTRB(
                                      16,
                                      0,
                                      16,
                                      16,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(12),
                                    ),
                                  ),
                                );
                            }
                                : null,
                            style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              minimumSize: Size.zero,
                              tapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
                              backgroundColor: restaurantClosed
                                  ? const Color(0xFFBDBDBD)
                                  : theme.colorScheme.primary,
                              disabledBackgroundColor:
                              const Color(0xFFE0E0E0),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
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
                                fontWeight: FontWeight.w700,
                                color: restaurantClosed
                                    ? const Color(0xFF757575)
                                    : foodAvailable
                                    ? Colors.white
                                    : theme.disabledColor,
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
  }
}