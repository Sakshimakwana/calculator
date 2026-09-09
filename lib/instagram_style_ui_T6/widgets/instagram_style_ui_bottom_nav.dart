import 'package:flutter/material.dart';

import '../theme/instagram_style_ui_colors.dart';

class InstagramStyleUiBottomNav extends StatelessWidget {
  const InstagramStyleUiBottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 65,
      decoration: const BoxDecoration(
        color: InstagramStyleUiColors.background,
        border: Border(
          top: BorderSide(
            color: InstagramStyleUiColors.border,
          ),
        ),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Icon(
            Icons.home,
            color: InstagramStyleUiColors.black,
            size: 29,
          ),

          Icon(
            Icons.search,
            color: InstagramStyleUiColors.black,
            size: 30,
          ),

          Icon(
            Icons.add_box_outlined,
            color: InstagramStyleUiColors.black,
            size: 29,
          ),

          Icon(
            Icons.video_collection_outlined,
            color: InstagramStyleUiColors.black,
            size: 29,
          ),

          _InstagramStyleUiProfileNavIcon(),
        ],
      ),
    );
  }
}

class _InstagramStyleUiProfileNavIcon extends StatelessWidget {
  const _InstagramStyleUiProfileNavIcon();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const Icon(
          Icons.account_circle_outlined,
          color: InstagramStyleUiColors.black,
          size: 31,
        ),

        Positioned(
          right: 0,
          bottom: 0,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: InstagramStyleUiColors.notificationRed,
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }
}