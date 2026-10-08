import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/screens/milestone_app_6_address_screen.dart';
import 'package:app_matic_tech_flutter_app/Milestone_app_6/Address/screens/milestone_app_6_select_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../Address/data/address_storage/address_storage.dart';
import '../Login/auth_storage/auth_storage.dart';
import '../data/milestone_app_6_cart_item.dart';
import '../Home/data/milestone_app_6_food.dart';
import '../Home/data/milestone_app_6_restaurants_data.dart';
import '../screens/milestone_app_6_my_orders_screen.dart';
import '../screens/milestone_app_6_buy_now_checkout_screen.dart';
import '../Home/screens/milestone_app_6_categories.dart';
import '../screens/milestone_app_6_cart.dart';
import '../Home/screens/milestone_app_6_food_details.dart';
import '../Home/screens/milestone_app_6_home.dart';
import '../Login/screens/milestone_app_6_login_screen.dart';
import '../screens/milestone_app_6_onboarding.dart';
import '../screens/milestone_app_6_order_details_screen.dart';
import '../screens/milestone_app_6_profile.dart';
import '../Home/screens/milestone_app_6_restaurant_info.dart';
import '../Home/screens/milestone_app_6_restaurants.dart';
import '../Register/screens/milestone_app_6_signup_screen.dart';

import '../Login/state/milestone_app_6_auth_store.dart';
import '../state/milestone_app_6_state.dart';

import '../widgets/milestone_app_6_shell.dart';

class MilestoneApp6Routes {
  final MilestoneApp6State state;

  late final GoRouter router;

  MilestoneApp6Routes(this.state) {
    final auth = MilestoneApp6AuthStore.instance;

    router = GoRouter(
      // ================================================================
      // INITIAL LOCATION
      // ================================================================

      initialLocation:
      !state.onboardingDone
          ? '/onboarding'
          : AuthStorage.isLoggedIn
          ? AddressStorage.hasSelectedAddress
          ? '/home'
          : '/select-address'
          : '/login',

      // ================================================================
      // REFRESH ROUTER WHEN STATE CHANGES
      // ================================================================

      refreshListenable: Listenable.merge([
        state,
        auth,
      ]),

      // ================================================================
      // REDIRECT
      // ================================================================

      redirect: (context, routeState) {
        final path = routeState.uri.path;

        // --------------------------------------------------------------
        // ROUTE TYPES
        // --------------------------------------------------------------

        final bool isOnboarding =
            path == '/onboarding';

        final bool isLogin =
            path == '/login';

        final bool isSignup =
            path == '/signup';

        final bool isSelectAddress =
            path == '/select-address';

        final bool isAddAddress =
            path == '/add-address';

        final bool isAddressFlow =
            isSelectAddress || isAddAddress;

        final bool isAuthRoute =
            isLogin || isSignup;

        // ==============================================================
        // 1. ONBOARDING NOT COMPLETED
        // ==============================================================

        if (!state.onboardingDone) {
          if (!isOnboarding) {
            return '/onboarding';
          }

          return null;
        }

        // ==============================================================
        // 2. ONBOARDING COMPLETED
        // ==============================================================

        if (isOnboarding) {
          if (!auth.isLoggedIn) {
            return '/login';
          }

          if (!AddressStorage.hasSelectedAddress) {
            return '/select-address';
          }

          return '/home';
        }

        // ==============================================================
        // 3. USER NOT LOGGED IN
        // ==============================================================

        if (!auth.isLoggedIn) {
          // Login/signup are allowed.
          if (isAuthRoute) {
            return null;
          }

          // Everything else requires login.
          return '/login';
        }

        // ==============================================================
        // 4. USER IS LOGGED IN
        // ==============================================================

        // --------------------------------------------------------------
        // Login/signup should not be shown again.
        // --------------------------------------------------------------

        if (auth.isLoggedIn && isAuthRoute) {
          if (!AddressStorage.hasSelectedAddress) {
            return '/select-address';
          }

          return '/home';
        }

        // --------------------------------------------------------------
        // Address flow is allowed after login.
        //
        // This is VERY IMPORTANT.
        //
        // Logged-in user can visit:
        //
        // /select-address
        // /add-address
        // --------------------------------------------------------------

        if (auth.isLoggedIn && isAddressFlow) {
          return null;
        }

        // --------------------------------------------------------------
        // Logged-in user without selected address
        //
        // Don't allow Home or other main app screens until an address
        // has been selected.
        // --------------------------------------------------------------

        if (auth.isLoggedIn &&
            !AddressStorage.hasSelectedAddress) {
          return '/select-address';
        }

        // --------------------------------------------------------------
        // Logged-in user with selected address.
        // --------------------------------------------------------------

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
        // LOGIN
        // ================================================================

        GoRoute(
          path: '/login',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              const MilestoneApp6LoginScreen(),
            );
          },
        ),

        // ================================================================
        // SIGN UP
        // ================================================================

        GoRoute(
          path: '/signup',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              const MilestoneApp6SignupScreen(),
            );
          },
        ),

        // ================================================================
        // SELECT ADDRESS
        //
        // IMPORTANT:
        // Outside ShellRoute.
        //
        // Therefore bottom navigation is NOT shown.
        // ================================================================

        GoRoute(
          path: '/select-address',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              const MilestoneApp6SelectAddressScreen(),
            );
          },
        ),

        // ================================================================
        // ADD NEW ADDRESS
        //
        // IMPORTANT:
        // Outside ShellRoute.
        //
        // Select Address
        //       ↓
        // Add New Address
        //       ↓
        // Save
        //       ↓
        // Home
        // ================================================================

        GoRoute(
          path: '/add-address',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              MilestoneApp6AddressScreen(
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

            // ============================================================
            // RESTAURANT BY NAME
            // ============================================================
            //
            // GoRoute(
            //   path: '/restaurant/:name',
            //   builder: (
            //       context,
            //       routeState,
            //       ) {
            //     final encodedName =
            //         routeState.pathParameters['name'] ??
            //             '';
            //
            //     final name =
            //     Uri.decodeComponent(
            //       encodedName,
            //     );
            //
            //     final restaurant =
            //     restaurants.firstWhere(
            //           (item) =>
            //       item.name
            //           .trim()
            //           .toLowerCase() ==
            //           name
            //               .trim()
            //               .toLowerCase(),
            //       orElse: () =>
            //       restaurants.first,
            //     );
            //
            //     return MilestoneApp6RestaurantInfoScreen(
            //       restaurant: restaurant,
            //       state: state,
            //     );
            //   },
            // ),

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

                if (extra is! Map<String, dynamic>) {
                  return const NoTransitionPage<void>(
                    child: Scaffold(
                      body: Center(
                        child: Text(
                          'Restaurant information is missing.',
                        ),
                      ),
                    ),
                  );
                }

                final restaurant = extra['restaurant'];

                if (restaurant is! MilestoneApp6Restaurant) {
                  return const NoTransitionPage<void>(
                    child: Scaffold(
                      body: Center(
                        child: Text(
                          'Invalid restaurant information.',
                        ),
                      ),
                    ),
                  );
                }

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
            // PROFILE ADDRESS
            //
            // This is your EXISTING profile address route.
            //
            // Keep it if the user can manage addresses from Profile.
            // ============================================================

            GoRoute(
              path: '/profile/address',
              pageBuilder: (
                  context,
                  routeState,
                  ) {
                return _page(
                  routeState,
                  MilestoneApp6AddressScreen(
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
        // Bottom navigation hidden.
        // ================================================================

        // GoRoute(
        //   path: '/food/:id',
        //   pageBuilder: (
        //       context,
        //       routeState,
        //       ) {
        //     final foodId =
        //     routeState.pathParameters['id'];
        //
        //     if (foodId == null ||
        //         foodId.isEmpty) {
        //       return const NoTransitionPage<void>(
        //         child: Scaffold(
        //           body: Center(
        //             child: Text(
        //               'Food information is missing.',
        //             ),
        //           ),
        //         ),
        //       );
        //     }
        //
        //     return _page(
        //       routeState,
        //       MilestoneApp6FoodDetailsScreen(
        //         state: state,
        //         id: foodId,
        //       ),
        //     );
        //   },
        // ),

        // ================================================================
        // MY ORDERS
        // ================================================================

        GoRoute(
          path: '/my-orders',
          pageBuilder: (
              context,
              routeState,
              ) {
            return _page(
              routeState,
              MilestoneApp6MyOrdersScreen(
                state: state,
              ),
            );
          },
        ),

        // ================================================================
        // CHECKOUT
        // ================================================================

        GoRoute(
          path: '/checkout',
          pageBuilder: (
              context,
              routeState,
              ) {
            final extra =
                routeState.extra;

            // ============================================================
            // CASE 1
            // CART CHECKOUT
            // ============================================================

            if (extra
            is MilestoneApp6State) {
              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: extra,
                ),
              );
            }

            // ============================================================
            // CASE 2
            // BUY NOW CHECKOUT ARGS
            // ============================================================

            if (extra
            is MilestoneApp6CheckoutArgs) {
              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: extra.state,
                  buyNowItem:
                  extra.buyNowItem,
                ),
              );
            }

            // ============================================================
            // CASE 3
            // OLD MAP-BASED BUY NOW
            // ============================================================

            if (extra
            is Map<String, dynamic>) {
              final Object? stateData =
              extra['state'];

              if (stateData
              is! MilestoneApp6State) {
                return _checkoutError(
                  routeState,
                  'Checkout state is missing.',
                );
              }

              final Object? foodData =
              extra['food'];

              if (foodData
              is! MilestoneApp6Food) {
                return _checkoutError(
                  routeState,
                  'Food information is missing.',
                );
              }

              final String size =
                  extra['size']
                      ?.toString() ??
                      'Small';

              final double? unitPrice =
              _toDouble(
                extra['unitPrice'],
              );

              final int? quantity =
              _toInt(
                extra['quantity'],
              );

              if (unitPrice == null ||
                  quantity == null ||
                  quantity < 1) {
                return _checkoutError(
                  routeState,
                  'Invalid checkout information.',
                );
              }

              final buyNowItem =
              MilestoneApp6CartItem(
                food: foodData,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              );

              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: stateData,
                  buyNowItem:
                  buyNowItem,
                ),
              );
            }

            // ============================================================
            // CASE 4
            // OLD QUERY PARAMETER BUY NOW
            // ============================================================

            final foodId =
            routeState
                .uri
                .queryParameters['foodId'];

            final size =
            routeState
                .uri
                .queryParameters['size'];

            final unitPriceString =
            routeState
                .uri
                .queryParameters[
            'unitPrice'];

            final quantityString =
            routeState
                .uri
                .queryParameters[
            'quantity'];

            if (foodId != null &&
                foodId.isNotEmpty &&
                size != null &&
                size.isNotEmpty &&
                unitPriceString != null &&
                quantityString != null) {
              final double? unitPrice =
              double.tryParse(
                unitPriceString,
              );

              final int? quantity =
              int.tryParse(
                quantityString,
              );

              if (unitPrice == null ||
                  quantity == null ||
                  quantity < 1) {
                return _checkoutError(
                  routeState,
                  'Invalid checkout information.',
                );
              }

              MilestoneApp6Food? food;

              for (final item
              in milestoneApp6Foods) {
                if (item.id == foodId) {
                  food = item;
                  break;
                }
              }

              if (food == null) {
                return _checkoutError(
                  routeState,
                  'Food information not found.',
                );
              }

              final buyNowItem =
              MilestoneApp6CartItem(
                food: food,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              );

              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: state,
                  buyNowItem:
                  buyNowItem,
                ),
              );
            }

            // ============================================================
            // NOTHING VALID
            // ============================================================

            return _checkoutError(
              routeState,
              'Checkout information is missing.',
            );
          },
        ),

        // ================================================================
        // ORDER DETAILS
        // ================================================================
// ================================================================
// ORDER DETAILS
// ================================================================

        GoRoute(
          path: '/order-details/:orderId',
          pageBuilder: (
              context,
              routeState,
              ) {

            // --------------------------------------------------------------
            // GET ORDER ID FROM URL
            // Example:
            // /order-details/222
            // orderId = 222
            // --------------------------------------------------------------

            final String? orderId =
            routeState.pathParameters['orderId'];

            debugPrint(
              '==========================================',
            );
            debugPrint(
              'ORDER DETAILS ROUTE',
            );
            debugPrint(
              'ORDER ID FROM ROUTE: $orderId',
            );
            debugPrint(
              '==========================================',
            );

            // --------------------------------------------------------------
            // CHECK ORDER ID
            // --------------------------------------------------------------

            if (orderId == null ||
                orderId.trim().isEmpty) {
              return _orderError(
                routeState,
                'Order ID is missing.',
              );
            }

            // --------------------------------------------------------------
            // OPEN ORDER DETAILS SCREEN
            // --------------------------------------------------------------
            //
            // The Order Details screen itself calls:
            //
            // GET /orders/{orderId}
            //
            // so the backend remains the source of truth.
            // --------------------------------------------------------------

            return _page(
              routeState,
              MilestoneApp6OrderDetailsScreen(
                state: state,
                auth: auth,

                // IMPORTANT
                orderId: orderId,

                // These are required by your existing constructor.
                // The Order Details screen gets the real order
                // information from the backend using orderId.
                items: const [],

                paymentType: 'Cash on Delivery',

                subtotal: 0.0,
                shipping: 0.0,
                discount: 0.0,
                totalPayment: 0.0,
                minimumPayment: 0.0,
                amountPaidNow: 0.0,
              ),
            );
          },
        ),
      ],
    );
  }

  // ================================================================
  // CHECKOUT PAGE
  // ================================================================

  CustomTransitionPage<void> _checkoutPage(
      GoRouterState routeState,
      Widget child,
      ) {
    return CustomTransitionPage<void>(
      key: routeState.pageKey,
      transitionDuration:
      const Duration(
        milliseconds: 420,
      ),
      reverseTransitionDuration:
      const Duration(
        milliseconds: 320,
      ),
      child: child,
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
              begin:
              const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(
              curvedAnimation,
            ),
            child: child,
          ),
        );
      },
    );
  }

  // ================================================================
  // CHECKOUT ERROR
  // ================================================================

  NoTransitionPage<void> _checkoutError(
      GoRouterState routeState,
      String message,
      ) {
    return NoTransitionPage<void>(
      key: routeState.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title:
          const Text('Checkout'),
        ),
        body: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ORDER ERROR
  // ================================================================

  NoTransitionPage<void> _orderError(
      GoRouterState routeState,
      String message,
      ) {
    return NoTransitionPage<void>(
      key: routeState.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title:
          const Text(
            'Order Details',
          ),
        ),
        body: Center(
          child: Padding(
            padding:
            const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign:
              TextAlign.center,
              style:
              const TextStyle(
                fontSize: 16,
                fontWeight:
                FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // DOUBLE PARSER
  // ================================================================

  double? _toDouble(
      Object? value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    return double.tryParse(
      value.toString(),
    );
  }

  // ================================================================
  // INT PARSER
  // ================================================================

  int? _toInt(
      Object? value,
      ) {
    if (value == null) {
      return null;
    }

    if (value is int) {
      return value;
    }

    return int.tryParse(
      value.toString(),
    );
  }

  // ================================================================
  // COMMON PAGE
  // ================================================================

  CustomTransitionPage<void> _page(
      GoRouterState routeState,
      Widget child,
      ) {
    return CustomTransitionPage<void>(
      key: routeState.pageKey,
      transitionDuration:
      const Duration(
        milliseconds: 350,
      ),
      reverseTransitionDuration:
      const Duration(
        milliseconds: 280,
      ),
      child: child,
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
              begin:
              const Offset(0.03, 0),
              end: Offset.zero,
            ).animate(
              curvedAnimation,
            ),
            child: child,
          ),
        );
      },
    );
  }
}