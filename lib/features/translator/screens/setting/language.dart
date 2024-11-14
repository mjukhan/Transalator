import 'package:flutter/material.dart';
import 'package:translation_app/features/splash/splash_screen.dart';
import 'package:translation_app/home.dart';
import 'package:translation_app/main.dart';

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

  String? selectedLanguage = 'English';

  void _onLanguageChanged(String language) {
    setState(() {
      selectedLanguage = language;
    });

    // Call the function to change locale globally
    changeLocale(language);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Language changed to $selectedLanguage')),
    );
  }

  // Function to update locale and notify the app
  void changeLocale(String language) {
    Locale locale = Locale(languages[language]!);

    // Update the locale globally
    TranslatorApp.setLocale(context, locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Languages'),
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
