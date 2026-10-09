
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CheckoutScreenHeader extends StatelessWidget
    implements PreferredSizeWidget {
  const CheckoutScreenHeader({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        onPressed: () => context.pop(),
        icon: const Icon(Icons.arrow_back_rounded),
      ),
      title: const Text(
        'Checkout',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
      centerTitle: true,
    );
  }
}
