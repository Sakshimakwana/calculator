import 'package:flutter/material.dart';

import '../data/milestone_app_6_food.dart';
import 'milestone_app_6_image.dart';

class MilestoneApp6CategoryChip extends StatelessWidget {
  final MilestoneApp6Category category;
  final bool selected;
  final VoidCallback onTap;

  const MilestoneApp6CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final primary = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      child: AnimatedScale(
        scale: selected ? 1.0 : 0.96,
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOutCubic,
          width: 118,
          height: 82,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: selected
                  ? primary
                  : theme.dividerColor.withOpacity(0.18),
              width: selected ? 2 : 1,
            ),
            boxShadow: [
              BoxShadow(
                color: selected
                    ? primary.withOpacity(0.18)
                    : Colors.black.withOpacity(0.06),
                blurRadius: selected ? 14 : 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: Stack(
              fit: StackFit.expand,
              children: [
                // ======================================================
                // FOOD IMAGE
                // ======================================================

                MilestoneApp6Image(
                  url: category.image,
                  width: double.infinity,
                  height: double.infinity,
                  borderRadius: BorderRadius.circular(18),
                  fit: BoxFit.cover,
                ),

                // ======================================================
                // DARK GRADIENT
                // ======================================================

                DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.75),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // CATEGORY NAME
                // ======================================================

                Positioned(
                  left: 10,
                  right: 10,
                  bottom: 9,
                  child: Text(
                    category.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                  ),
                ),

                // ======================================================
                // SELECTED INDICATOR
                // ======================================================

                if (selected)
                  Positioned(
                    top: 7,
                    right: 7,
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        color: primary,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.20),
                            blurRadius: 5,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}