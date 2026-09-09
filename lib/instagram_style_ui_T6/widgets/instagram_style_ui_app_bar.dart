import 'package:flutter/material.dart';

import '../theme/instagram_style_ui_colors.dart';
import '../theme/instagram_style_ui_typography.dart';

class InstagramStyleUiAppBar extends StatelessWidget
    implements PreferredSizeWidget {
  const InstagramStyleUiAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: InstagramStyleUiColors.background,
      surfaceTintColor: InstagramStyleUiColors.background,

      leading: const Icon(
        Icons.arrow_back_ios_new,
        color: InstagramStyleUiColors.black,
        size: 23,
      ),

      titleSpacing: 9,

      title: Row(
        children: [
          Text(
            'sarah_khan',
            style: InstagramStyleUiTypography.appBarUsername,
          ),

          const SizedBox(width: 5),

          Container(
            width: 25,
            height: 17,
            decoration: const BoxDecoration(
              color: InstagramStyleUiColors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.verified_rounded,
              color: InstagramStyleUiColors.verifiedBlue,
              size: 17,
            ),
          ),
        ],
      ),

      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 16),
          child: Icon(
            Icons.more_vert,
            color: InstagramStyleUiColors.black,
            size: 28,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}