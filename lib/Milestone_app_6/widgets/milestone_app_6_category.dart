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

    final primaryColor = theme.colorScheme.primary;

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: SizedBox(
        width: 72,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------------------------------------------------------
            // CATEGORY IMAGE
            // ---------------------------------------------------------
            AnimatedScale(
              scale: selected ? 1.05 : 1.0,
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              child: Container(
                width: 58,
                height: 58,
                padding: EdgeInsets.all(
                  selected ? 2.5 : 1.5,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? primaryColor
                      : theme.dividerColor.withOpacity(.25),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: theme.colorScheme.surface,
                  ),
                  padding: const EdgeInsets.all(2),
                  child: ClipOval(
                    child: MilestoneApp6Image(
                      url: category.image,
                      width: 50,
                      height: 50,
                      borderRadius: BorderRadius.circular(50),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 7),

            // ---------------------------------------------------------
            // CATEGORY NAME
            // ---------------------------------------------------------
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: 11,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
                color: selected
                    ? primaryColor
                    : theme.textTheme.bodyMedium?.color,
              ),
              child: Text(
                category.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }
}