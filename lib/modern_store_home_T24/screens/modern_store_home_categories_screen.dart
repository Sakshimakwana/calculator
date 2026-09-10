import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../widgets/modern_store_home_bottom_nav.dart';
import '../widgets/modern_store_home_product_card.dart';

class ModernStoreHomeCategoriesScreen extends StatefulWidget {
  final String? initialCategory;

  const ModernStoreHomeCategoriesScreen({
    super.key,
    this.initialCategory,
  });

  @override
  State<ModernStoreHomeCategoriesScreen> createState() =>
      _ModernStoreHomeCategoriesScreenState();
}

class _ModernStoreHomeCategoriesScreenState
    extends State<ModernStoreHomeCategoriesScreen> {
  late String selected;

  @override
  void initState() {
    super.initState();
    selected = widget.initialCategory ?? 'All';
  }

  @override
  Widget build(BuildContext context) {
    final categories = [
      'All',
      ...ModernStoreHomeProducts.categories.map((e) => e.name),
    ];

    final products = selected == 'All'
        ? ModernStoreHomeProducts.products
        : ModernStoreHomeProducts.products
        .where((p) => p.category == selected)
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(fontWeight: FontWeight.w700),
        ),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 55,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (_, __) =>
              const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = categories[index];
                final active = category == selected;

                return ChoiceChip(
                  label: Text(category),
                  selected: active,
                  onSelected: (_) {
                    setState(() {
                      selected = category;
                    });
                  },
                );
              },
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 14,
                crossAxisSpacing: 14,
                childAspectRatio: .68,
              ),
              itemBuilder: (context, index) {
                return ModernStoreHomeProductCard(
                  product: products[index],
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar:
      const ModernStoreHomeBottomNav(currentIndex: 1),
    );
  }
}