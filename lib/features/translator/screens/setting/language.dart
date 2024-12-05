import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/main.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class AppLanguage extends StatefulWidget {
  const AppLanguage({super.key});

  @override
  State<AppLanguage> createState() => _AppLanguageState();
}

class _AppLanguageState extends State<AppLanguage> {
  final Map<String, String> languages = {
    'English': 'en',
    'Spanish': 'es',
    'French': 'fr',
    'German': 'de',
    'Italian': 'it',
    'Afrikaans': 'af',
    'Arabic': 'ar',
    'Bengali': 'bn',
    'Czech': 'cs',
    'Danish': 'da',
    'Filipino': 'fil',
    'Hindi': 'hi',
  };

  final List<String> langIcons = [
    'assets/icons/eng.png', // English
    'assets/icons/spanish.png', // Spanish
    'assets/icons/french.png', // French
    'assets/icons/german.png', // German
    'assets/icons/italian.png', // Italian
    'assets/icons/afrikaans.png', // Afrikaans
    'assets/icons/arabic.png', // Arabic
    'assets/icons/bengali.png', // Bengali
    'assets/icons/czech.png', // Czech
    'assets/icons/danish.png', // Danish
    'assets/icons/filipino.png', // Filipino
    'assets/icons/hindi.png', // Hindi
  ];

  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage(); // Load saved language on initialization
  }

  // Future<void> _loadSavedLanguage() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? languageCode = prefs.getString('locale');
  //   if (languageCode == null || !languages.containsValue(languageCode)) {
  //     setState(() {
  //       selectedLanguage =
  //           languages.entries
  //               .firstWhere((entry) => entry.value == languageCode)
  //               .key;
  //     });
  //   }
  // }
  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('locale');

    setState(() {
      if (languageCode != null && languages.containsValue(languageCode)) {
        // Load saved language if it exists and is valid
        selectedLanguage = languages.entries
            .firstWhere((entry) => entry.value == languageCode)
            .key;
      } else {
        // Default to English if no saved language or invalid language code
        selectedLanguage = 'English';
        prefs.setString(
          'locale',
          languages['English']!,
        ); // Save default language
      }
    });
  }

  void _onLanguageChanged(String language) async {
    setState(() {
      selectedLanguage = language;
    });

    // Save the selected language to SharedPreferences
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('locale', languages[language]!);

    // Update the app’s locale globally
    TranslatorApp.setLocale(context, Locale(languages[language]!));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${AppLocalizations.of(context)!.languageChangedTo} $selectedLanguage',
        ),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.appLanguage),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          String language = languages.keys.elementAt(index);
          return Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(8),
              color: Colors.white,
            ),
            child: ListTile(
              leading: SizedBox(
                height: 32,
                width: 32,
                child: Image.asset(langIcons[index]),
              ),
              title: Text(language, style: const TextStyle(fontSize: 16)),
              trailing: selectedLanguage == language
                  ? Icon(Icons.check_circle_rounded, color: micColor)
                  : Icon(Icons.check_circle_outline_rounded),
              onTap: () => _onLanguageChanged(language),
            ),
          );
        },
      ),
    );
  }
}
