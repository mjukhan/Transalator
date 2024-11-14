import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'features/splash/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Locale? savedLocale =
      await loadSavedLocale(); // Load saved locale during startup
  runApp(TranslatorApp(savedLocale: savedLocale));
}

class TranslatorApp extends StatefulWidget {
  final Locale? savedLocale;

  const TranslatorApp({super.key, this.savedLocale});

  static void setLocale(BuildContext context, Locale locale) {
    _TranslatorAppState? state =
        context.findAncestorStateOfType<_TranslatorAppState>();
    state?.setLocale(locale);
  }

  @override
  State<TranslatorApp> createState() => _TranslatorAppState();
}

class _TranslatorAppState extends State<TranslatorApp> {
  Locale _locale = const Locale('en'); // Default locale

  @override
  void initState() {
    super.initState();
    if (widget.savedLocale != null) {
      _locale = widget.savedLocale!; // Set saved locale at app start
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
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
      locale: _locale, // Current locale for the app
      supportedLocales: const [
        Locale('en'),
        Locale('es'),
        Locale('fr'),
        Locale('de'),
        Locale('it'),
      ],
      home: SplashScreen(),
    );
  }
}

// Function to load saved locale from SharedPreferences
Future<Locale?> loadSavedLocale() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? languageCode = prefs.getString('locale');
  if (languageCode != null) {
    return Locale(languageCode);
  }
  return null;
}
