import 'package:app_matic_tech_flutter_app/modern_store_home_T24/modern_store_home_app.dart';
import 'package:app_matic_tech_flutter_app/modern_store_home_T24/modern_store_home_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'Responsive_Dashboard_T22_T23/Services_T23/Theme_T23_theme_service.dart';
import 'Responsive_Dashboard_T22_T23/routes/responsive_dashboard_T22_routes.dart';


import 'Responsive_Dashboard_T22_T23/theme_T23/Theme_T23_app_theme.dart';
import 'form_preferences_T15_T16/settings/localization/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved theme
  final bool savedDarkMode =
  await ThemeService.loadTheme();

  runApp(
    MyApp(
      initialDarkMode: savedDarkMode,
    ),
  );
}

class MyApp extends StatefulWidget {
  final bool initialDarkMode;

  const MyApp({
    super.key,
    required this.initialDarkMode,
  });

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool isDarkMode;

  @override
  void initState() {
    super.initState();

    isDarkMode = widget.initialDarkMode;
  }

  // ============================================================
  // THEME CHANGE LOGIC
  // ============================================================

  Future<void> changeTheme(bool value) async {
    setState(() {
      isDarkMode = value;
    });

    await ThemeService.saveTheme(value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,

      // ========================================================
      // LIGHT THEME
      // ========================================================

      theme: AppTheme.lightTheme,

      // ========================================================
      // DARK THEME
      // ========================================================

      darkTheme: AppTheme.darkTheme,

      // ========================================================
      // CURRENT THEME
      // ========================================================

      themeMode: isDarkMode
          ? ThemeMode.dark
          : ThemeMode.light,

      // ========================================================
      // ROUTER
      // ========================================================


      routerConfig: ModernStoreHomeRoutes.router,
      // routerConfig: responsiveDashboardT22Router(
      //   isDarkMode: isDarkMode,
      //   onThemeChanged: changeTheme,
      // ),

      // ========================================================
      // LOCALIZATION
      // ========================================================

      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      supportedLocales: const [
        Locale('en'),
      ],
    );
  }
}