import 'package:flutter/material.dart';
import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_food_card.dart';
import '../widgets/milestone_app_6_image.dart';

class MilestoneApp6RestaurantInfoScreen extends StatefulWidget {
  final MilestoneApp6Restaurant restaurant;
  final MilestoneApp6State state;

  const MilestoneApp6RestaurantInfoScreen({
    super.key,
    required this.restaurant,
    required this.state,
  });

  @override
  State<MilestoneApp6RestaurantInfoScreen> createState() =>
      _MilestoneApp6RestaurantInfoScreenState();
}

class _MilestoneApp6RestaurantInfoScreenState
    extends State<MilestoneApp6RestaurantInfoScreen> {
  bool _isFavorite = false;

  void _toggleFavorite() {
    setState(() {
      _isFavorite = !_isFavorite;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 700;

    // Get only foods belonging to this restaurant.
    final restaurantFoods = milestoneApp6Foods
        .where(
          (food) => food.restaurant == widget.restaurant.name,
    )
        .toList();

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          // ============================================================
          // RESTAURANT HEADER
          // ============================================================

          SliverAppBar(
            expandedHeight: isTablet ? 270 : 230,
            pinned: true,
            backgroundColor: theme.scaffoldBackgroundColor,
            surfaceTintColor: Colors.transparent,

            leading: Padding(
              padding: const EdgeInsets.all(8),
              child: CircleAvatar(
                backgroundColor: theme.colorScheme.surface,
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_back_rounded,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),

            actions: [
              Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                  top: 8,
                  bottom: 8,
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: _toggleFavorite,
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 200,
                      ),
                      width: 42,
                      height: 42,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surface,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(.10),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Icon(
                        _isFavorite
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        color: _isFavorite
                            ? Colors.red
                            : theme.iconTheme.color,
                        size: 22,
                      ),
                    ),
                  ),
                ),
              ),
            ],

            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  MilestoneApp6Image(
                    url: widget.restaurant.image,
                    fit: BoxFit.cover,
                    borderRadius: BorderRadius.zero,
                  ),

                  // Dark gradient over image
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(.05),
                          Colors.black.withOpacity(.70),
                        ],
                      ),
                    ),
                  ),

                  // Restaurant information
                  Positioned(
                    left: 20,
                    right: 20,
                    bottom: 20,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.restaurant.name,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                          ),
                        ),

                        const SizedBox(height: 6),

                        Text(
                          widget.restaurant.cuisine,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withOpacity(.90),
                            fontSize: 13,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green,
                                borderRadius:
                                BorderRadius.circular(7),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    widget.restaurant.rating,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                  const SizedBox(width: 3),
                                  const Icon(
                                    Icons.star,
                                    size: 12,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              widget.restaurant.time,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(width: 10),

                            Text(
                              widget.restaurant.price,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // RESTAURANT INFO
          // ============================================================

          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                4,
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.restaurant_rounded,
                    size: 20,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${restaurantFoods.length} Food Items',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ============================================================
          // FOOD GRID
          // ============================================================

          if (restaurantFoods.isEmpty)
            const SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(40),
                child: Center(
                  child: Text(
                    'No food items available.',
                  ),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                16,
                12,
                16,
                30,
              ),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                      (context, index) {
                    final food = restaurantFoods[index];

                    return MilestoneApp6FoodCard(
                      food: food,
                      state: widget.state,
                      onTap: () {
                        // Navigate to your existing food details screen.
                        // Use your existing route here.
                      },
                    );
                  },
                  childCount: restaurantFoods.length,
                ),

                gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: isTablet ? 4 : 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  mainAxisExtent: isTablet ? 300 : 245,
                ),
              ),
            ),
        ],
      ),
    );
  }
}