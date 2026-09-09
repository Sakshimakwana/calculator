import 'package:flutter/material.dart';

import '../theme/reusable_card_gallery_colors.dart';
import '../theme/reusable_card_gallery_typography.dart';
import 'reusable_card_gallery_image_placeholder.dart';

class ReusableCardGalleryUserCard extends StatelessWidget {
  const ReusableCardGalleryUserCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 203,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFFFFFFFF),
            Color(0xFFDCCAFF),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 10,
            offset: Offset(0, 7),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Background circles
          Positioned(
            right: -40,
            top: -55,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFB99AFF).withValues(alpha: 0.17),
              ),
            ),
          ),

          Positioned(
            right: 5,
            top: -20,
            child: Container(
              width: 105,
              height: 105,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFCBB5FF).withValues(alpha: 0.18),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                // Top section
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Network image + placeholder
                    ClipOval(
                      child: SizedBox(
                        width: 70,
                        height: 70,
                        child: Image.network(
                          'https://images.unsplash.com/photo-1494790108377-be9c29b29330?w=400',
                          fit: BoxFit.cover,

                          loadingBuilder:
                              (context, child, loadingProgress) {
                            if (loadingProgress == null) {
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

                    const SizedBox(width: 14),

                    // User details
                    const Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(top: 4),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Sakshi Darji',
                              style:
                              ReusableCardGalleryTypography.cardTitle,
                            ),
                            SizedBox(height: 1),
                            Text(
                              'Flutter Developer',
                              style:
                              ReusableCardGalleryTypography.cardSubtitle,
                            ),
                            SizedBox(height: 6,width: 1,),
                            Text(
                              'Passionate about building '
                                  'beautiful and '
                                  'functional mobile apps.',
                              style: ReusableCardGalleryTypography.usertext,

                            ),
                          ],
                        ),
                      ),
                    ),

                    // Profile icon
                    Container(
                      padding: const EdgeInsets.all(9),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.person,
                        color: ReusableCardGalleryColors.primary,
                        size: 22,
                      ),
                    ),
                  ],
                ),


                const Spacer(),

                Row(
                    children: [
                      SizedBox(
                        width: 55,
                        child: _stat(
                          Icons.work,
                          '24',
                          'Projects',
                          ReusableCardGalleryColors.primary,
                        ),
                      ),

                      _divider(),

                      SizedBox(
                        width: 55,
                        child: _stat(
                          Icons.favorite,
                          '120',
                          'Followers',
                          ReusableCardGalleryColors.pink,
                        ),
                      ),

                      _divider(),

                      SizedBox(
                        width: 55,
                        child: _stat(
                          Icons.people,
                          '89',
                          'Following',
                          ReusableCardGalleryColors.blue,
                        ),
                      ),

                      const SizedBox(width: 10),

                      // View Profile Button
                      Expanded(
                        child: SizedBox(
                          height: 40,
                          child: Container(
                            decoration: BoxDecoration(
                              color: ReusableCardGalleryColors.primary,
                              borderRadius: BorderRadius.circular(11),
                            ),
                            child: const Center(
                              child: Text(
                                'View Profile',
                                maxLines: 1,
                                style: ReusableCardGalleryTypography.button,
                              ),
                            ),
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
    );
  }

  Widget _stat(
      IconData icon,
      String value,
      String title,
      Color color,
      ) {
    return Column(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: color,
            size: 16,
          ),
        ),

        const SizedBox(height: 2),

        Text(
          value,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.bold,
          ),
        ),

        Text(
          title,
          style: const TextStyle(
            fontSize: 11,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }

  Widget _divider() {
    return Container(
      width: 2,
      height: 45,
      color: ReusableCardGalleryColors.border,
    );
  }
}