import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../theme/modern_store_home_colors.dart';
import 'modern_store_home_image.dart';

class ModernStoreHomeCategoryItem extends StatelessWidget {
  final ModernStoreCategory category;
  final int index;
  final VoidCallback onTap;

  const ModernStoreHomeCategoryItem({
    super.key,
    required this.category,
    required this.index,
    required this.onTap,
  });

  Color get background {
    const colors = [
      ModernStoreHomeColors.categoryOrange,
      ModernStoreHomeColors.categoryBlue,
      ModernStoreHomeColors.categoryGreen,
      ModernStoreHomeColors.categoryPink,
      ModernStoreHomeColors.categoryYellow,
    ];

    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: background,
                shape: BoxShape.circle,
              ),
              child: ModernStoreHomeImage(
                url: category.image,
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: ModernStoreHomeColors.text,
              ),
            ),
          ],
        ),
      ),
    );
  }
}