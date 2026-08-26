import 'package:flutter/material.dart';

import '../theme/reusable_card_gallery_colors.dart';
import '../theme/reusable_card_gallery_typography.dart';

class ReusableCardGallerySubscriptionCard extends StatelessWidget {
  const ReusableCardGallerySubscriptionCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: const Color(0xFF071B38),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.amber,
                  ),
                ),
                child: const Icon(
                  Icons.workspace_premium,
                  color: Colors.amber,
                  size: 22,
                ),
              ),

              const SizedBox(width: 10),

              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Premium Plan',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Unlock all premium features',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 8,
                    ),
                  ),
                  Text(
                    '₹499 / month',
                    style: TextStyle(
                      color: Colors.amber,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _feature('Unlimited\nAccess'),
              _feature('No Ads\nExperience'),
              _feature('Download\nContent'),
              _feature('Priority\nSupport'),
            ],
          ),

          const SizedBox(height: 10),

          Container(
            width: double.infinity,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(7),
            ),
            child: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.workspace_premium,
                  color: Colors.black,
                  size: 16,
                ),
                SizedBox(width: 6),
                Text(
                  'Subscribe Now',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _feature(String text) {
    return Row(
      children: [
        const Icon(
          Icons.check_circle_outline,
          color: Colors.amber,
          size: 16,
        ),
        const SizedBox(width: 3),
        Text(
          text,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 7,
          ),
        ),
      ],
    );
  }
}