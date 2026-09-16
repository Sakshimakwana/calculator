import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_restaurant_list_card.dart';

class MilestoneApp6RestaurantsScreen extends StatefulWidget {
  final MilestoneApp6State state;

  const MilestoneApp6RestaurantsScreen({
    super.key,
    required this.state,
  });

  @override
  State<MilestoneApp6RestaurantsScreen> createState() =>
      _MilestoneApp6RestaurantsScreenState();
}

class _MilestoneApp6RestaurantsScreenState
    extends State<MilestoneApp6RestaurantsScreen> {
  final Set<String> _favoriteRestaurants = <String>{};

  bool _isFavorite(String restaurantName) {
    return _favoriteRestaurants.contains(restaurantName);
  }

  void _toggleFavorite(String restaurantName) {
    setState(() {
      if (_favoriteRestaurants.contains(restaurantName)) {
        _favoriteRestaurants.remove(restaurantName);
      } else {
        _favoriteRestaurants.add(restaurantName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isTablet = width >= 700;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Popular Restaurants',
          style: TextStyle(
            fontWeight: FontWeight.w700,
          ),
        ),
      ),

      body: GridView.builder(
        padding: EdgeInsets.fromLTRB(
          isTablet ? 24 : 16,
          16,
          isTablet ? 24 : 16,
          24,
        ),

        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: isTablet ? 3 : 1,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          mainAxisExtent: isTablet ? 135 : 115,
        ),

        itemCount: restaurants.length,

        itemBuilder: (context, index) {
          final restaurant = restaurants[index];
          final isFavorite = _isFavorite(restaurant.name);

          return Stack(
            children: [
              // ==========================================================
              // RESTAURANT CARD
              // ==========================================================

              Positioned.fill(
                child: MilestoneApp6RestaurantListCard(
                  restaurant: restaurant,
                  onTap: () {
                    context.push(
                      '/restaurant-info',
                      extra: {
                        'restaurant': restaurant,
                      },
                    );
                  },
                ),
              ),

              Positioned(
                top: 8,
                right: 8,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      _toggleFavorite(restaurant.name);
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: AnimatedContainer(
                      duration: const Duration(
                        milliseconds: 180,
                      ),
                      curve: Curves.easeOut,
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFF303030)
                            : Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.brightness == Brightness.dark
                              ? Colors.white.withOpacity(0.08)
                              : const Color(0xFFE5E5E5),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: AnimatedSwitcher(
                        duration: const Duration(
                          milliseconds: 180,
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
                        child: Icon(
                          isFavorite
                              ? Icons.favorite_rounded
                              : Icons.favorite_border_rounded,
                          key: ValueKey(isFavorite),
                          size: 19,
                          color: isFavorite
                              ? Colors.red
                              : theme.iconTheme.color
                              ?.withOpacity(0.65),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // ==========================================================
              // ARROW - BOTTOM RIGHT
              // ==========================================================

              // ==========================================================
// ARROW - BOTTOM RIGHT
// ==========================================================

              Positioned(
                right: 10,
                bottom: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      context.push(
                        '/restaurant-info',
                        extra: {
                          'restaurant': restaurant,
                        },
                      );
                    },
                    borderRadius: BorderRadius.circular(30),
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: theme.brightness == Brightness.dark
                            ? const Color(0xFF303030)
                            : const Color(0xFFF5F5F5),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.chevron_right_rounded,
                        size: 21,
                        color: theme.iconTheme.color?.withOpacity(0.65),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}