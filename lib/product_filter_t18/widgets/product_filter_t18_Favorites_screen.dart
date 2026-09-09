import 'package:flutter/material.dart';

import '../../product_filter_t18/widgets/product_filter_t18_product_card.dart';
import '../../product_filter_t18/widgets/product_filter_t18_product_data.dart';
import '../../product_filter_t18/widgets/product_filter_t18_product_model.dart';

class Productfiltert18FavouritesScreen
    extends StatelessWidget {

  const Productfiltert18FavouritesScreen({
    super.key,
    required this.favoriteProductIds,
    required this.onFavorite,
  });

  final Set<int> favoriteProductIds;

  final void Function(int productId) onFavorite;

  @override
  Widget build(BuildContext context) {

    final List<ProductFilterT18ProductModel>
    favouriteProducts =
    ProductFilterT18ProductData.products
        .where(
          (product) =>
          favoriteProductIds
              .contains(product.id),
    )
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Wishlist'),
      ),

      body: favouriteProducts.isEmpty

          ? const Center(
        child: Column(
          mainAxisAlignment:
          MainAxisAlignment.center,

          children: [

            Icon(
              Icons.favorite_border,
              size: 70,
              color: Colors.grey,
            ),

            SizedBox(height: 15),

            Text(
              'Your wishlist is empty',

              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 6),

            Text(
              'Add products to your wishlist',

              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      )

          : ListView.builder(

        padding:
        const EdgeInsets.all(10),

        itemCount:
        favouriteProducts.length,

        itemBuilder:
            (context, index) {

          final product =
          favouriteProducts[index];

          return ProductFilterT18ProductCard(
            product: product,

            isFavorite: true,

            onFavorite: () {
              onFavorite(product.id);
            },
          );
        },
      ),
    );
  }
}