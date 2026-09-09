import 'package:app_matic_tech_flutter_app/Product_Catalogue_T11/theme/product_cataloge_typography.dart';
import 'package:app_matic_tech_flutter_app/Product_Catalogue_T11/theme/product_catalogue_colors.dart';
import 'package:flutter/material.dart';
import 'models/product_catalogue_model.dart';

class ProductDetailsScreen extends StatefulWidget {
  final ProductModel product;

  const ProductDetailsScreen({
    super.key,
    required this.product,
  });

  @override
  State<ProductDetailsScreen> createState() =>
      _ProductDetailsScreenState();
}

class _ProductDetailsScreenState
    extends State<ProductDetailsScreen> {

  @override
  Widget build(BuildContext context) {
    final product = widget.product;

    // Total price
    final double total =
        product.price * product.quantity;

    return Scaffold(
      // =====================================================
      // APP BAR
      // =====================================================

      appBar: AppBar(
        title: const Text(
          'Product Details',
        ),

        actions: [
          // ❤️ FAVORITE BUTTON
          IconButton(
            onPressed: () {
              setState(() {
                product.isFavorite =
                !product.isFavorite;
              });

              if (product.isFavorite) {
                _showSnackBar(
                  'Added to favorites ❤️',
                );
              } else {
                _showSnackBar(
                  'Removed from favorites',
                );
              }
            },

            icon: Icon(
              product.isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,

              color: product.isFavorite
                  ? AppColors1.red
                  : AppColors1.grey,
            ),
          ),

          const SizedBox(
            width: 8,
          ),
        ],
      ),

      // =====================================================
      // BODY
      // =====================================================

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment:
          CrossAxisAlignment.start,

          children: [

            // =================================================
            // PRODUCT IMAGE
            // =================================================

            ClipRRect(
              borderRadius:
              BorderRadius.circular(16),

              child: Image.network(
                product.image,

                height: 260,

                width: double.infinity,

                fit: BoxFit.cover,

                errorBuilder: (
                    _,
                    __,
                    ___,
                    ) {
                  return const SizedBox(
                    height: 260,

                    child: Center(
                      child: Icon(
                        Icons.image_outlined,
                        size: 60,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // PRODUCT NAME
            // =================================================

            Text(
              product.name,

              style: AppTypography1.title,
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // PRICE
            // =================================================

            Text(
              '₹${product.price.toStringAsFixed(2)}',

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors1.primary,
              ),
            ),

            const SizedBox(
              height: 8,
            ),

            // =================================================
            // RATING
            // =================================================

            Row(
              children: [
                const Icon(
                  Icons.star,
                  color: AppColors1.yellow,
                ),

                const SizedBox(
                  width: 5,
                ),

                Text(
                  product.rating.toString(),

                  style: AppTypography1.body,
                ),
              ],
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // DESCRIPTION
            // =================================================

            const Text(
              'Description',

              style: AppTypography1.title,
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              'Stay connected and enjoy this high quality product. '
                  'Designed with modern features and a simple user experience.',

              style: AppTypography1.body,
            ),

            const SizedBox(
              height: 20,
            ),

            // =================================================
            // FEATURES
            // =================================================

            const Text(
              'Features',

              style: AppTypography1.title,
            ),

            const SizedBox(
              height: 8,
            ),

            const Text(
              '✓ High quality',
            ),

            const Text(
              '✓ Modern design',
            ),

            const Text(
              '✓ Easy to use',
            ),

            const Text(
              '✓ Premium product',
            ),

            const SizedBox(
              height: 30,
            ),

            // =================================================
            // CART SECTION
            // =================================================

            if (product.quantity == 0)

            // -------------------------------------------------
            // ADD TO CART
            // -------------------------------------------------

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      product.quantity = 1;
                    });

                    _showSnackBar(
                      '${product.name} added to cart 🛒',
                    );
                  },

                  icon: const Icon(
                    Icons.shopping_cart_outlined,
                  ),

                  label: const Text(
                    'Add to Cart',
                  ),

                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                    AppColors1.primary,

                    foregroundColor:
                    Colors.white,

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 15,
                    ),

                    shape:
                    RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),
                  ),
                ),
              )

            else

            // -------------------------------------------------
            // QUANTITY + TOTAL
            // -------------------------------------------------

              Column(
                children: [

                  // =================================================
                  // QUANTITY CONTROLLER
                  // =================================================

                  Container(
                    width: double.infinity,

                    padding:
                    const EdgeInsets.symmetric(
                      vertical: 5,
                    ),

                    decoration: BoxDecoration(
                      border: Border.all(
                        color:
                        AppColors1.primary,
                      ),

                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        // ➖ DECREASE
                        IconButton(
                          onPressed: () {
                            setState(() {
                              if (product.quantity >
                                  1) {
                                product.quantity--;
                              } else {
                                product.quantity =
                                0;
                              }
                            });
                          },

                          icon: const Icon(
                            Icons.remove,
                          ),
                        ),

                        // QUANTITY
                        Text(
                          '${product.quantity}',

                          style:
                          const TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        // ➕ INCREASE
                        IconButton(
                          onPressed: () {
                            setState(() {
                              product.quantity++;
                            });
                          },

                          icon: const Icon(
                            Icons.add,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(
                    height: 15,
                  ),

                  // =================================================
                  // TOTAL
                  // =================================================

                  Container(
                    width: double.infinity,

                    padding:
                    const EdgeInsets.all(
                      16,
                    ),

                    decoration: BoxDecoration(
                      color: AppColors1.primary
                          .withOpacity(0.08),

                      borderRadius:
                      BorderRadius.circular(
                        12,
                      ),

                      border: Border.all(
                        color:
                        AppColors1.primary,
                      ),
                    ),

                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween,

                      children: [

                        // TOTAL TEXT
                        const Text(
                          'Total',

                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                            FontWeight.bold,
                          ),
                        ),

                        // TOTAL PRICE
                        Text(
                          '₹${total.toStringAsFixed(2)}',

                          style:
                          const TextStyle(
                            fontSize: 20,
                            fontWeight:
                            FontWeight.bold,
                            color:
                            AppColors1.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  // ==========================================================
  // SNACKBAR
  // ==========================================================

  void _showSnackBar(
      String message,
      ) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(
            message,
          ),

          duration:
          const Duration(
            seconds: 2,
          ),

          behavior:
          SnackBarBehavior.floating,

          action: SnackBarAction(
            label: 'OK',
            onPressed: () {},
          ),
        ),
      );
  }
}