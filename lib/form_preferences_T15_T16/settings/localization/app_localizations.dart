import 'package:flutter/material.dart';

import 'en.dart';
import 'hi.dart';
import 'gu.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(
      context,
      AppLocalizations,
    )!;
  }

  String get(String key) {
    switch (locale.languageCode) {
      case 'hi':
        return hi[key] ?? en[key] ?? key;

      case 'gu':
        return gu[key] ?? en[key] ?? key;

      default:
        return en[key] ?? key;
    }
  }

  static const delegate = AppLocalizationsDelegate();
}

class AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'hi', 'gu'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(
      covariant AppLocalizationsDelegate old,
      ) {
    return false;
  }
}