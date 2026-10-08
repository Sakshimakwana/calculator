import 'package:flutter/material.dart';

class MilestoneApp6HomeEmptyFoodState extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onClearSearch;

  const MilestoneApp6HomeEmptyFoodState({
    super.key,
    required this.hasSearch,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 30,
        vertical: 50,
      ),
      child: Column(
        children: [
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: theme.colorScheme.primary.withOpacity(.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 36,
              color: theme.colorScheme.primary,
            ),
          ),

          const SizedBox(
            height: 16,
          ),

          Text(
            'No food found',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(
            height: 6,
          ),

          Text(
            hasSearch
                ? 'Try another search or category.'
                : 'No items are available in this category.',
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.hintColor,
            ),
          ),

          const SizedBox(
            height: 18,
          ),

          if (hasSearch)
            OutlinedButton.icon(
              onPressed: onClearSearch,
              icon: const Icon(
                Icons.clear_rounded,
              ),
              label: const Text(
                'Clear Search',
              ),
            ),
        ],
      ),
    );
  }
}