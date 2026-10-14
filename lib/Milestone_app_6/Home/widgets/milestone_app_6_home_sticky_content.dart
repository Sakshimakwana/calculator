import 'package:app_matic_tech_flutter_app/Milestone_app_6/Home/widgets/milestone_app_6_animated_search_hint.dart';
import 'package:flutter/material.dart';

import 'milestone_app_6_home_category_row.dart';
import '../data/milestone_app_6_restaurants_data.dart';

class MilestoneApp6HomeStickyContent extends StatelessWidget {
  final TextEditingController searchController;
  final int searchHintIndex;
  final List<String> searchHints;
  final bool isListening;
  final VoidCallback onMicTap;
  final VoidCallback onClear;
  final bool isLoadingCategories;
  final List<String> categories;
  final String selectedCategory;

  final MilestoneApp6Menu? Function(String categoryName) findCategoryMenu;
  final ValueChanged<String?> onCategorySelected;

  const MilestoneApp6HomeStickyContent({
    super.key,
    required this.searchController,
    required this.searchHintIndex,
    required this.searchHints,
    required this.isListening,
    required this.onMicTap,
    required this.onClear,
    required this.isLoadingCategories,
    required this.categories,
    required this.selectedCategory,
    required this.findCategoryMenu,
    required this.onCategorySelected,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);


    return Container(
      color: theme.scaffoldBackgroundColor,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 8, 18, 12),
            child: SizedBox(
              height: 44,
              child: HomeSearchBar(
                controller: searchController,
                searchHintIndex: searchHintIndex,
                searchHints: searchHints,
                isListening: isListening,
                onMicTap: onMicTap,
                onClear: onClear,
              ),
            ),
          ),

          // Heading
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 0, 18, 4),
            child: Text(
              'What are you craving?',
              style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ),

          // Existing categories
          SizedBox(
            height: 82,
            child: MilestoneApp6HomeCategoryRow(
              isLoading: isLoadingCategories,
              categories: categories,
              selectedCategory: selectedCategory,
              findCategoryMenu: findCategoryMenu,
              onCategorySelected: onCategorySelected,
            ),
          ),

          Container(
            height: 1,
            color: theme.dividerColor.withOpacity(0.18),
          ),
        ],
      ),
    );

  }
}
