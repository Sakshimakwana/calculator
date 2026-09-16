import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/milestone_app_6_state.dart';

class MilestoneApp6BottomNav
    extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6BottomNav({
    super.key,
    required this.state,
  });

  int _index(BuildContext context) {
    final location =
        GoRouterState.of(context)
            .uri
            .path;

    if (location.startsWith('/categories')) {
      return 1;
    }

    if (location.startsWith('/cart')) {
      return 2;
    }

    if (location.startsWith('/profile')) {
      return 3;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return NavigationBar(
      selectedIndex: index,

      onDestinationSelected: (value) {
        const paths = [
          '/home',
          '/categories',
          '/cart',
          '/profile',
        ];

        context.go(paths[value]);
      },

      destinations: [
        const NavigationDestination(
          icon:
          Icon(Icons.home_outlined),
          selectedIcon:
          Icon(Icons.home),
          label: 'Home',
        ),

        const NavigationDestination(
          icon:
          Icon(Icons.grid_view_outlined),
          selectedIcon:
          Icon(Icons.grid_view),
          label: 'Catagory',
        ),

        NavigationDestination(
          icon: Badge(
            isLabelVisible:
            state.cartCount > 0,

            label:
            Text('${state.cartCount}'),

            child: const Icon(
              Icons.shopping_cart_outlined,
            ),
          ),

          selectedIcon: Badge(
            isLabelVisible:
            state.cartCount > 0,

            label:
            Text('${state.cartCount}'),

            child: const Icon(
              Icons.shopping_cart,
            ),
          ),

          label: 'Cart',
        ),

        const NavigationDestination(
          icon:
          Icon(Icons.person_outline),
          selectedIcon:
          Icon(Icons.person),
          label: 'Profile',
        ),
      ],
    );
  }
}