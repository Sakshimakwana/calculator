import 'package:flutter/material.dart';

class AppLanguage {
  static final ValueNotifier<Locale> locale =
  ValueNotifier(const Locale('en'));

  static void changeLanguage(String languageCode) {
    locale.value = Locale(languageCode);
  }

  static String get fontFamily {
    switch (locale.value.languageCode) {
      case 'gu':
        return 'NotoSansGujarati';

      case 'hi':
        return 'NotoSansDevanagari';

      case 'en':
      default:
        return 'ArialMTStditalic';
    }
  }
}