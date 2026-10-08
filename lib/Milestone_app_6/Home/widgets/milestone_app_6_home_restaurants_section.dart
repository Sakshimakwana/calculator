import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_home_restaurant_card.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import 'RestaurantShimmerCard.dart';

class MilestoneApp6HomeRestaurantsSection
    extends StatelessWidget {
  final bool isLoading;
  final String? error;
  final List<MilestoneApp6Restaurant> restaurants;
  final VoidCallback onRetry;

  final bool isLoadingMore;
  final bool hasMorePages;
  final int recordsLoaded;
  final int totalRestaurants;

  final String selectedCategory;

  const MilestoneApp6HomeRestaurantsSection({
    super.key,
    required this.isLoading,
    required this.error,
    required this.restaurants,
    required this.onRetry,
    required this.isLoadingMore,
    required this.hasMorePages,
    required this.recordsLoaded,
    required this.totalRestaurants,
    required this.selectedCategory,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading && restaurants.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 8,
        ),
        child: MilestoneApp6RestaurantShimmer(
          itemCount: 6,
        ),
      );
    }

    if (error != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30,
          horizontal: 30,
        ),
        child: Column(
          children: [
            const Text(
              'Unable to load restaurants.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            TextButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (restaurants.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 35,
          horizontal: 30,
        ),
        child: Column(
          children: [
            Icon(
              Icons.restaurant_menu_rounded,
              size: 42,
              color: Theme.of(context).hintColor,
            ),
            const SizedBox(height: 10),
            Text(
              selectedCategory.isNotEmpty
                  ? 'No restaurants found for $selectedCategory.'
                  : 'No nearby restaurants found.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Theme.of(context).hintColor,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 4,
          ),
          gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 16,
            childAspectRatio: 0.68,
          ),
          itemCount: restaurants.length,
          itemBuilder: (context, index) {
            final restaurant = restaurants[index];

            return MilestoneApp6RestaurantCard(
              name: restaurant.name,
              image: restaurant.image,
              rating: restaurant.rating.toString(),
              time: '',
              isOpen: restaurant.isOpen,

              distance: restaurant.distance,
              address: restaurant.address,

              categories: restaurant.menus
                  .where(
                    (menu) => menu.menuItems.isNotEmpty,
              )
                  .map(
                    (menu) => menu.name.trim(),
              )
                  .where(
                    (name) => name.isNotEmpty,
              )
                  .toSet()
                  .take(2)
                  .join(' • '),

              onTap: () {
                context.push(
                  '/restaurant-info',
                  extra: <String, dynamic>{
                    'restaurant': restaurant,
                  },
                );
              },
            );
          },
        ),

        _buildPaginationFooter(context),
      ],
    );
  }

  // ============================================================
  // RESTAURANT CARD
  // ============================================================

  Widget _buildRestaurantCard(
      BuildContext context,
      MilestoneApp6Restaurant restaurant,
      ) {
    return MilestoneApp6RestaurantCard(
      name: restaurant.name,
      image: restaurant.image,
      rating: restaurant.rating.toString(),
      time: '',
      isOpen: restaurant.isOpen,
    );
  }

  // ============================================================
  // PAGINATION FOOTER
  // ============================================================

  Widget _buildPaginationFooter(
      BuildContext context,
      ) {
    // ----------------------------------------------------------
    // LOADING MORE
    // ----------------------------------------------------------

    if (isLoadingMore) {
      return const Padding(
        padding: EdgeInsets.fromLTRB(
          16,
          8,
          16,
          24,
        ),
        child: SizedBox(
          height: 230,
          child: MilestoneApp6RestaurantShimmer(
            itemCount: 6,
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // MORE PAGES AVAILABLE
    // ----------------------------------------------------------

    if (hasMorePages) {
      return const Padding(
        padding: EdgeInsets.symmetric(
          vertical: 20,
        ),
        child: Center(
          child: Text(
            'Scroll down to load more restaurants',
          ),
        ),
      );
    }

    // ----------------------------------------------------------
    // ALL LOADED
    // ----------------------------------------------------------

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Column(
        children: [
          const Icon(
            Icons.check_circle_rounded,
          ),
          const SizedBox(height: 8),
          const Text(
            'All restaurants loaded',
          ),
          const SizedBox(height: 4),
          Text(
            '$recordsLoaded of $totalRestaurants restaurants',
          ),
        ],
      ),
    );
  }
}