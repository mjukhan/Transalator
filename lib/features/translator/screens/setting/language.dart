import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  };

  final List<String> langIcons = [
    'assets/icons/eng.png',
    'assets/icons/spainish.png',
    'assets/icons/french.png',
    'assets/icons/german.png',
    'assets/icons/italian.png',
  ];

  String? selectedLanguage;

  @override
  void initState() {
    super.initState();
    _loadSavedLanguage(); // Load saved language on initialization
  }

  Future<void> _loadSavedLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? languageCode = prefs.getString('locale');
    if (languageCode != null) {
      setState(() {
        selectedLanguage = languages.entries
            .firstWhere((entry) => entry.value == languageCode)
            .key;
      });
    }
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
              '${AppLocalizations.of(context)!.languageChangedTo} $selectedLanguage')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.appLanguages),
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          String language = languages.keys.elementAt(index);
          return ListTile(
            leading: Image.asset(langIcons[index], scale: 12),
            title: Text(language, style: const TextStyle(fontSize: 16)),
            trailing: selectedLanguage == language
                ? const Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _onLanguageChanged(language),
          );
        },
      ),
    );
  }
}
