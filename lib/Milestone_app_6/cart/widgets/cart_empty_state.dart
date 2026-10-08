import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/common_widgets/milestone_app_6_button.dart';

class MilestoneApp6CartEmptyState extends StatelessWidget {
  const MilestoneApp6CartEmptyState({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(30),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withOpacity(.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.shopping_cart_outlined,
                size: 52,
                color: theme.colorScheme.primary,
              ),
            ),

            const SizedBox(height: 22),

            const Text(
              'Your cart is empty',
              style: TextStyle(
                fontSize: 21,
                fontWeight: FontWeight.w800,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              'Looks like you haven\'t added anything to your cart yet.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: theme.hintColor,
                fontSize: 13,
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: 180,
              child: MilestoneApp6Button(
                label: 'Browse Food',
                onPressed: () => context.go('/home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}