import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spons/l10n/my_localization.dart';

import '../l10n/my_localization_delegate.dart';

class Languanges extends StatefulWidget {
  const Languanges({super.key});

  @override
  State<Languanges> createState() => _LanguangesState();
}

class _LanguangesState extends State<Languanges> {
  SharedPreferences? prefs;
  MyLocalizationDelegate _myLocalizationDelegate =
      MyLocalizationDelegate(Locale('null'));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyLocalization.of(context)!.languangeWords),
      ),
      body: Column(
        children: [
          RadioListTile<String>(
            title: const Text('English'),
            value: 'en',
            groupValue: _myLocalizationDelegate.currentLocale.languageCode,
            onChanged: (String? value) {
              setState(() {
                Locale newLocale = Locale(value!, 'US');
                MyLocalization.load(newLocale);
                _myLocalizationDelegate = MyLocalizationDelegate(newLocale);
                _myLocalizationDelegate.saveNewLocale(newLocale);
              });
            },
          ),
          RadioListTile<String>(
            title: const Text('Indonesia'),
            value: 'id',
            groupValue: _myLocalizationDelegate.currentLocale.languageCode,
            onChanged: (String? value) {
              setState(() {
                Locale newLocale = Locale(value!, 'ID');
                MyLocalization.load(newLocale);
                _myLocalizationDelegate = MyLocalizationDelegate(newLocale);
                _myLocalizationDelegate.saveNewLocale(newLocale);
              });
            },
          ),
        ],
      ),
    );
  }
}
