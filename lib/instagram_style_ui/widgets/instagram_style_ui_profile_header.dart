import 'package:flutter/material.dart';

import '../theme/instagram_style_ui_colors.dart';

class InstagramStyleUiProfileHeader extends StatelessWidget {
  const InstagramStyleUiProfileHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      padding: const EdgeInsets.all(4),
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            InstagramStyleUiColors.gradientYellow,
            InstagramStyleUiColors.gradientOrange,
            InstagramStyleUiColors.gradientPink,
            InstagramStyleUiColors.gradientPurple,

          ],
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(3),
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: InstagramStyleUiColors.white,
        ),
        child: const CircleAvatar(
          backgroundImage: NetworkImage(
            'https://images.unsplash.com/photo-1494790108377-be9c29b29330?auto=format&fit=crop&w=400&q=80',
          ),
        ),
      ),
    );
  }
}