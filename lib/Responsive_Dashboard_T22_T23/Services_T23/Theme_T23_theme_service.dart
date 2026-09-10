import 'package:shared_preferences/shared_preferences.dart';

class ThemeService {
  ThemeService._();

  static const String _themeKey =
      'responsive_dashboard_theme_mode';

  // ============================================================
  // SAVE THEME
  // ============================================================

  static Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setBool(
      _themeKey,
      isDark,
    );
  }

  // ============================================================
  // LOAD THEME
  // ============================================================

  static Future<bool> loadTheme() async {
    final prefs = await SharedPreferences.getInstance();

    return prefs.getBool(_themeKey) ?? false;
  }

  // ============================================================
  // CLEAR THEME
  // ============================================================

  static Future<void> clearTheme() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.remove(_themeKey);
  }
}