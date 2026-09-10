import 'package:flutter/material.dart';

import '../theme/animations_shopping_colors.dart';

class AnimationsShoppingQuantityButton
    extends StatelessWidget {
  final int quantity;
  final VoidCallback onMinus;
  final VoidCallback onPlus;

  const AnimationsShoppingQuantityButton({
    super.key,
    required this.quantity,
    required this.onMinus,
    required this.onPlus,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(
        milliseconds: 250,
      ),
      curve: Curves.easeOut,

      padding: const EdgeInsets.all(4),

      decoration: BoxDecoration(
        color: quantity > 1
            ? AnimationsShoppingColors.primaryLight
            : Colors.white,

        borderRadius: BorderRadius.circular(12),

        border: Border.all(
          color: AnimationsShoppingColors.border,
        ),
      ),

      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: onMinus,
            icon: const Icon(
              Icons.remove,
            ),
            visualDensity:
            VisualDensity.compact,
          ),

          AnimatedSwitcher(
            duration: const Duration(
              milliseconds: 200,
            ),

            transitionBuilder: (
                child,
                animation,
                ) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },

            child: Text(
              '$quantity',
              key: ValueKey(quantity),

              style: const TextStyle(
                fontWeight: FontWeight.w700,
              ),
            ),
          ),

          IconButton(
            onPressed: onPlus,
            icon: const Icon(
              Icons.add,
              color:
              AnimationsShoppingColors.primary,
            ),
            visualDensity:
            VisualDensity.compact,
          ),
        ],
      ),
    );
  }
}