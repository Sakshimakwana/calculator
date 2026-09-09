import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/shoppingflow_T20_colors.dart';

class ShoppingFlowT20BottomNavigation
    extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ShoppingFlowT20BottomNavigation({
    super.key,
    required this.navigationShell,
  });

  void _changeTab(int index) {
    navigationShell.goBranch(
      index,
      initialLocation:
      index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex:
      navigationShell.currentIndex,
      onDestinationSelected: _changeTab,
      indicatorColor:
      ShoppingFlowT20Colors.primaryLight,
      height: 65,
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
          icon:
          Icon(Icons.shopping_bag_outlined),
          selectedIcon:
          Icon(Icons.shopping_bag),
          label: 'Cart',
        ),
        NavigationDestination(
          icon: Icon(Icons.favorite_border),
          selectedIcon: Icon(Icons.favorite),
          label: 'Favourites',
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