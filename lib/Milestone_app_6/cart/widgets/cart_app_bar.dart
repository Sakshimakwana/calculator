import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:app_matic_tech_flutter_app/Milestone_app_6/cart/data/cart_controller/cart_controller.dart';

class MilestoneApp6CartAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  final bool hasItems;
  final VoidCallback onClear;

  const MilestoneApp6CartAppBar({
    super.key,
    required this.hasItems,
    required this.onClear,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.go('/home'),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text(
        'My Cart',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      actions: [
        if (hasItems)
          TextButton(
            onPressed: context.read<CartController>().isDeletingCart
                ? null
                : onClear,
            child: const Text(
              'Clear',
              style: TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
      ],
    );
  }
}