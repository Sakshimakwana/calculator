import 'package:flutter/material.dart';

import '../theme/animations_shopping_colors.dart';

class AnimationsShoppingFavouriteButton extends StatelessWidget {
  final bool isFavourite;
  final VoidCallback onTap;

  const AnimationsShoppingFavouriteButton({
    super.key,
    required this.isFavourite,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(
        begin: 1,
        end: isFavourite ? 1.15 : 1,
      ),
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOutBack,
      builder: (_, scale, child) {
        return Transform.scale(
          scale: scale,
          child: child,
        );
      },
      child: Material(
        color: Colors.white,
        shape: const CircleBorder(),
        child: IconButton(
          onPressed: onTap,
          icon: AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            transitionBuilder: (child, animation) {
              return ScaleTransition(
                scale: animation,
                child: child,
              );
            },
            child: Icon(
              isFavourite
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              key: ValueKey(isFavourite),
              color: isFavourite
                  ? AnimationsShoppingColors.primary
                  : AnimationsShoppingColors.text,
            ),
          ),
        ),
      ),
    );
  }
}