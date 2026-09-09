import 'package:flutter/material.dart';
import '../models/product_catalogue_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;

  // Favourite
  final VoidCallback onFavoriteTap;

  // Product details
  final VoidCallback onTap;

  // Cart
  final VoidCallback onAddToCart;

  // Quantity
  final VoidCallback onIncreaseQuantity;
  final VoidCallback onDecreaseQuantity;

  const ProductCard({
    super.key,
    required this.product,
    required this.onFavoriteTap,
    required this.onTap,
    required this.onAddToCart,
    required this.onIncreaseQuantity,
    required this.onDecreaseQuantity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      clipBehavior: Clip.antiAlias,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --------------------------------------------------
          // PRODUCT IMAGE
          // --------------------------------------------------

          Expanded(
            child: Stack(
              children: [
                GestureDetector(
                  onTap: onTap,

                  child: SizedBox(
                    width: double.infinity,

                    child: Image.network(
                      product.image,
                      fit: BoxFit.cover,

                      errorBuilder: (
                          context,
                          error,
                          stackTrace,
                          ) {
                        return const Center(
                          child: Icon(
                            Icons.image_not_supported,
                          ),
                        );
                      },
                    ),
                  ),
                ),


                Positioned(
                  top: 8,
                  right: 8,

                  child: CircleAvatar(
                    backgroundColor: Colors.white,

                    child: IconButton(
                      padding: EdgeInsets.zero,

                      onPressed: onFavoriteTap,

                      icon: Icon(
                        product.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,

                        color: product.isFavorite
                            ? Colors.red
                            : Colors.black,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // --------------------------------------------------
          // PRODUCT DETAILS
          // --------------------------------------------------

          Padding(
            padding: const EdgeInsets.all(10),

            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,

              children: [
                // Product Name
                Text(
                  product.name,

                  maxLines: 1,

                  overflow: TextOverflow.ellipsis,

                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 5),

                // Product Price
                Text(
                  '₹${product.price.toStringAsFixed(0)}',

                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                const SizedBox(height: 8),

                // --------------------------------------------------
                // CART
                // --------------------------------------------------

                if (product.quantity == 0)

                // ADD TO CART
                  SizedBox(
                    width: double.infinity,

                    child: ElevatedButton.icon(
                      onPressed: onAddToCart,

                      icon: const Icon(
                        Icons.shopping_cart,
                      ),

                      label: const Text(
                        'Add to Cart',
                      ),
                    ),
                  )

                else

                // --------------------------------------------------
                // QUANTITY CONTROLLER
                // --------------------------------------------------

                  Container(
                    width: double.infinity,

                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey,
                      ),

                      borderRadius:
                      BorderRadius.circular(8),
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,

                      children: [
                        // DECREASE
                        IconButton(
                          onPressed:
                          onDecreaseQuantity,

                          icon: const Icon(
                            Icons.remove,
                          ),
                        ),

                        // QUANTITY
                        Text(
                          '${product.quantity}',

                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        // INCREASE
                        IconButton(
                          onPressed:
                          onIncreaseQuantity,

                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}