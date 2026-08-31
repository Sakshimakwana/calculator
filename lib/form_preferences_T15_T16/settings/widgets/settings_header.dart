import 'package:flutter/material.dart';
import 'package:app_matic_tech_flutter_app/form_preferences_T15_T16/theme/form_preferance_colors.dart';

class SettingsHeader extends StatelessWidget {
  const SettingsHeader({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final isDark =
        Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 120,
      width: double.infinity,
      color: isDark
          ? AppColors.darkCard
          : AppColors.lightPink,
      alignment: Alignment.center,
      child: Text(
        'Settings',
        style: TextStyle(
          fontSize: 27,
          fontWeight: FontWeight.w700,
          color: isDark
              ? AppColors.white
              : AppColors.black,
        ),
      ),
    );
  }
}