import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/modern_store_home_colors.dart';


class ModernStoreHomeBottomNav extends StatelessWidget {
  final int currentIndex;

  const ModernStoreHomeBottomNav({
    super.key,
    required this.currentIndex,
  });

  static const routes = [
    '/modern-store-home',
    '/modern-store-home/categories',
    '/modern-store-home/deals',
    '/modern-store-home/wishlist',
    '/modern-store-home/profile',
  ];

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,

      backgroundColor: Colors.white,

      indicatorColor:
      ModernStoreHomeColors.primary
          .withValues(alpha: 0.12),

      onDestinationSelected: (index) {
        context.go(routes[index]);
      },

      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined),
          selectedIcon: Icon(Icons.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Icons.grid_view_outlined),
          selectedIcon: Icon(Icons.grid_view),
          label: 'Categories',
        ),
        NavigationDestination(
          icon: Icon(Icons.sell_outlined),
          selectedIcon: Icon(Icons.sell),
          label: 'Deals',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Wishlist',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline),
          selectedIcon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}