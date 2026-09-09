import 'package:app_matic_tech_flutter_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:app_matic_tech_flutter_app/shoppingflow_T20/routes/shoppingflow_T20_routes.dart';

import 'Responsive_Dashboard_T22/routes/responsive_dashboard_T22_routes.dart';
import 'Responsive_Dashboard_T22/theme/responsive_dashboard_T22_colors.dart';
import 'form_preferences_T15_T16/settings/localization/app_localizations.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  // Widget build(BuildContext context) {
  //   return const MaterialApp(
  //     debugShowCheckedModeBanner: false,
  //     home: SplashScreen(), // Old SplashScreen
  //   );
  // }
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor:
        ResponsiveDashboardT22Colors.background,
        fontFamily: 'Lato',
        colorScheme: ColorScheme.fromSeed(
          seedColor: ResponsiveDashboardT22Colors.primary,
        ),
      ),
      routerConfig: responsiveDashboardT22Router,

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