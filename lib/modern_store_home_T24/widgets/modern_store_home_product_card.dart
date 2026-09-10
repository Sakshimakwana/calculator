import 'package:flutter/material.dart';

import '../data/modern_store_home_products.dart';
import '../state/modern_store_home_state.dart';
import '../theme/modern_store_home_colors.dart';
import 'modern_store_home_image.dart';

class ModernStoreHomeProductCard extends StatelessWidget {
  final ModernStoreProduct product;

  const ModernStoreHomeProductCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Set<int>>(
      valueListenable: ModernStoreHomeState.wishlist,
      builder: (context, wishlist, child) {
        final isFavorite = wishlist.contains(product.id);

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: ModernStoreHomeColors.border,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: ModernStoreHomeImage(
                          url: product.image,
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 12,
                      right: 12,
                      child: Material(
                        color: Colors.white,
                        shape: const CircleBorder(),
                        child: InkWell(
                          customBorder: const CircleBorder(),
                          onTap: () {
                            ModernStoreHomeState
                                .toggleWishlist(product.id);
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              size: 20,
                              color: isFavorite
                                  ? Colors.red
                                  : ModernStoreHomeColors.text,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 0, 12, 10),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        children: [
                          Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              '₹${product.oldPrice.toStringAsFixed(0)}',
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 11,
                                color: Colors.grey,
                                decoration:
                                TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color:
                              ModernStoreHomeColors.green,
                              borderRadius:
                              BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${product.discount}% OFF',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color:
                                ModernStoreHomeColors.greenText,
                              ),
                            ),
                          ),
                          const Spacer(),
                          ValueListenableBuilder<Set<int>>(
                            valueListenable:
                            ModernStoreHomeState.cart,
                            builder: (context, cart, child) {
                              final inCart =
                              cart.contains(product.id);

                              return InkWell(
                                onTap: () {
                                  ModernStoreHomeState
                                      .toggleCart(product.id);
                                },
                                child: Icon(
                                  inCart
                                      ? Icons.shopping_cart
                                      : Icons
                                      .add_shopping_cart,
                                  size: 20,
                                  color:
                                  ModernStoreHomeColors.primary,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}