import 'package:flutter/material.dart';

import 'Theme_T23_app_colors.dart';


class ThemeT23AppTypography {
  ThemeT23AppTypography._();

  static TextTheme textTheme({
    required bool isDark,
  }) {
    final Color textColor = isDark
        ? ThemeT23AppColors.darkText
        : ThemeT23AppColors.lightText;

    final Color secondaryColor = isDark
        ? ThemeT23AppColors.darkSecondaryText
        : ThemeT23AppColors.lightSecondaryText;

    return TextTheme(
      headlineLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 32,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),

      headlineMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 26,
        fontWeight: FontWeight.w700,
        color: textColor,
      ),

      headlineSmall: TextStyle(
        fontFamily: 'Lato',
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      titleLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 20,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      titleMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),

      bodyLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 16,
        color: textColor,
      ),

      bodyMedium: TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        color: secondaryColor,
      ),

      bodySmall: TextStyle(
        fontFamily: 'Lato',
        fontSize: 12,
        color: secondaryColor,
      ),

      labelLarge: TextStyle(
        fontFamily: 'Lato',
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: textColor,
      ),
    );
  }
}