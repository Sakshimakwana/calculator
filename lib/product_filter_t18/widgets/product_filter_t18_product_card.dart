import 'package:app_matic_tech_flutter_app/product_filter_t18/widgets/product_filter_t18_product_model.dart';
import 'package:flutter/material.dart';

import '../theme/product_filter_t18_colors.dart';
import '../theme/product_filter_t18_typography.dart';

class ProductFilterT18ProductCard extends StatelessWidget {
  final ProductFilterT18ProductModel product;
  final bool isFavorite;
  final VoidCallback onFavorite;

  const ProductFilterT18ProductCard({
    super.key,
    required this.product,
    required this.isFavorite,
    required this.onFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 88,
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: ProductFilterT18Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: ProductFilterT18Colors.border,
        ),
      ),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(5),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: SizedBox(
                width: 78,
                height: 78,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,

                  // Image loading placeholder
                  loadingBuilder: (
                      context,
                      child,
                      loadingProgress,
                      ) {
                    if (loadingProgress == null) {
                      return child;
                    }

                    return Container(
                      color: ProductFilterT18Colors.imagePlaceholder,
                      child: const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: ProductFilterT18Colors.primary,
                          ),
                        ),
                      ),
                    );
                  },

                  // Image error placeholder
                  errorBuilder: (
                      context,
                      error,
                      stackTrace,
                      ) {
                    return Container(
                      color: ProductFilterT18Colors.imagePlaceholder,
                      child: const Icon(
                        Icons.image_not_supported_outlined,
                        color: ProductFilterT18Colors.textSecondary,
                        size: 28,
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          const SizedBox(width: 7),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 8,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: ProductFilterT18Typography.productName,
                  ),

                  const SizedBox(height: 2),

                  Text(
                    product.category,
                    style: ProductFilterT18Typography.category,
                  ),

                  const SizedBox(height: 3),

                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: ProductFilterT18Typography.price,
                  ),

                  const SizedBox(height: 2),

                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        size: 12,
                        color: ProductFilterT18Colors.star,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating} (${product.reviews})',
                        style: ProductFilterT18Typography.rating,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Favorite button
          IconButton(
            onPressed: onFavorite,
            icon: Icon(
              isFavorite
                  ? Icons.favorite
                  : Icons.favorite_border,
              size: 21,
              color: isFavorite
                  ? ProductFilterT18Colors.delete
                  : ProductFilterT18Colors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}