import 'package:flutter/material.dart';

import '../theme/reusable_card_gallery_colors.dart';
import '../theme/reusable_card_gallery_typography.dart';
import 'reusable_card_gallery_image_placeholder.dart';

class ReusableCardGalleryProductCard extends StatelessWidget {
  const ReusableCardGalleryProductCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            offset: Offset(0, 3),
            color: Color(0x20000000),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Product Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 105,
                  height: 105,
                  child: Image.network(
                    'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400',
                    fit: BoxFit.cover,
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) {
                        return child;
                      }

                      return const ReusableCardGalleryImagePlaceholder();
                    },
                    errorBuilder: (context, error, stackTrace) {
                      return const ReusableCardGalleryImagePlaceholder();
                    },
                  ),
                ),
              ),

              const SizedBox(width: 12),

              // Product Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.topRight,
                      child: Icon(
                        Icons.favorite_border,
                        size: 20,
                      ),
                    ),

                    const Text(
                      'Wireless Headphones',
                      style: ReusableCardGalleryTypography.producttitle,
                    ),

                    const SizedBox(height: 4),

                    const Row(
                      children: [
                        Icon(
                          Icons.star,
                          color: Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 4),
                        Text('4.8'),
                        SizedBox(width: 4),
                        Text(
                          '(230 reviews)',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 6),

                    Row(
                      children: [
                        const Text(
                          '₹2,499',
                          style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          '₹3,999',
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 11,
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE1F5E9),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: const Text(
                            '38% OFF',
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 9,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          // Features
          Row(
            children: [
              _feature(Icons.bluetooth, 'Bluetooth 5.2'),
              _feature(Icons.battery_full, '20h Battery'),
              _feature(Icons.graphic_eq, 'Noise Cancelling'),
            ],
          ),

          const SizedBox(height: 8),

          // Buy Button
          Container(
            width: double.infinity,
            height: 35,
            decoration: BoxDecoration(
              color: ReusableCardGalleryColors.blue,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.shopping_cart,
                  color: Colors.white,
                  size: 16,
                ),
                SizedBox(width: 8),
                Text(
                  'Buy Now',
                  style: ReusableCardGalleryTypography.button,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(IconData icon, String text) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2),
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F7FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 13,
              color: ReusableCardGalleryColors.blue,
            ),
            const SizedBox(width: 3),
            Flexible(
              child: Text(
                text,
                style: const TextStyle(fontSize: 8),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}