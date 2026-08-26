import 'package:flutter/material.dart';

import 'instagram_style_ui_colors.dart';

class InstagramStyleUiTypography {
  InstagramStyleUiTypography._();

  // App bar username
  static const TextStyle appBarUsername = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: InstagramStyleUiColors.primaryText,
  );

  // Profile name
  static const TextStyle profileName = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: InstagramStyleUiColors.primaryText,
  );

  // Profession
  static const TextStyle profession = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: InstagramStyleUiColors.linkText,
  );

  // Bio
  static const TextStyle bio = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w400,
    color: InstagramStyleUiColors.primaryText,
  );

  // Profile link
  static const TextStyle profileLink = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w500,
    color: InstagramStyleUiColors.linkText,
  );

  // Statistics number
  static const TextStyle statValue = TextStyle(
    fontSize: 21,
    fontWeight: FontWeight.bold,
    color: InstagramStyleUiColors.primaryText,
  );

  // Statistics label
  static const TextStyle statLabel = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: InstagramStyleUiColors.primaryText,
  );

  // Normal button
  static const TextStyle actionButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: InstagramStyleUiColors.primaryText,
  );

  // Follow button
  static const TextStyle followButton = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.w600,
    color: InstagramStyleUiColors.white,
  );

  // Highlight title
  static const TextStyle highlightTitle = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w400,
    color: InstagramStyleUiColors.primaryText,
  );
}