import 'package:flutter/material.dart';
import 'features/splash/splash_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(TranslatorApp());
}

class TranslatorApp extends StatefulWidget {
  TranslatorApp({super.key});

  static void setLocale(BuildContext context, Locale locale) {
    _TranslatorAppState state =
        context.findAncestorStateOfType<_TranslatorAppState>()!;
    state.setLocale(locale);
  }

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  Locale _locale = const Locale('en'); // Default locale

  // Function to update the locale
  void setLocale(Locale locale) {
    setState(() {
      _locale = locale; // Update the locale
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: _locale, // Set the current locale here
      supportedLocales: const [
        Locale('en'), // English
        Locale('es'), // Spanish
        Locale('fr'), // French
        Locale('de'), // German
        Locale('it'), // Italian
      ],
      home: SplashScreen(),
    );
  }
}
