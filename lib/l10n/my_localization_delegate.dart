import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spons/l10n/my_localization.dart';

class MyLocalizationDelegate extends LocalizationsDelegate<MyLocalization> {
  final Locale locale;

  const MyLocalizationDelegate(this.locale);

  get currentLocale => locale;

  @override
  bool isSupported(Locale locale) {
    return ['en', 'id'].contains(locale.languageCode);
  }

  @override
  Future<MyLocalization> load(Locale locale) {
    return MyLocalization.load(locale);
  }

  @override
  bool shouldReload(LocalizationsDelegate<MyLocalization> old) {
    return false;
  }

  Future<void> saveNewLocale(Locale locale) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('languageCode', locale.languageCode);
  }
}
