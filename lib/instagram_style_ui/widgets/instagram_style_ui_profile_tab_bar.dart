import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../theme/instagram_style_ui_colors.dart';

class InstagramStyleUiProfileTabBar extends StatelessWidget {
  const InstagramStyleUiProfileTabBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: InstagramStyleUiColors.black,
            width: 1,
          ),
        ),
      ),
      child: const Row(
        children: [
          Expanded(
            child: Center(
              child: Icon(
                Icons.grid_on,
                color: InstagramStyleUiColors.black,
                size: 27,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Icon(
                LucideIcons.video,
                color: InstagramStyleUiColors.greyText,
                size: 27,
              ),
            ),
          ),

          Expanded(
            child: Center(
              child: Icon(
                LucideIcons.userRound,
                color: InstagramStyleUiColors.greyText,
                size: 27,
              ),
            ),
          ),
        ],
      ),
    );
  }
}