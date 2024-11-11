import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';

class LocalizationProvider with ChangeNotifier {
  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  void setLocale(Locale locale) {
    _locale = locale;
    notifyListeners();
  }

  static Future<Map<String, String>> loadTranslations(Locale locale) async {
    final String jsonString =
        await rootBundle.loadString('assets/lang/${locale.languageCode}.json');
    return Map<String, String>.from(json.decode(jsonString));
  }
}
