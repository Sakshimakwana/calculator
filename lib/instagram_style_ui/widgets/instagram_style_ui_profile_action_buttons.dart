import 'package:flutter/material.dart';
import '../theme/instagram_style_ui_colors.dart';
import '../theme/instagram_style_ui_typography.dart';

class InstagramStyleUiProfileActionButtons extends StatelessWidget {
  const InstagramStyleUiProfileActionButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _InstagramStyleUiActionButton(
            title: 'Follow',
            backgroundColor:
            InstagramStyleUiColors.followButton,
            textStyle:
            InstagramStyleUiTypography.followButton,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _InstagramStyleUiActionButton(
            title: 'Message',
            backgroundColor:
            InstagramStyleUiColors.lightButton,
            textStyle:
            InstagramStyleUiTypography.actionButton,
          ),
        ),

        const SizedBox(width: 8),

        Expanded(
          child: _InstagramStyleUiActionButton(
            title: 'Email',
            backgroundColor:
            InstagramStyleUiColors.lightButton,
            textStyle:
            InstagramStyleUiTypography.actionButton,
          ),
        ),

        const SizedBox(width: 8),

        Container(
          width: 58,
          height: 42,
          decoration: BoxDecoration(
            color: InstagramStyleUiColors.lightButton,
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Icon(
            Icons.person_add_alt_1_outlined,
            color: InstagramStyleUiColors.black,
            size: 23,
          ),
        ),
      ],
    );
  }
}

class _InstagramStyleUiActionButton extends StatelessWidget {
  final String title;
  final Color backgroundColor;
  final TextStyle textStyle;

  const _InstagramStyleUiActionButton({
    required this.title,
    required this.backgroundColor,
    required this.textStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 42,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(9),
      ),
      alignment: Alignment.center,
      child: Text(
        title,
        style: textStyle,
      ),
    );
  }
}