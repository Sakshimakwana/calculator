import 'package:flutter/material.dart';

import 'modern_store_home_colors.dart';

class ModernStoreHomeTypography {
  static const textTheme = TextTheme(
    headlineLarge: TextStyle(
      fontSize: 30,
      fontWeight: FontWeight.w700,
      color: ModernStoreHomeColors.text,
    ),
    headlineMedium: TextStyle(
      fontSize: 25,
      fontWeight: FontWeight.w700,
      color: ModernStoreHomeColors.text,
    ),
    titleLarge: TextStyle(
      fontSize: 21,
      fontWeight: FontWeight.w700,
      color: ModernStoreHomeColors.text,
    ),
    titleMedium: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w600,
      color: ModernStoreHomeColors.text,
    ),
    bodyLarge: TextStyle(
      fontSize: 16,
      color: ModernStoreHomeColors.text,
    ),
    bodyMedium: TextStyle(
      fontSize: 14,
      color: ModernStoreHomeColors.secondaryText,
    ),
    labelLarge: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
    ),
  );
}