import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../state/milestone_app_6_state.dart';
import '../../cart/data/cart_controller/cart_controller.dart';

class MilestoneApp6BottomNav extends StatelessWidget {
  final MilestoneApp6State state;

  const MilestoneApp6BottomNav({
    super.key,
    required this.state,
  });

  static const Color accent = Color(0xFFFF514B);

  int _index(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;

    if (path.startsWith('/cart')) return 1;
    if (path.startsWith('/profile')) return 2;

    return 0;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: state,
      builder: (context, _) {
        final index = _index(context);

        if (index == 0 && state.isHomeNetworkError) {
          return const SizedBox.shrink();
        }

        return Consumer<CartController>(
          builder: (context, cart, _) {
            final count = cart.cartItems.length;

            return Material(
              color: Colors.transparent,
              child: Container(
                height: 64,
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? const Color(0xFF252321)
                      : const Color(0xFFFFFEFC),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: accent.withOpacity(0.12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.16),
                      blurRadius: 24,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    _item(
                      context,
                      index: 0,
                      selectedIndex: index,
                      label: 'Home',
                      icon: Icons.home_outlined,
                      activeIcon: Icons.home_rounded,
                    ),
                    _item(
                      context,
                      index: 1,
                      selectedIndex: index,
                      label: 'Cart',
                      icon: Icons.shopping_bag_outlined,
                      activeIcon: Icons.shopping_bag_rounded,
                      count: count,
                    ),
                    _item(
                      context,
                      index: 2,
                      selectedIndex: index,
                      label: 'Profile',
                      icon: Icons.person_outline_rounded,
                      activeIcon: Icons.person_rounded,
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _item(
    BuildContext context, {
    required int index,
    required int selectedIndex,
    required String label,
    required IconData icon,
    required IconData activeIcon,
    int count = 0,
  }) {
    final selected = index == selectedIndex;

    final paths = ['/home', '/cart', '/profile'];

    final dark = Theme.of(context).brightness == Brightness.dark;
    final inactiveColor = dark ? Colors.white60 : const Color(0xFF77716D);

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: () {
          if (!selected) context.go(paths[index]);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOutCubic,
          decoration: BoxDecoration(
            color: selected
                ? accent.withOpacity(dark ? 0.24 : 0.10)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 180),
                    child: Icon(
                      selected ? activeIcon : icon,
                      key: ValueKey(selected),
                      size: 23,
                      color: selected ? accent : inactiveColor,
                    ),
                  ),
                  if (index == 1 && count > 0)
                    Positioned(
                      right: -10,
                      top: -7,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        constraints: const BoxConstraints(
                          minWidth: 17,
                          minHeight: 17,
                        ),
                        decoration: const BoxDecoration(
                          color: Color(0xFFE53935),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          count > 99 ? '99+' : '$count',
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 3),
              AnimatedDefaultTextStyle(
                duration: const Duration(milliseconds: 180),
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected ? accent : inactiveColor,
                ),
                child: Text(label),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
