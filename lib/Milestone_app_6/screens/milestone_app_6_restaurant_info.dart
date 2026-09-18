import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_food_card.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantInfoScreen extends StatelessWidget {
  final MilestoneApp6Restaurant restaurant;
  final MilestoneApp6State state;

  const MilestoneApp6RestaurantInfoScreen({
    super.key,
    required this.restaurant,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final width = MediaQuery.sizeOf(context).width;

    final isTablet = width >= 700;

    // ================================================================
    // RESTAURANT FOOD
    // ================================================================

    final restaurantFoods = milestoneApp6Foods
        .where(
          (food) => food.restaurant == restaurant.name,
    )
        .toList();

    // ================================================================
    // RESTAURANT STATUS
    // ================================================================

    final bool restaurantIsOpen = restaurant.isOpen;

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ==========================================================
          // RESTAURANT HEADER
          // ==========================================================

          SliverAppBar(
            expandedHeight: isTablet ? 300 : 270,
            pinned: true,

            backgroundColor:
            theme.scaffoldBackgroundColor,

            surfaceTintColor: Colors.transparent,

            // ========================================================
            // BACK BUTTON
            // ========================================================

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor:
                theme.colorScheme.surface,

                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                  onPressed: () {
                    context.pop();
                  },
                ),
              ),
            ),

            // ========================================================
            // NO FAVORITE BUTTON
            // ========================================================
            //
            // Restaurant favorite logic has been completely removed.
            //
            // ========================================================

            // ========================================================
            // HEADER IMAGE
            // ========================================================

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // ==================================================
                  // RESTAURANT IMAGE
                  // ==================================================

                  MilestoneApp6Image(
                    url: restaurant.image,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),

                  // ==================================================
                  // DARK GRADIENT
                  // ==================================================

                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(.10),
                            Colors.black.withOpacity(.80),
                          ],
                          stops: const [
                            .25,
                            .55,
                            1.0,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // ==================================================
                  // RESTAURANT INFORMATION
                  // ==================================================

                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 22,

                    child: Column(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,

                      children: [
                        // ============================================
                        // RESTAURANT NAME
                        // ============================================

                        Text(
                          restaurant.name,

                          maxLines: 2,

                          overflow:
                          TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight:
                            FontWeight.w800,
                            height: 1.1,

                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 5,
                                offset:
                                Offset(0, 2),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 7),

                        // ============================================
                        // OPEN / CLOSED + DISTANCE
                        // ============================================

                        Row(
                          children: [
                            Text(
                              restaurant.isOpen
                                  ? 'Open'
                                  : 'Closed',

                              style: TextStyle(
                                color:
                                restaurant.isOpen
                                    ? Colors.greenAccent
                                    : Colors.redAccent,

                                fontSize: 15,

                                fontWeight:
                                FontWeight.w700,

                                shadows: const [
                                  Shadow(
                                    color:
                                    Colors.black54,
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 7),

                            const Text(
                              '•',

                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight:
                                FontWeight.w700,
                              ),
                            ),

                            const SizedBox(width: 7),

                            if (restaurant
                                .distance
                                .isNotEmpty)
                              Text(
                                restaurant.distance,

                                style:
                                const TextStyle(
                                  color:
                                  Colors.white,
                                  fontSize: 14,
                                  fontWeight:
                                  FontWeight.w600,

                                  shadows: [
                                    Shadow(
                                      color:
                                      Colors.black54,
                                      blurRadius: 4,
                                    ),
                                  ],
                                ),
                              ),
                          ],
                        ),

                        const SizedBox(height: 7),

                        // ============================================
                        // CUISINE
                        // ============================================

                        Text(
                          restaurant.cuisine,

                          maxLines: 2,

                          overflow:
                          TextOverflow.ellipsis,

                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight:
                            FontWeight.w500,

                            shadows: [
                              Shadow(
                                color: Colors.black54,
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),

                        // ============================================
                        // ADDRESS
                        // ============================================

                        if (restaurant
                            .address
                            .isNotEmpty) ...[
                          const SizedBox(height: 5),

                          Row(
                            children: [
                              const Icon(
                                Icons
                                    .location_on_rounded,
                                color: Colors.white,
                                size: 15,
                              ),

                              const SizedBox(width: 4),

                              Expanded(
                                child: Text(
                                  restaurant.address,

                                  maxLines: 1,

                                  overflow:
                                  TextOverflow
                                      .ellipsis,

                                  style:
                                  const TextStyle(
                                    color:
                                    Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.w500,

                                    shadows: [
                                      Shadow(
                                        color:
                                        Colors.black54,
                                        blurRadius: 4,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // RESTAURANT MENU SECTION
          // ==========================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                8,
              ),

              child: Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,

                children: [
                  // ==================================================
                  // RESTAURANT MENU TITLE
                  // ==================================================

                  Row(
                    children: [
                      Icon(
                        Icons.restaurant_rounded,
                        size: 21,
                        color:
                        theme.colorScheme.primary,
                      ),

                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'Restaurant Menu',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.w800,
                            color: theme
                                .colorScheme
                                .onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 5),

                  // ==================================================
                  // FOOD COUNT
                  // ==================================================

                  Text(
                    '${restaurantFoods.length} Food Items',

                    style: TextStyle(
                      color: theme.hintColor,
                      fontSize: 13,
                      fontWeight:
                      FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ==========================================================
          // NO FOOD
          // ==========================================================

          if (restaurantFoods.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),

                child: Center(
                  child: Column(
                    mainAxisSize:
                    MainAxisSize.min,

                    children: [
                      Icon(
                        Icons.restaurant_outlined,
                        size: 55,
                        color: Colors.grey,
                      ),

                      SizedBox(height: 12),

                      Text(
                        'No food items available.',

                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                          FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )

          // ==========================================================
          // FOOD GRID
          // ==========================================================

          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                30,
              ),

              sliver: SliverGrid(
                delegate:
                SliverChildBuilderDelegate(
                      (context, index) {
                    final food =
                    restaurantFoods[index];

                    return AnimatedBuilder(
                      animation: state,

                      builder: (
                          context,
                          child,
                          ) {
                        return MilestoneApp6FoodCard(
                          food: food,

                          state: state,

                          // ==================================================
                          // RESTAURANT STATUS
                          // ==================================================
                          //
                          // CLOSED:
                          // Food availability does NOT matter.
                          // It will show "Restaurant Closed".
                          //
                          // OPEN:
                          // Food availability controls the badge.
                          //
                          restaurantIsOpen:
                          restaurantIsOpen,

                          // ==================================================
                          // FOOD NAVIGATION
                          // ==================================================

                          onTap: restaurantIsOpen
                              ? () {
                            context.push(
                              '/food/${food.id}',
                            );
                          }
                              : null,
                        );
                      },
                    );
                  },

                  childCount:
                  restaurantFoods.length,
                ),

                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                  isTablet ? 4 : 2,

                  crossAxisSpacing: 12,

                  mainAxisSpacing: 14,

                  mainAxisExtent:
                  isTablet ? 300 : 245,
                ),
              ),
            ),
        ],
      ),
    );
  }
}