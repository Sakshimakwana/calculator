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
      // ================================================================
      // INITIAL LOCATION
      // ================================================================

      initialLocation: state.onboardingDone
          ? '/home'
          : '/onboarding',

      // ================================================================
      // REFRESH ROUTER WHEN STATE CHANGES
      // ================================================================

      refreshListenable: state,

      // ================================================================
      // REDIRECT
      // ================================================================

      redirect: (context, routeState) {
        final bool isOnboarding =
            routeState.uri.path == '/onboarding';

        // User has not completed onboarding.
        // Keep user on onboarding screen.
        if (!state.onboardingDone && !isOnboarding) {
          return '/onboarding';
        }

        // User already completed onboarding.
        // Do not allow opening onboarding again.
        if (state.onboardingDone && isOnboarding) {
          return '/home';
        }

        return null;
      },

      // ================================================================
      // ROUTES
      // ================================================================

      routes: [
        // ================================================================
        // ONBOARDING
        // ================================================================

        GoRoute(
          path: '/onboarding',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              MilestoneApp6OnboardingScreen(
                state: state,
              ),
            );
          },
        ),

        // ================================================================
        // MAIN APP
        // SHELL ROUTE + BOTTOM NAVIGATION
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
            // ============================================================
            // HOME
            // ============================================================

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

            // ============================================================
            // CATEGORIES
            // ============================================================

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

            // ============================================================
            // RESTAURANTS
            // ============================================================

            GoRoute(
              path: '/restaurant/:name',
              builder: (context, routeState) {
                final name =
                    routeState.pathParameters['name'] ?? '';

                final restaurant = restaurants.firstWhere(
                      (item) => item.name == name,
                  orElse: () => restaurants.first,
                );

                return MilestoneApp6RestaurantInfoScreen(
                  restaurant: restaurant,
                  state: state,
                );
              },
            ),

            // ============================================================
            // RESTAURANT INFO
            // ============================================================

            GoRoute(
              path: '/restaurant-info',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                final extra = routeState.extra;

                // --------------------------------------------------------
                // Validate route extra
                // --------------------------------------------------------

                if (extra is! Map<String, dynamic>) {
                  return const NoTransitionPage(
                    child: Scaffold(
                      body: Center(
                        child: Text(
                          'Restaurant information is missing.',
                        ),
                      ),
                    ),
                  );
                }

                // --------------------------------------------------------
                // Get restaurant
                // --------------------------------------------------------

                final restaurant = extra['restaurant'];

                if (restaurant is! MilestoneApp6Restaurant) {
                  return const NoTransitionPage(
                    child: Scaffold(
                      body: Center(
                        child: Text(
                          'Invalid restaurant information.',
                        ),
                      ),
                    ),
                  );
                }

                // --------------------------------------------------------
                // Restaurant Info Screen
                // --------------------------------------------------------

                return _page(
                  routeState,
                  MilestoneApp6RestaurantInfoScreen(
                    restaurant: restaurant,
                    state: state,
                  ),
                );
              },
            ),

            // ============================================================
            // CART
            // ============================================================

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

            // ============================================================
            // PROFILE
            // ============================================================

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
        //
        // Outside ShellRoute.
        //
        // Bottom navigation is hidden on Food Details.
        // ================================================================

        GoRoute(
          path: '/food/:id',
          pageBuilder: (
              context,
              routeState,
              ) {
            final String? foodId =
            routeState.pathParameters['id'];

            // ------------------------------------------------------------
            // Validate food ID
            // ------------------------------------------------------------

            if (foodId == null || foodId.isEmpty) {
              return const NoTransitionPage(
                child: Scaffold(
                  body: Center(
                    child: Text(
                      'Food information is missing.',
                    ),
                  ),
                ),
              );
            }

            // ------------------------------------------------------------
            // Food Details Screen
            // ------------------------------------------------------------

            return _page(
              routeState,
              MilestoneApp6FoodDetailsScreen(
                state: state,
                id: foodId,
              ),
            );
          },
        ),

        // ================================================================
        // BUY NOW CHECKOUT
        //
        // Outside ShellRoute.
        //
        // Bottom navigation is hidden on Checkout.
        // ================================================================

        GoRoute(
          path: '/checkout',
          pageBuilder: (
              context,
              routeState,
              ) {
            // ================================================================
            // GET CHECKOUT DATA FROM QUERY PARAMETERS
            // ================================================================

            final foodId =
            routeState.uri.queryParameters['foodId'];

            final size =
            routeState.uri.queryParameters['size'];

            final unitPriceString =
            routeState.uri.queryParameters['unitPrice'];

            final quantityString =
            routeState.uri.queryParameters['quantity'];

            // ================================================================
            // VALIDATE DATA
            // ================================================================

            if (foodId == null ||
                foodId.isEmpty ||
                size == null ||
                size.isEmpty ||
                unitPriceString == null ||
                quantityString == null) {
              return const NoTransitionPage(
                child: Scaffold(
                  body: Center(
                    child: Text(
                      'Checkout information is missing.',
                    ),
                  ),
                ),
              );
            }

            // ================================================================
            // CONVERT PRICE + QUANTITY
            // ================================================================

            final unitPrice =
            double.tryParse(unitPriceString);

            final quantity =
            int.tryParse(quantityString);

            if (unitPrice == null ||
                quantity == null ||
                quantity < 1) {
              return const NoTransitionPage(
                child: Scaffold(
                  body: Center(
                    child: Text(
                      'Invalid checkout information.',
                    ),
                  ),
                ),
              );
            }

            // ================================================================
            // FIND FOOD
            // ================================================================

            MilestoneApp6Food? food;

            for (final item in milestoneApp6Foods) {
              if (item.id == foodId) {
                food = item;
                break;
              }
            }

            if (food == null) {
              return const NoTransitionPage(
                child: Scaffold(
                  body: Center(
                    child: Text(
                      'Food information not found.',
                    ),
                  ),
                ),
              );
            }

            // ================================================================
            // CHECKOUT SCREEN
            // ================================================================

            return CustomTransitionPage(
              key: routeState.pageKey,

              transitionDuration:
              const Duration(milliseconds: 420),

              reverseTransitionDuration:
              const Duration(milliseconds: 320),

              child: MilestoneApp6CheckoutScreen(
                food: food,
                state: state,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              ),

              transitionsBuilder: (
                  context,
                  animation,
                  secondaryAnimation,
                  child,
                  ) {
                final curvedAnimation =
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeOutCubic,
                );

                return FadeTransition(
                  opacity: curvedAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: const Offset(0.08, 0),
                      end: Offset.zero,
                    ).animate(curvedAnimation),
                    child: child,
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // COMMON PAGE BUILDER
  // ================================================================

  CustomTransitionPage<void> _page(
      GoRouterState routeState,
      Widget child,
      ) {
    return CustomTransitionPage<void>(
      key: routeState.pageKey,

      transitionDuration:
      const Duration(milliseconds: 350),

      reverseTransitionDuration:
      const Duration(milliseconds: 280),

      child: child,

      transitionsBuilder: (
          context,
          animation,
          secondaryAnimation,
          child,
          ) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }
}