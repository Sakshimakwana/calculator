import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/data/milestone_app_6_food.dart';
import 'package:flutter/material.dart';

import '../data/milestone_app_6_restaurants_data.dart';
import 'milestone_app_6_category.dart';
import 'milestone_app_6_home_category_shimmer.dart';

class MilestoneApp6HomeCategoryRow extends StatelessWidget {
  final bool isLoading;
  final List<String> categories;
  final String selectedCategory;

  final MilestoneApp6Menu? Function(String categoryName)
  findCategoryMenu;

  final ValueChanged<String?> onCategorySelected;

  const MilestoneApp6HomeCategoryRow({
    super.key,
    required this.isLoading,
    required this.categories,
    required this.selectedCategory,
    required this.findCategoryMenu,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    // ------------------------------------------------------------
    // CATEGORY SHIMMER
    // ------------------------------------------------------------

    if (isLoading && categories.isEmpty) {
      return const MilestoneApp6HomeCategoryShimmer(
        itemCount: 5,
      );
    }

    // ------------------------------------------------------------
    // NO CATEGORIES
    // ------------------------------------------------------------

    if (categories.isEmpty) {
      return const SizedBox.shrink();
    }

    // ------------------------------------------------------------
    // ADD ALL CATEGORY
    // ------------------------------------------------------------

    final List<String> displayCategories = [
      'All',
      ...categories,
    ];

    // ------------------------------------------------------------
    // CATEGORY LIST
    // ------------------------------------------------------------

    return ListView.separated(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 6,
      ),
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      itemCount: displayCategories.length,
      separatorBuilder: (_, __) {
        return const SizedBox(width: 10);
      },
      itemBuilder: (context, index) {
        final String categoryName = displayCategories[index];

        final bool isAll =
            categoryName.trim().toLowerCase() == 'all';

        final bool selected = isAll
            ? selectedCategory.trim().isEmpty
            : selectedCategory.trim().toLowerCase() ==
            categoryName.trim().toLowerCase();

        // --------------------------------------------------------
        // DEFAULT ALL IMAGE
        // --------------------------------------------------------

        String categoryImage =
            'https://images.unsplash.com/photo-1547592180-85f173990554?w=300';

        // --------------------------------------------------------
        // API CATEGORY IMAGE
        // --------------------------------------------------------

        if (!isAll) {
          final MilestoneApp6Menu? selectedMenu =
          findCategoryMenu(categoryName);

          if (selectedMenu != null &&
              selectedMenu.menuItems.isNotEmpty) {
            final String apiImage =
            selectedMenu.menuItems.first.image.trim();

            if (apiImage.isNotEmpty) {
              categoryImage = apiImage;
            }
          }
        }

        // --------------------------------------------------------
        // CATEGORY CHIP
        // --------------------------------------------------------

        return MilestoneApp6CategoryChip(
          category: MilestoneApp6Category(
            categoryName,
            categoryImage,
          ),
          selected: selected,
          onTap: () {
            if (isAll) {
              onCategorySelected(null);
            } else {
              onCategorySelected(categoryName);
            }
          },
        );
      },
    );
  }
}