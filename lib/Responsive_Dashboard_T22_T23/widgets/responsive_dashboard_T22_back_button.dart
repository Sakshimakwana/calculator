import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../theme/responsive_dashboard_T22_colors.dart';

class ResponsiveDashboardT22BackButton
    extends StatelessWidget {
  const ResponsiveDashboardT22BackButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        if (context.canPop()) {
          context.pop();
        } else {
          context.go('/responsive-dashboard');
        }
      },
      icon: const Icon(
        Icons.arrow_back_rounded,
        color: ResponsiveDashboardT22Colors.text,
      ),
      tooltip: 'Back',
    );
  }
}
