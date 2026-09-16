import 'package:flutter/material.dart';
import '../data/milestone_app_6_food.dart';
import '../state/milestone_app_6_state.dart';
import 'milestone_app_6_image.dart';

class MilestoneApp6FoodCard extends StatelessWidget {
  final MilestoneApp6Food food;
  final MilestoneApp6State state;
  final VoidCallback onTap;

  const MilestoneApp6FoodCard({
    super.key,
    required this.food,
    required this.state,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final isSaved =
    state.saved.contains(food.id);

    return Hero(
      tag: 'food-${food.id}',
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius:
          BorderRadius.circular(18),
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
              color: theme.cardColor,
              borderRadius:
              BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  color:
                  Colors.black.withOpacity(0.06),
                  blurRadius: 10,
                  offset:
                  const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior:
            Clip.antiAlias,
            child: Column(
              children: [
                // =====================================================
                // FOOD IMAGE
                // =====================================================

                SizedBox(
                  height: 120,
                  width: double.infinity,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      MilestoneApp6Image(
                        url: food.image,
                        fit: BoxFit.cover,
                        borderRadius:
                        const BorderRadius.vertical(
                          top: Radius.circular(18),
                        ),
                      ),

                      // =================================================
                      // FAVORITE
                      // =================================================

                      Positioned(
                        top: 7,
                        right: 7,
                        child: Material(
                          color: theme.cardColor
                              .withOpacity(0.92),
                          shape:
                          const CircleBorder(),
                          child: InkWell(
                            customBorder:
                            const CircleBorder(),
                            onTap: () {
                              state.toggleSaved(
                                food.id,
                              );
                            },
                            child: Padding(
                              padding:
                              const EdgeInsets.all(7),
                              child:
                              AnimatedSwitcher(
                                duration:
                                const Duration(
                                  milliseconds: 200,
                                ),
                                transitionBuilder:
                                    (
                                    child,
                                    animation,
                                    ) {
                                  return ScaleTransition(
                                    scale: animation,
                                    child: child,
                                  );
                                },
                                child: Icon(
                                  isSaved
                                      ? Icons
                                      .favorite_rounded
                                      : Icons
                                      .favorite_border_rounded,
                                  key: ValueKey(
                                    isSaved,
                                  ),
                                  size: 18,
                                  color: isSaved
                                      ? Colors.red
                                      : theme
                                      .iconTheme
                                      .color,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // =====================================================
                // FOOD DETAILS
                // =====================================================

                Expanded(
                  child: Padding(
                    padding:
                    const EdgeInsets.fromLTRB(
                      10,
                      7,
                      10,
                      8,
                    ),
                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        Text(
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
                            FontWeight.w700,
                          ),
                        ),

                        const SizedBox(
                          height: 2,
                        ),

                        Text(
                          food.category,
                          maxLines: 1,
                          overflow:
                          TextOverflow.ellipsis,
                          style: theme
                              .textTheme
                              .bodySmall
                              ?.copyWith(
                            fontSize: 10,
                            color: theme
                                .textTheme
                                .bodySmall
                                ?.color
                                ?.withOpacity(
                              0.6,
                            ),
                          ),
                        ),

                        const Spacer(),

                        // =================================================
                        // RATING + PRICE
                        // =================================================

                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              color: Colors.amber,
                              size: 15,
                            ),

                            const SizedBox(
                              width: 3,
                            ),

                            Text(
                              food.rating
                                  .toString(),
                              style: theme
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w600,
                              ),
                            ),

                            const Spacer(),

                            Text(
                              '\$${food.price.toStringAsFixed(2)}',
                              style: theme
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(
                                fontSize: 13,
                                fontWeight:
                                FontWeight.w800,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(
                          height: 6,
                        ),

                        // =================================================
                        // ADD TO CART
                        // =================================================

                        SizedBox(
                          height: 30,
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              // Add this particular food to cart.
                              state.addToCart(food);

                              // Show success message.
                              ScaffoldMessenger.of(context)
                                ..hideCurrentSnackBar()
                                ..showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: [
                                        const Icon(
                                          Icons.check_circle_rounded,
                                          color: Colors.white,
                                          size: 21,
                                        ),

                                        const SizedBox(width: 10),

                                        Expanded(
                                          child: Text(
                                            '${food.name} added to cart successfully!',
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    behavior: SnackBarBehavior.floating,
                                    duration: const Duration(seconds: 2),
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
                            },
                            style:
                            ElevatedButton.styleFrom(
                              padding:
                              EdgeInsets.zero,
                              elevation: 0,
                              minimumSize:
                              Size.zero,
                              tapTargetSize:
                              MaterialTapTargetSize
                                  .shrinkWrap,
                              shape:
                              RoundedRectangleBorder(
                                borderRadius:
                                BorderRadius.circular(
                                  9,
                                ),
                              ),
                            ),
                            child:
                            const Text(
                              'Add to cart',
                              style:
                              TextStyle(
                                fontSize: 10,
                                fontWeight:
                                FontWeight.w700,
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