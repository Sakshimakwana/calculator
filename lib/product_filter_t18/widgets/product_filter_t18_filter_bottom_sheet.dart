import 'package:flutter/material.dart';

import '../theme/product_filter_t18_colors.dart';
import '../theme/product_filter_t18_typography.dart';

class ProductFilterT18FilterBottomSheet extends StatefulWidget {
  const ProductFilterT18FilterBottomSheet({
    super.key,
  });

  @override
  State<ProductFilterT18FilterBottomSheet> createState() =>
      _ProductFilterT18FilterBottomSheetState();
}

class _ProductFilterT18FilterBottomSheetState  extends State<ProductFilterT18FilterBottomSheet> {
  String selectedCategory = 'All';
  RangeValues priceRange = const RangeValues(10, 200);
  int selectedRating = 1;
  bool inStockOnly = false;

  final categories = [
    'All',
    'Electronics',
    'Footwear',
    'Bags',
    'Clothing',
    'Accessories',
  ];

  void _reset() {
    setState(() {
      selectedCategory = 'All';
      priceRange = const RangeValues(10, 200);
      selectedRating = 1;
      inStockOnly = false;
    });
  }

  void _applyFilters() {
    Navigator.pop(
      context,
      {
        'category': selectedCategory,
        'minPrice': priceRange.start,
        'maxPrice': priceRange.end,
        'rating': selectedRating,
        'inStock': inStockOnly,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 45,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                const Expanded(
                  child: Text(
                    'Filter Products',
                    style: ProductFilterT18Typography.title,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text(
              'Category',
              style: ProductFilterT18Typography.sectionTitle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: categories.map((category) {
                return ChoiceChip(
                  label: Text(category),
                  selected: selectedCategory == category,
                  selectedColor: ProductFilterT18Colors.primary,
                  labelStyle: TextStyle(
                    fontFamily: ProductFilterT18Typography.fontFamily,
                    color: selectedCategory == category
                        ? Colors.white
                        : ProductFilterT18Colors.textPrimary,
                  ),
                  onSelected: (_) {
                    setState(() {
                      selectedCategory = category;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 22),
            const Text(
              'Price Range',
              style: ProductFilterT18Typography.sectionTitle,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '\$${priceRange.start.round()}',
                  style: ProductFilterT18Typography.title,
                ),
                Text(
                  '\$${priceRange.end.round()}',
                  style: ProductFilterT18Typography.title,
                ),
              ],
            ),
            RangeSlider(
              values: priceRange,
              min: 0,
              max: 200,
              divisions: 20,
              activeColor: ProductFilterT18Colors.primary,
              onChanged: (value) {
                setState(() {
                  priceRange = value;
                });
              },
            ),
            const SizedBox(height: 10),
            const Text(
              'Rating',
              style: ProductFilterT18Typography.sectionTitle,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              children: [1, 2, 3, 4].map((rating) {
                return ChoiceChip(
                  avatar: const Icon(
                    Icons.star,
                    size: 16,
                    color: ProductFilterT18Colors.star,
                  ),
                  label: Text('$rating+'),
                  selected: selectedRating == rating,
                  selectedColor: ProductFilterT18Colors.primary,
                  onSelected: (_) {
                    setState(() {
                      selectedRating = rating;
                    });
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 14),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text(
                'In Stock Only',
                style: ProductFilterT18Typography.sectionTitle,
              ),
              activeThumbColor: ProductFilterT18Colors.primary,
              value: inStockOnly,
              onChanged: (value) {
                setState(() {
                  inStockOnly = value;
                });
              },
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _applyFilters,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ProductFilterT18Colors.primary,
                  foregroundColor: Colors.white,
                ),
                child: const Text(
                  'Apply Filters',
                  style: ProductFilterT18Typography.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}