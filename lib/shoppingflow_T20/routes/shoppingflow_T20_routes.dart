import 'package:app_matic_tech_flutter_app/new_spalsh_screen_router.dart';
import 'package:app_matic_tech_flutter_app/product_filter_t18/product_filter_t18_main_screen.dart';
import 'package:go_router/go_router.dart';
import '../../Login_page_T14/login_screen.dart';
import '../../product_filter_t18/product_filter_t18_product_screen.dart';
import '../../shoppingflow_T19/shoppingflow_product_list_screen.dart';
import '../../shoppingflow_T21/screens/shoppingflow_T21_onboarding_screen.dart';
import '../screens/shoppingflow_T20_cart_screen.dart';
import '../screens/shoppingflow_T20_categories_screen.dart';
import '../screens/shoppingflow_T20_category_products_screen.dart';
import '../screens/shoppingflow_T20_checkout_screen.dart';
import '../screens/shoppingflow_T20_edit_profile_screen.dart';
import '../screens/shoppingflow_T20_favourites_screen.dart';
import '../screens/shoppingflow_T20_login_screen.dart';
import '../screens/shoppingflow_T20_orders_screen.dart';
import '../screens/shoppingflow_T20_product_details_screen.dart';
import '../screens/shoppingflow_T20_profile_screen.dart';
import '../screens/shoppingflow_T20_search_screen.dart';
import '../screens/shoppingflow_T20_signup_screen.dart';

import '../shoppingflow_T20_home_screen.dart';

final shoppingFlowT20Router = GoRouter(
  initialLocation: '/new_splash',

  routes: [

    // =====================================================
    // SPLASH
    // =====================================================

    GoRoute(
      path: '/new_splash',
      builder: (context, state) {
        return const NewSplashScreenRouter();
      },
    ),

    // =====================================================
    // ONBOARDING
    // =====================================================

    GoRoute(
      path: '/onboarding',
      builder: (context, state) {
        return const ShoppingFlowT21OnboardingScreen();
      },
    ),

    // =====================================================
    // LOGIN
    // =====================================================

    GoRoute(
      path: '/login',
      builder: (context, state) {
        return const ShoppingFlowT20LoginScreen();
      },
    ),

    // =====================================================
    // SIGN UP
    // =====================================================

    GoRoute(
      path: '/signup',
      builder: (context, state) {
        return const ShoppingFlowT20SignupScreen();
      },
    ),

    // =====================================================
    // HOME
    // =====================================================

    GoRoute(
      path: '/home',
      builder: (context, state) {
        return const ProductFilterT18MainScreen();
      },
    ),

    // =====================================================
    // CATEGORIES
    // =====================================================

    GoRoute(
      path: '/categories',
      builder: (context, state) {
        return const ShoppingFlowT20CategoriesScreen();
      },
    ),

    // =====================================================
    // CATEGORY PRODUCTS
    // =====================================================

    GoRoute(
      path: '/categories/:category',
      builder: (context, state) {
        final category = state.pathParameters['category']!;

        return ShoppingFlowT20CategoryProductsScreen(
          category: category,
        );
      },
    ),

    // =====================================================
    // SEARCH
    // =====================================================

    GoRoute(
      path: '/search',
      builder: (context, state) {
        return const ShoppingFlowT20SearchScreen();
      },
    ),

    // =====================================================
    // PRODUCT DETAILS
    // =====================================================

    GoRoute(
      path: '/product/:id',
      builder: (context, state) {
        final productId = state.pathParameters['id']!;

        return ShoppingFlowT20ProductDetailsScreen(
          id: productId,
        );
      },
    ),

    // =====================================================
    // FAVOURITES
    // =====================================================

    GoRoute(
      path: '/favourites',
      builder: (context, state) {
        return const ShoppingFlowT20FavouritesScreen();
      },
    ),

    // =====================================================
    // CART
    // =====================================================

    GoRoute(
      path: '/cart',
      builder: (context, state) {
        return const ShoppingFlowT20CartScreen();
      },
    ),

    // =====================================================
    // CHECKOUT
    // =====================================================

    GoRoute(
      path: '/checkout',
      builder: (context, state) {
        return const ShoppingFlowT20CheckoutScreen();
      },
    ),

    // =====================================================
    // ORDERS
    // =====================================================

    GoRoute(
      path: '/orders',
      builder: (context, state) {
        return const ShoppingFlowT20OrdersScreen();
      },
    ),

    // =====================================================
    // PROFILE
    // =====================================================

    GoRoute(
      path: '/profile',
      builder: (context, state) {
        return const ShoppingFlowT20ProfileScreen();
      },
    ),

    // =====================================================
    // EDIT PROFILE
    // =====================================================

    GoRoute(
      path: '/edit-profile',
      builder: (context, state) {
        return const ShoppingFlowT20EditProfileScreen();
      },
    ),
  ],
);