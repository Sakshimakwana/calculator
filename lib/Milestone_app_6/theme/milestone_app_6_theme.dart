import 'package:flutter/material.dart';

import 'milestone_app_6_colors.dart';
import 'milestone_app_6_typography.dart';

class MilestoneApp6Theme {
  static ThemeData get light {
    final scheme = ColorScheme.fromSeed(
      seedColor: MilestoneApp6Colors.orange,
      brightness: Brightness.light,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: MilestoneApp6Typography.fontFamily,
      scaffoldBackgroundColor: MilestoneApp6Colors.cream,

      appBarTheme: const AppBarTheme(
        backgroundColor: MilestoneApp6Colors.cream,
        foregroundColor: MilestoneApp6Colors.ink,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MilestoneApp6Colors.surface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MilestoneApp6Colors.surface,
        indicatorColor:
        MilestoneApp6Colors.orange.withOpacity(.12),
        labelTextStyle: const WidgetStatePropertyAll(
          MilestoneApp6Typography.label,
        ),
      ),
    );
  }

  static ThemeData get dark {
    final scheme = ColorScheme.fromSeed(
      seedColor: MilestoneApp6Colors.orange,
      brightness: Brightness.dark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: scheme,
      fontFamily: MilestoneApp6Typography.fontFamily,
      scaffoldBackgroundColor:
      MilestoneApp6Colors.darkBackground,

      appBarTheme: const AppBarTheme(
        backgroundColor: MilestoneApp6Colors.darkBackground,
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: MilestoneApp6Colors.darkSurface,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),

      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: MilestoneApp6Colors.darkSurface,
        indicatorColor:
        MilestoneApp6Colors.orange.withOpacity(.18),
        labelTextStyle: const WidgetStatePropertyAll(
          MilestoneApp6Typography.label,
        ),
      ),
    );
  }
}