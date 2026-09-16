import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../screens/milestone_app_6_buy_now_checkout_screen.dart';
import '../screens/milestone_app_6_categories.dart';
import '../screens/milestone_app_6_cart.dart';
import '../screens/milestone_app_6_details.dart';
import '../screens/milestone_app_6_home.dart';
import '../screens/milestone_app_6_onboarding.dart';
import '../screens/milestone_app_6_profile.dart';
import '../screens/milestone_app_6_restaurant_info.dart';
import '../screens/milestone_app_6_restaurants.dart';

import '../state/milestone_app_6_state.dart';
import '../widgets/milestone_app_6_shell.dart';

class MilestoneApp6Routes {
  final MilestoneApp6State state;

  late final GoRouter router;

  MilestoneApp6Routes(this.state) {
    router = GoRouter(
      initialLocation: state.onboardingDone
          ? '/home'
          : '/onboarding',

      refreshListenable: state,

      redirect: (context, routeState) {
        final onboarding =
            routeState.uri.path == '/onboarding';

        if (!state.onboardingDone && !onboarding) {
          return '/onboarding';
        }

        if (state.onboardingDone && onboarding) {
          return '/home';
        }

        return null;
      },

      routes: [
        // ================================================================
        // ONBOARDING
        // ================================================================

        GoRoute(
          path: '/onboarding',
          pageBuilder: (context, routeState) {
            return _page(
              routeState,
              MilestoneApp6OnboardingScreen(
                state: state,
              ),
            );
          },
        ),

        // ================================================================
        // MAIN APP + BOTTOM NAVIGATION
        // ================================================================

        ShellRoute(
          builder: (
              context,
              routeState,
              child,
              ) {
            return MilestoneApp6Shell(
              state: state,
              child: child,
            );
          },

          routes: [
            // ------------------------------------------------------------
            // HOME
            // ------------------------------------------------------------

            GoRoute(
              path: '/home',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6HomeScreen(
                    state: state,
                  ),
                );
              },
            ),

            // ------------------------------------------------------------
            // CATEGORIES
            // ------------------------------------------------------------

            GoRoute(
              path: '/categories',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6CategoriesScreen(
                    state: state,
                  ),
                );
              },
            ),

            // ------------------------------------------------------------
            // RESTAURANTS
            // ------------------------------------------------------------

            GoRoute(
              path: '/restaurants',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6RestaurantsScreen(
                    state: state,
                  ),
                );
              },
            ),

            // ------------------------------------------------------------
            // RESTAURANT INFO
            // ------------------------------------------------------------

            GoRoute(
              path: '/restaurant-info',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                final data =
                routeState.extra as Map<String, dynamic>;

                final restaurant =
                data['restaurant']
                as MilestoneApp6Restaurant;

                return _page(
                  routeState,
                  MilestoneApp6RestaurantInfoScreen(
                    restaurant: restaurant,
                    state: state,
                  ),
                );
              },
            ),

            // ------------------------------------------------------------
            // CART
            // ------------------------------------------------------------

            GoRoute(
              path: '/cart',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6CartScreen(
                    state: state,
                  ),
                );
              },
            ),

            // ------------------------------------------------------------
            // PROFILE
            // ------------------------------------------------------------

            GoRoute(
              path: '/profile',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6ProfileScreen(
                    state: state,
                  ),
                );
              },
            ),
          ],
        ),

        // ================================================================
        // FOOD DETAILS
        // Outside ShellRoute so bottom navigation is hidden
        // ================================================================

        GoRoute(
          path: '/food/:id',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              MilestoneApp6FoodDetailsScreen(
                state: state,
                id: routeState.pathParameters['id']!,
              ),
            );
          },
        ),

        // ================================================================
        // CHECKOUT
        // Outside ShellRoute so bottom navigation is hidden
        // ================================================================

        GoRoute(
          path: '/checkout',
          pageBuilder: (
              context,
              routeState,
              ) {
            final data =
            routeState.extra as Map<String, dynamic>;

            final food =
            data['food'] as MilestoneApp6Food;

            final size =
            data['size'] as String;

            final unitPrice =
            (data['unitPrice'] as num).toDouble();

            final quantity =
            data['quantity'] as int;

            return _page(
              routeState,
              MilestoneApp6CheckoutScreen(
                food: food,
                state: state,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // PAGE TRANSITION
  // ================================================================

  CustomTransitionPage<void> _page(
      GoRouterState state,
      Widget child,
      ) {
    return CustomTransitionPage<void>(
      key: state.pageKey,
      child: child,

      transitionDuration:
      const Duration(milliseconds: 420),

      reverseTransitionDuration:
      const Duration(milliseconds: 320),

      transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curved,

          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(.035, 0),
              end: Offset.zero,
            ).animate(curved),

            child: child,
          ),
        );
      },
    );
  }
}