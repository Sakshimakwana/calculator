import 'package:go_router/go_router.dart';

import '../screens/shoppingflow_T21_onboarding_screen.dart';

class ShoppingFlowT21Routes {
  static const onboarding = '/onboarding';

  static final List<GoRoute> routes = [
    GoRoute(
      path: onboarding,
      builder: (context, state) {
        return const ShoppingFlowT21OnboardingScreen();
      },
    ),
  ];
}