import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/instagram_style_ui_colors.dart';
import '../theme/instagram_style_ui_typography.dart';

class InstagramStyleUiProfileBio extends StatelessWidget {
  const InstagramStyleUiProfileBio({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Sarah Khan',
          style: InstagramStyleUiTypography.profileName,
        ),

        SizedBox(height: 2),

        Text(
          'Digital Creator',
          style: InstagramStyleUiTypography.profession,
        ),

        SizedBox(height: 2),

        Text(
          'Dreamer | Believer | Achiever ✨',
          style: InstagramStyleUiTypography.bio,
        ),

        SizedBox(height: 2),

        Text(
          'Travel | Fashion | Lifestyle',
          style: InstagramStyleUiTypography.bio,
        ),

        SizedBox(height: 2),


        const SizedBox(height: 2),

        Row(
          children: [
            const Text(
              '📍',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'Mumbai, India',
              style: InstagramStyleUiTypography.bio,
            ),
          ],
        ),
        Row(
          children: [
            const Text(
              '✉️',
              style: TextStyle(
                fontSize: 16,
              ),
            ),
            const SizedBox(width: 5),
            Text(
              'collab.sarahkhan@gmail.com',
              style: InstagramStyleUiTypography.bio,
            ),
          ],
        ),
        SizedBox(height: 4),

        Text(
          'linktr.ee/sarah_khan',
          style: InstagramStyleUiTypography.profileLink,
        ),
      ],
    );
  }
}