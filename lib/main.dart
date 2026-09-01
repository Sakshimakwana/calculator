import 'package:app_matic_tech_flutter_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'form_preferences_T15_T16/settings/localization/app_localizations.dart';
import 'form_preferences_T15_T16/theme/app_language.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Locale>(
        valueListenable: AppLanguage.locale,
        builder: (context, locale, child) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      locale: locale,

      supportedLocales: const [
        Locale('en'),
        Locale('hi'),
        Locale('gu'),
      ],

      localizationsDelegates: const [
        AppLocalizations.delegate,

        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],



      theme: ThemeData(
        fontFamily: AppLanguage.fontFamily,
      ),
      // title: 'Forms and Settings',
      //
      // theme: ThemeData(
      //   brightness: Brightness.light,
      //   fontFamily: 'Arial',
      //   colorScheme: ColorScheme.fromSeed(
      //     seedColor: const Color(0xFFFF2D68),
      //   ),
      // ),

      home: const SplashScreen(),
    );
        },
    );
  }
}