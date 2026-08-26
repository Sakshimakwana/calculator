import 'package:flutter/material.dart';

import '../theme/instagram_style_ui_colors.dart';
import '../theme/instagram_style_ui_typography.dart';

class InstagramStyleUiProfileHighlights extends StatelessWidget {
  const InstagramStyleUiProfileHighlights({super.key});

  @override
  Widget build(BuildContext context) {
    final List<_HighlightData> highlights = [

      const _HighlightData(
        title: 'Travel',
        icon: Icons.flight,
        backgroundColor:
        InstagramStyleUiColors.travelHighlight,
      ),
      const _HighlightData(
        title: 'Outfits',
        icon: Icons.checkroom,
        backgroundColor:
        InstagramStyleUiColors.outfitHighlight,
      ),
      const _HighlightData(
        title: 'Coffee',
        icon: Icons.coffee,
        backgroundColor:
        InstagramStyleUiColors.coffeeHighlight,
      ),
      const _HighlightData(
        title: 'Photography',
        icon: Icons.camera_alt,
        backgroundColor:
        InstagramStyleUiColors.photographyHighlight,
      ),
      const _HighlightData(
        title: 'Moments',
        icon: Icons.favorite_border,
        backgroundColor:
        InstagramStyleUiColors.momentsHighlight,
      ),
    ];

    return SizedBox(
      height: 100,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        scrollDirection: Axis.horizontal,
        itemCount: highlights.length,
        separatorBuilder: (context, index) {
          return const SizedBox(width: 17);
        },
        itemBuilder: (context, index) {
          final item = highlights[index];

          return Column(
            children: [
              Container(
                width: 72,
                height: 72,
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color:
                    InstagramStyleUiColors.highlightBorder,
                    width: 1.5,
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.backgroundColor,
                  ),
                  child: Icon(
                    item.icon,
                    color: InstagramStyleUiColors.black,
                    size: 34,
                  ),
                ),
              ),

              const SizedBox(height: 6),

              Text(
                item.title,
                style: InstagramStyleUiTypography.highlightTitle,
              ),
            ],
          );
        },
      ),
    );
  }
}

class _HighlightData {
  final String title;
  final IconData icon;
  final Color backgroundColor;

  const _HighlightData({
    required this.title,
    required this.icon,
    required this.backgroundColor,
  });
}