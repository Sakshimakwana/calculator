import 'package:flutter/material.dart';

import '../theme/reusable_card_gallery_colors.dart';
import '../theme/reusable_card_gallery_typography.dart';
import 'reusable_card_gallery_image_placeholder.dart';

class ReusableCardGalleryOfferCard extends StatelessWidget {
  const ReusableCardGalleryOfferCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      height: 170,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFF7043),
            Color(0xFFF50087),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          // Left content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 9,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.orange,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'LIMITED TIME',
                    style: ReusableCardGalleryTypography.offerLabel,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  '50% OFF',
                  style: ReusableCardGalleryTypography.offerTitle,
                ),

                const Text(
                  'Special Weekend Offer',
                  style: ReusableCardGalleryTypography.offerSubtitle,
                ),

                const Text(
                  'On all products and accessories',
                  style: ReusableCardGalleryTypography.offerDescription,
                ),

                const Spacer(),

                // Countdown
                Row(
                  children: [
                    _timeBox('02', 'Days'),
                    _timeBox('14', 'Hours'),
                    _timeBox('45', 'Min'),
                    _timeBox('30', 'Sec'),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Right content
          Column(
            children: [
              SizedBox(
                width: 120,
                height: 100,
                child: Image.asset(
                  'assets/images/gift_box.png',
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const ReusableCardGalleryImagePlaceholder(
                      icon: Icons.image_not_supported_outlined,
                    );
                  },
                ),
              ),

              const Spacer(),

              Container(
                width: 110,
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(7),
                ),
                child: const Center(
                  child: Text(
                    'Shop Now',
                    style: ReusableCardGalleryTypography.offerButton,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timeBox(String number, String label) {
    return Container(
      width: 38,
      height: 32,
      margin: const EdgeInsets.only(right: 5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            number,
            style: ReusableCardGalleryTypography.offerTimeNumber,
          ),
          Text(
            label,
            style: ReusableCardGalleryTypography.offerTimeLabel,
          ),
        ],
      ),
    );
  }
}