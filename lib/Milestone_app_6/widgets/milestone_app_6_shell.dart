import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../state/milestone_app_6_state.dart';
import '../theme/milestone_app_6_colors.dart';
import 'milestone_app_6_bottom_nav.dart';

class MilestoneApp6Shell
    extends StatelessWidget {
  final MilestoneApp6State state;
  final Widget child;

  const MilestoneApp6Shell({
    super.key,
    required this.state,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final tablet =
        MediaQuery.sizeOf(context).width >= 700;

    return Scaffold(
      body: Row(
        children: [
          if (tablet)
            _sideBar(context),

          Expanded(
            child: child,
          ),
        ],
      ),

      bottomNavigationBar: tablet
          ? null
          : MilestoneApp6BottomNav(
        state: state,
      ),
    );
  }

  Widget _sideBar(
      BuildContext context,
      ) {
    final location =
        GoRouterState.of(context)
            .uri
            .path;

    return NavigationRail(
      selectedIndex:
      _selectedIndex(location),

      onDestinationSelected: (value) {
        const paths = [
          '/home',
          '/categories',
          '/cart',
          '/profile',
        ];

        context.go(paths[value]);
      },

      labelType:
      NavigationRailLabelType.all,

      backgroundColor:
      MilestoneApp6Colors.orangeDark,

      selectedIconTheme:
      const IconThemeData(
        color: Colors.white,
      ),

      unselectedIconTheme:
      const IconThemeData(
        color: Colors.white70,
      ),

      selectedLabelTextStyle:
      const TextStyle(
        color: Colors.white,
        fontSize: 11,
      ),

      unselectedLabelTextStyle:
      const TextStyle(
        color: Colors.white70,
        fontSize: 11,
      ),

      leading: const Padding(
        padding:
        EdgeInsets.only(
          top: 18,
          bottom: 24,
        ),

        child: Icon(
          Icons.restaurant_menu,
          color: Colors.white,
          size: 30,
        ),
      ),

      destinations: const [
        NavigationRailDestination(
          icon:
          Icon(Icons.home_outlined),
          selectedIcon:
          Icon(Icons.home),
          label:
          Text('Home'),
        ),

        NavigationRailDestination(
          icon:
          Icon(Icons.grid_view_outlined),
          selectedIcon:
          Icon(Icons.grid_view),
          label:
          Text('Categories'),
        ),

        NavigationRailDestination(
          icon:
          Icon(Icons.shopping_cart_outlined),
          selectedIcon:
          Icon(Icons.shopping_cart),
          label:
          Text('Cart'),
        ),

        NavigationRailDestination(
          icon:
          Icon(Icons.person_outline),
          selectedIcon:
          Icon(Icons.person),
          label:
          Text('Profile'),
        ),
      ],
    );
  }

  int _selectedIndex(
      String location,
      ) {
    if (location.startsWith(
      '/categories',
    )) {
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
}