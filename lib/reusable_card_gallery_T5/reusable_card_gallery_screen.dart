import 'package:flutter/material.dart';

import 'theme/reusable_card_gallery_colors.dart';
import 'theme/reusable_card_gallery_typography.dart';
import 'widgets/reusable_card_gallery_user_card.dart';
import 'widgets/reusable_card_gallery_product_card.dart';
import 'widgets/reusable_card_gallery_offer_card.dart';
import 'widgets/reusable_card_gallery_subscription_card.dart';

class ReusableCardGalleryScreen extends StatelessWidget {
  const ReusableCardGalleryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double sizeboxhight = 10;
    return Scaffold(
      backgroundColor: ReusableCardGalleryColors.background,

      appBar: AppBar(
        backgroundColor: ReusableCardGalleryColors.background,
        leading: const Icon(
          Icons.menu,
          size: 20,
        ),
        title: const Column(
          children: [
            Text(
              'Reusable Card Gallery',
              style: ReusableCardGalleryTypography.cardTitle,
            ),
            Text(
              'Explore different card designs',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [

            const ReusableCardGalleryUserCard(),
            SizedBox(height: sizeboxhight,),
            const ReusableCardGalleryProductCard(),
            SizedBox(height: sizeboxhight,),
            const ReusableCardGalleryOfferCard(),
            SizedBox(height: sizeboxhight,),

            const ReusableCardGallerySubscriptionCard(),
            SizedBox(height: sizeboxhight,),
          ],
        ),
      ),
    );
  }
}