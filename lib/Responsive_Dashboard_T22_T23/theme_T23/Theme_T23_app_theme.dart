import 'package:flutter/material.dart';

import 'Theme_T23_app_colors.dart';
import 'Theme_T23_app_typography.dart';



class AppTheme {
  AppTheme._();

  // ============================================================
  // LIGHT THEME
  // ============================================================

  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.light,

    scaffoldBackgroundColor:
    ThemeT23AppColors.lightBackground,

    colorScheme: const ColorScheme.light(
      primary: ThemeT23AppColors.primary,
      onPrimary: Colors.white,

      secondary: ThemeT23AppColors.green,
      onSecondary: Colors.white,

      surface: ThemeT23AppColors.lightSurface,
      onSurface: ThemeT23AppColors.lightText,

      outline: ThemeT23AppColors.lightBorder,
    ),

    textTheme: ThemeT23AppTypography.textTheme(
      isDark: false,
    ),

    // ==========================================================
    // APP BAR
    // ==========================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeT23AppColors.lightSurface,
      foregroundColor: ThemeT23AppColors.lightText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // ==========================================================
    // CARD
    // ==========================================================

    cardTheme: CardThemeData(
      color: ThemeT23AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: ThemeT23AppColors.lightBorder,
        ),
      ),
    ),

    // ==========================================================
    // LIST TILE
    // ==========================================================

    listTileTheme: const ListTileThemeData(
      textColor: ThemeT23AppColors.lightText,
      iconColor: ThemeT23AppColors.primary,
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: ThemeT23AppColors.lightBorder,
      thickness: 1,
    ),

    // ==========================================================
    // ICON
    // ==========================================================

    iconTheme: const IconThemeData(
      color: ThemeT23AppColors.lightText,
    ),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================

    navigationBarTheme:
    NavigationBarThemeData(
      backgroundColor: ThemeT23AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: ThemeT23AppColors.lightPurpleCard,
      elevation: 2,
    ),

    // ==========================================================
    // DRAWER
    // ==========================================================

    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeT23AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
    ),

    // ==========================================================
    // INPUT
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeT23AppColors.lightSurface,

      hintStyle: const TextStyle(
        color: ThemeT23AppColors.lightSecondaryText,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.lightBorder,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.lightBorder,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.primary,
          width: 2,
        ),
      ),
    ),

    // ==========================================================
    // SWITCH
    // ==========================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }

          return ThemeT23AppColors.lightSecondaryText;
        },
      ),

      trackColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeT23AppColors.primary;
          }

          return ThemeT23AppColors.lightBorder;
        },
      ),
    ),

    // ==========================================================
    // DIALOG
    // ==========================================================

    dialogTheme: DialogThemeData(
      backgroundColor: ThemeT23AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // ==========================================================
    // BOTTOM SHEET
    // ==========================================================

    bottomSheetTheme:
    const BottomSheetThemeData(
      backgroundColor: ThemeT23AppColors.lightSurface,
      surfaceTintColor: Colors.transparent,
    ),
  );

  // ============================================================
  // DARK THEME
  // ============================================================

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    brightness: Brightness.dark,

    scaffoldBackgroundColor:
    ThemeT23AppColors.darkBackground,

    colorScheme: const ColorScheme.dark(
      primary: ThemeT23AppColors.primaryDark,
      onPrimary: Colors.white,

      secondary: ThemeT23AppColors.green,
      onSecondary: Colors.white,

      surface: ThemeT23AppColors.darkSurface,
      onSurface: ThemeT23AppColors.darkText,

      outline: ThemeT23AppColors.darkBorder,
    ),

    textTheme: ThemeT23AppTypography.textTheme(
      isDark: true,
    ),

    // ==========================================================
    // APP BAR
    // ==========================================================

    appBarTheme: const AppBarTheme(
      backgroundColor: ThemeT23AppColors.darkSurface,
      foregroundColor: ThemeT23AppColors.darkText,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
    ),

    // ==========================================================
    // CARD
    // ==========================================================

    cardTheme: CardThemeData(
      color: ThemeT23AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: const BorderSide(
          color: ThemeT23AppColors.darkBorder,
        ),
      ),
    ),

    // ==========================================================
    // LIST TILE
    // ==========================================================

    listTileTheme: const ListTileThemeData(
      textColor: ThemeT23AppColors.darkText,
      iconColor: ThemeT23AppColors.primaryDark,
    ),

    // ==========================================================
    // DIVIDER
    // ==========================================================

    dividerTheme: const DividerThemeData(
      color: ThemeT23AppColors.darkBorder,
      thickness: 1,
    ),

    // ==========================================================
    // ICON
    // ==========================================================

    iconTheme: const IconThemeData(
      color: ThemeT23AppColors.darkText,
    ),

    // ==========================================================
    // NAVIGATION BAR
    // ==========================================================

    navigationBarTheme:
    const NavigationBarThemeData(
      backgroundColor: ThemeT23AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      indicatorColor: Color(0xFF302B54),
      elevation: 2,
    ),

    // ==========================================================
    // DRAWER
    // ==========================================================

    drawerTheme: const DrawerThemeData(
      backgroundColor: ThemeT23AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
    ),

    // ==========================================================
    // INPUT
    // ==========================================================

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: ThemeT23AppColors.darkSurface,

      hintStyle: const TextStyle(
        color: ThemeT23AppColors.darkSecondaryText,
      ),

      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.darkBorder,
        ),
      ),

      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.darkBorder,
        ),
      ),

      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: const BorderSide(
          color: ThemeT23AppColors.primaryDark,
          width: 2,
        ),
      ),
    ),

    // ==========================================================
    // SWITCH
    // ==========================================================

    switchTheme: SwitchThemeData(
      thumbColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return Colors.white;
          }

          return ThemeT23AppColors.darkSecondaryText;
        },
      ),

      trackColor: WidgetStateProperty.resolveWith(
            (states) {
          if (states.contains(WidgetState.selected)) {
            return ThemeT23AppColors.primaryDark;
          }

          return ThemeT23AppColors.darkBorder;
        },
      ),
    ),

    // ==========================================================
    // DIALOG
    // ==========================================================

    dialogTheme: DialogThemeData(
      backgroundColor: ThemeT23AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
    ),

    // ==========================================================
    // BOTTOM SHEET
    // ==========================================================

    bottomSheetTheme:
    const BottomSheetThemeData(
      backgroundColor: ThemeT23AppColors.darkSurface,
      surfaceTintColor: Colors.transparent,
    ),
  );
}