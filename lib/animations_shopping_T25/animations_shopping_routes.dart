import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import ' screens/animations_shopping_cart_screen.dart';
import ' screens/animations_shopping_home_screen.dart';
import ' screens/animations_shopping_onboarding_screen.dart';
import ' screens/animations_shopping_product_details_screen.dart';


final GoRouter animationsShoppingRouter = GoRouter(
  initialLocation:
  '/animations-shopping/onboarding',

  routes: [
    GoRoute(
      path:
      '/animations-shopping/onboarding',

      pageBuilder: (context, state) {
        return _animationPage(
          state,
          const AnimationsShoppingOnboardingScreen(),
        );
      },
    ),

    GoRoute(
      path:
      '/animations-shopping/home',

      pageBuilder: (context, state) {
        return _animationPage(
          state,
          const AnimationsShoppingHomeScreen(),
        );
      },
    ),

    GoRoute(
      path:
      '/animations-shopping/product-details',

      pageBuilder: (context, state) {
        return _animationPage(
          state,
          const AnimationsShoppingProductDetailsScreen(),
        );
      },
    ),

    GoRoute(
      path:
      '/animations-shopping/cart',

      pageBuilder: (context, state) {
        return _animationPage(
          state,
          const AnimationsShoppingCartScreen(),
        );
      },
    ),
  ],
);

CustomTransitionPage _animationPage(
    GoRouterState state,
    Widget child,
    ) {
  return CustomTransitionPage(
    key: state.pageKey,

    transitionDuration: const Duration(
      milliseconds: 500,
    ),

    reverseTransitionDuration: const Duration(
      milliseconds: 350,
    ),

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

      final slideAnimation = Tween<Offset>(
        begin: const Offset(0.12, 0),
        end: Offset.zero,
      ).animate(curvedAnimation);

      return FadeTransition(
        opacity: curvedAnimation,

        child: SlideTransition(
          position: slideAnimation,
          child: child,
        ),
      );
    },
  );
}