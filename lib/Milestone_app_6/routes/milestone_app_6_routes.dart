import 'package:app_matic_tech_flutter_app/Milestone_app_6/screens/milestone_app_6_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../data/milestone_app_6_food.dart';
import '../data/milestone_app_6_restaurants_data.dart';
import '../screens/milestone_app_6_my_orders_screen.dart';
import '../screens/milestone_app_6_buy_now_checkout_screen.dart';
import '../screens/milestone_app_6_categories.dart';
import '../screens/milestone_app_6_cart.dart';
import '../screens/milestone_app_6_details.dart';
import '../screens/milestone_app_6_home.dart';
import '../screens/milestone_app_6_login_screen.dart';
import '../screens/milestone_app_6_onboarding.dart';
import '../screens/milestone_app_6_order_details_screen.dart';
import '../screens/milestone_app_6_profile.dart';
import '../screens/milestone_app_6_restaurant_info.dart';
import '../screens/milestone_app_6_restaurants.dart';
import '../screens/milestone_app_6_signup_screen.dart';

import '../state/milestone_app_6_auth_store.dart';
import '../state/milestone_app_6_state.dart';

import '../widgets/milestone_app_6_shell.dart';

import '../data/milestone_app_6_cart_item.dart';

class MilestoneApp6Routes {
  final MilestoneApp6State state;

  late final GoRouter router;

  MilestoneApp6Routes(this.state) {
    final auth = MilestoneApp6AuthStore.instance;

    router = GoRouter(
      // ================================================================
      // INITIAL LOCATION
      // ================================================================

      initialLocation: state.onboardingDone
          ? '/login'
          : '/onboarding',

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

        final bool isOnboarding = path == '/onboarding';
        final bool isLogin = path == '/login';
        final bool isSignup = path == '/signup';

        final bool isAuthRoute = isLogin || isSignup;

        // ============================================================
        // ONBOARDING NOT COMPLETED
        // ============================================================

        if (!state.onboardingDone) {
          if (!isOnboarding) {
            return '/onboarding';
          }

          return null;
        }

        // ============================================================
        // ONBOARDING COMPLETED
        // ============================================================

        if (isOnboarding) {
          if (auth.isLoggedIn) {
            return '/home';
          }

          return '/login';
        }

        // ============================================================
        // USER NOT LOGGED IN
        // ============================================================

        if (!auth.isLoggedIn && !isAuthRoute) {
          return '/login';
        }

        // ============================================================
        // USER ALREADY LOGGED IN
        // DON'T SHOW LOGIN/SIGNUP AGAIN
        // ============================================================

        if (auth.isLoggedIn && isAuthRoute) {
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

            GoRoute(
              path: '/restaurant/:name',
              builder: (
                  context,
                  routeState,
                  ) {
                final encodedName =
                    routeState.pathParameters['name'] ?? '';

                final name = Uri.decodeComponent(
                  encodedName,
                );

                final restaurant = restaurants.firstWhere(
                      (item) =>
                  item.name.trim().toLowerCase() ==
                      name.trim().toLowerCase(),
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
            // ADDRESS
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
        // Outside ShellRoute
        // Bottom navigation is hidden.
        // ================================================================

        GoRoute(
          path: '/food/:id',
          pageBuilder: (
              context,
              routeState,
              ) {
            final foodId =
            routeState.pathParameters['id'];

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
        // CHECKOUT
        //
        // Supports:
        //
        // 1. CART CHECKOUT
        //    context.push(
        //      '/checkout',
        //      extra: state,
        //    );
        //
        // 2. BUY NOW
        //    MilestoneApp6CheckoutArgs
        //
        // 3. OLD MAP-BASED BUY NOW
        //
        // 4. OLD QUERY-PARAMETER BUY NOW
        //
        // Checkout itself contains:
        //
        // Address
        // Products
        // Promo
        // Bill
        // Payment selection
        // Pay Now
        // Confirmation dialog
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
        GoRoute(
          path: '/checkout',
          pageBuilder: (
              context,
              routeState,
              ) {
            final extra = routeState.extra;

            // ============================================================
            // CASE 1
            // CART CHECKOUT
            //
            // Cart screen sends:
            //
            // context.push(
            //   '/checkout',
            //   extra: state,
            // );
            // ============================================================

            if (extra is MilestoneApp6State) {
              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: extra,
                ),
              );
            }

            // ============================================================
            // CASE 2
            // BUY NOW USING CHECKOUT ARGS
            // ============================================================

            if (extra is MilestoneApp6CheckoutArgs) {
              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: extra.state,
                  buyNowItem: extra.buyNowItem,
                ),
              );
            }

            // ============================================================
            // CASE 3
            // OLD MAP-BASED BUY NOW
            // ============================================================

            if (extra is Map<String, dynamic>) {
              final Object? stateData = extra['state'];

              if (stateData is! MilestoneApp6State) {
                return _checkoutError(
                  routeState,
                  'Checkout state is missing.',
                );
              }

              final Object? foodData = extra['food'];

              if (foodData is! MilestoneApp6Food) {
                return _checkoutError(
                  routeState,
                  'Food information is missing.',
                );
              }

              final String size =
                  extra['size']?.toString() ?? 'Small';

              final double? unitPrice =
              _toDouble(extra['unitPrice']);

              final int? quantity =
              _toInt(extra['quantity']);

              if (unitPrice == null ||
                  quantity == null ||
                  quantity < 1) {
                return _checkoutError(
                  routeState,
                  'Invalid checkout information.',
                );
              }

              final buyNowItem = MilestoneApp6CartItem(
                food: foodData,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              );

              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: stateData,
                  buyNowItem: buyNowItem,
                ),
              );
            }

            // ============================================================
            // CASE 4
            // OLD QUERY PARAMETER BUY NOW
            //
            // Example:
            //
            // /checkout?foodId=...&size=Small&unitPrice=10&quantity=1
            // ============================================================

            final foodId =
            routeState.uri.queryParameters['foodId'];

            final size =
            routeState.uri.queryParameters['size'];

            final unitPriceString =
            routeState.uri.queryParameters['unitPrice'];

            final quantityString =
            routeState.uri.queryParameters['quantity'];

            if (foodId != null &&
                foodId.isNotEmpty &&
                size != null &&
                size.isNotEmpty &&
                unitPriceString != null &&
                quantityString != null) {
              final double? unitPrice =
              double.tryParse(unitPriceString);

              final int? quantity =
              int.tryParse(quantityString);

              if (unitPrice == null ||
                  quantity == null ||
                  quantity < 1) {
                return _checkoutError(
                  routeState,
                  'Invalid checkout information.',
                );
              }

              MilestoneApp6Food? food;

              for (final item in milestoneApp6Foods) {
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

              final buyNowItem = MilestoneApp6CartItem(
                food: food,
                size: size,
                unitPrice: unitPrice,
                quantity: quantity,
              );

              return _checkoutPage(
                routeState,
                MilestoneApp6CheckoutScreen(
                  state: state,
                  buyNowItem: buyNowItem,
                ),
              );
            }

            // ============================================================
            // NOTHING VALID WAS PROVIDED
            // ============================================================

            return _checkoutError(
              routeState,
              'Checkout information is missing.',
            );
          },
        ),

        // ================================================================
        // ORDER DETAILS
        //
        // This screen is shown AFTER successful payment.
        //
        // Checkout sends:
        //
        // context.push(
        //   '/order-details',
        //   extra: {
        //     'state': state,
        //     'items': orderedItems,
        //     'paymentType': paymentType,
        //     'subtotal': subtotal,
        //     'shipping': shipping,
        //     'discount': discount,
        //     'totalPayment': totalPayment,
        //     'minimumPayment': minimumPayment,
        //     'amountPaidNow': amountPaidNow,
        //   },
        // );
        // ================================================================

        GoRoute(
          path: '/order-details',
          pageBuilder: (
              context,
              routeState,
              ) {
            final extra = routeState.extra;

            if (extra is! Map<String, dynamic>) {
              return _orderError(
                routeState,
                'Order information is missing.',
              );
            }

            // ============================================================
            // STATE
            // ============================================================

            final Object? stateData =
            extra['state'];

            if (stateData is! MilestoneApp6State) {
              return _orderError(
                routeState,
                'Order state is missing.',
              );
            }

            // ============================================================
            // ITEMS
            // ============================================================

            final Object? itemsData =
            extra['items'];

            if (itemsData is! List) {
              return _orderError(
                routeState,
                'Ordered items are missing.',
              );
            }
            final List<MilestoneApp6CartItem> items =
            itemsData
                .whereType<MilestoneApp6CartItem>()
                .map(
                  (item) => MilestoneApp6CartItem(
                food: item.food,
                size: item.size,
                unitPrice: item.unitPrice,
                quantity: item.quantity,
              ),
            )
                .toList();

            if (items.isEmpty) {
              return _orderError(
                routeState,
                'No ordered items were found.',
              );
            }

            // ============================================================
            // PAYMENT DATA
            // ============================================================

            final String paymentType =
                extra['paymentType']?.toString() ??
                    'Full Payment';

            final double subtotal =
                _toDouble(extra['subtotal']) ?? 0.0;

            final double shipping =
                _toDouble(extra['shipping']) ?? 0.0;

            final double discount =
                _toDouble(extra['discount']) ?? 0.0;

            final double totalPayment =
                _toDouble(extra['totalPayment']) ??
                    0.0;

            final double minimumPayment =
                _toDouble(extra['minimumPayment']) ??
                    0.0;

            final double amountPaidNow =
                _toDouble(extra['amountPaidNow']) ??
                    totalPayment;

            // ============================================================
            // ORDER DETAILS SCREEN
            // ============================================================

            return _page(
              routeState,
              MilestoneApp6OrderDetailsScreen(
                state: stateData,
                auth: auth,
                items: items,
                paymentType: paymentType,
                subtotal: subtotal,
                shipping: shipping,
                discount: discount,
                totalPayment: totalPayment,
                minimumPayment: minimumPayment,
                amountPaidNow: amountPaidNow,
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
      const Duration(milliseconds: 420),

      reverseTransitionDuration:
      const Duration(milliseconds: 320),

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
              begin: const Offset(0.08, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  // ================================================================
  // CHECKOUT ERROR PAGE
  // ================================================================

  NoTransitionPage<void> _checkoutError(
      GoRouterState routeState,
      String message,
      ) {
    return NoTransitionPage<void>(
      key: routeState.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Checkout'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ================================================================
  // ORDER ERROR PAGE
  // ================================================================

  NoTransitionPage<void> _orderError(
      GoRouterState routeState,
      String message,
      ) {
    return NoTransitionPage<void>(
      key: routeState.pageKey,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Order Details'),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
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

  double? _toDouble(Object? value) {
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

  int? _toInt(Object? value) {
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