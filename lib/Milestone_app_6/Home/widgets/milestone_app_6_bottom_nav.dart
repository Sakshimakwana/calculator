import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/milestone_app_6_state.dart';
import '../../cart/data/cart_controller/cart_controller.dart';

class MilestoneApp6BottomNav extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6BottomNav({
    super.key,
    required this.state,
  });

  int _index(BuildContext context) {
    final location =
        GoRouterState.of(context).uri.path;

    if (location.startsWith('/cart')) {
      return 1;
    }

    if (location.startsWith('/profile')) {
      return 2;
    }

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final index = _index(context);

    return Consumer<CartController>(
      builder: (context, cartController, _) {
        // Number of different products currently in the cart.
        final int cartCount =
            cartController.cartItems.length;

        return NavigationBar(
          selectedIndex: index,

          onDestinationSelected: (value) {
            const paths = [
              '/home',
              '/cart',
              '/profile',
            ];

            context.go(paths[value]);
          },

          destinations: [
            const NavigationDestination(
              icon: Icon(Icons.home_outlined),
              selectedIcon: Icon(Icons.home),
              label: 'Home',
            ),

            NavigationDestination(
              icon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(
                  Icons.shopping_cart_outlined,
                ),
              ),
              selectedIcon: Badge(
                isLabelVisible: cartCount > 0,
                label: Text('$cartCount'),
                child: const Icon(
                  Icons.shopping_cart,
                ),
              ),
              label: 'Cart',
            ),

            const NavigationDestination(
              icon: Icon(Icons.person_outline),
              selectedIcon: Icon(Icons.person),
              label: 'Profile',
            ),
          ],
        );
      },
    );
  }
}
