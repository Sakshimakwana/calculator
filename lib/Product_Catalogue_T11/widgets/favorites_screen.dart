import 'package:flutter/material.dart';

import '../data/product_catalogue_data.dart';
import '../product_cataloge_screen.dart';
import '../theme/product_catalogue_colors.dart';
import 'product_cataloge_card.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({
    super.key,
  });

  @override
  State<FavoritesScreen> createState() =>
      _FavoritesScreenState();
}

class _FavoritesScreenState
    extends State<FavoritesScreen> {

  @override
  Widget build(BuildContext context) {
    final favoriteProducts = productCatalogueData
        .where(
          (product) => product.isFavorite,
    )
        .toList();

    return Scaffold(
      backgroundColor: AppColors1.background,

      appBar: AppBar(
        title: const Text(
          'Favorites',
        ),

        backgroundColor: AppColors1.primary,

        foregroundColor: Colors.white,
      ),

      body: favoriteProducts.isEmpty
          ? const Center(
        child: Text(
          'No favorite products',

          style: TextStyle(
            fontSize: 16,
            color: Colors.grey,
          ),
        ),
      )
          : GridView.builder(
        padding: const EdgeInsets.all(16),

        itemCount:
        favoriteProducts.length,

        gridDelegate:
        const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,

          crossAxisSpacing: 12,

          mainAxisSpacing: 12,

          childAspectRatio: 0.72,
        ),

        itemBuilder: (
            context,
            index,
            ) {
          final product =
          favoriteProducts[index];

          return ProductCard(
            product: product,

            // ❤️ REMOVE FROM FAVORITES
            onFavoriteTap: () {
              setState(() {
                product.isFavorite =
                !product.isFavorite;
              });
            },

            // 📱 PRODUCT DETAILS
            onTap: () {
              Navigator.push(
                context,

                MaterialPageRoute(
                  builder: (context) {
                    return ProductDetailsScreen(
                      product: product,
                    );
                  },
                ),
              );
            },

            // 🛒 ADD TO CART
            onAddToCart: () {
              setState(() {
                product.quantity = 1;
              });
            },

            // ➕ INCREASE QUANTITY
            onIncreaseQuantity: () {
              setState(() {
                product.quantity++;
              });
            },

            // ➖ DECREASE QUANTITY
            onDecreaseQuantity: () {
              setState(() {
                if (product.quantity > 1) {
                  product.quantity--;
                } else {
                  product.quantity = 0;
                }
              });
            },
          );
        },
      ),
    );
  }
}