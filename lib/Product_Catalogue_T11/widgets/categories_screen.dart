import 'package:flutter/material.dart';
import '../theme/product_catalogue_colors.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      ['All', Icons.grid_view],
      ['Electronics', Icons.devices],
      ['Fashion', Icons.checkroom],
      ['Home', Icons.home],
      ['Beauty', Icons.shopping_bag],
      ['Sports', Icons.sports_cricket],

    ];

    return Scaffold(
      backgroundColor: AppColors1.background,

      appBar: AppBar(
        title: const Text('Categories'),
        centerTitle: true,
        backgroundColor: AppColors1.primary,
        foregroundColor: Colors.white,
      ),

      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: categories.length,
        gridDelegate:
        const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 220,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.70,
        ),

        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(15),
            ),

            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: AppColors1.primaryLight,
                  child: Icon(
                    categories[index][1] as IconData,
                    color: AppColors1.primary,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 10),

                Text(
                  categories[index][0] as String,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}