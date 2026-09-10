import 'package:app_matic_tech_flutter_app/modern_store_home_T24/screens/modern_store_home_screen.dart';
import 'package:go_router/go_router.dart';

import 'screens/modern_store_home_cart_screen.dart';
import 'screens/modern_store_home_categories_screen.dart';
import 'screens/modern_store_home_deals_screen.dart';
import 'screens/modern_store_home_profile_screen.dart';
import 'screens/modern_store_home_wishlist_screen.dart';

class ModernStoreHomeRoutes {
  static final GoRouter router = GoRouter(
    initialLocation: '/modern-store-home',
    routes: [
      GoRoute(
        path: '/modern-store-home',
        builder: (context, state) {
          return const ModernStoreHomeScreen();
        },
      ),

      GoRoute(
        path: '/modern-store-home/categories',
        builder: (context, state) {
          return ModernStoreHomeCategoriesScreen(
            initialCategory: state.extra as String?,
          );
        },
      ),

      GoRoute(
        path: '/modern-store-home/deals',
        builder: (context, state) {
          return const ModernStoreHomeDealsScreen();
        },
      ),

      GoRoute(
        path: '/modern-store-home/wishlist',
        builder: (context, state) {
          return const ModernStoreHomeWishlistScreen();
        },
      ),

      GoRoute(
        path: '/modern-store-home/profile',
        builder: (context, state) {
          return const ModernStoreHomeProfileScreen();
        },
      ),

      GoRoute(
        path: '/modern-store-home/cart',
        builder: (context, state) {
          return const ModernStoreHomeCartScreen();
        },
      ),
    ],
  );
}