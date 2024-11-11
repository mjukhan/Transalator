import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'app_localization.dart';
import 'localization_provider.dart';

class AppLanguage extends StatefulWidget {
  const AppLanguage({super.key});

  @override
  State<AppLanguage> createState() => _AppLanguageState();
}

class _AppLanguageState extends State<AppLanguage> {
  final List<String> languages = [
    'English',
    'Spanish',
    'French',
    'German',
    'Italian'
  ];
  final List<String> langIcons = [
    'assets/icons/eng.png',
    'assets/icons/spainish.png',
    'assets/icons/french.png',
    'assets/icons/german.png',
    'assets/icons/italian.png'
  ];
  String? selectedLanguage = 'English';

  void _onLanguageChanged(String language, Locale locale) {
    setState(() {
      selectedLanguage = language;
    });
    Provider.of<LocalizationProvider>(context, listen: false).setLocale(locale);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.translate('app_title') ??
            'App Languages'),
        actions: [
          IconButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(AppLocalizations.of(context)
                            ?.translate('language_changed') ??
                        'Language changed')),
              );
            },
            icon: Icon(Icons.check, color: Colors.green),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: languages.length,
        itemBuilder: (context, index) {
          Locale locale;
          switch (languages[index]) {
            case 'Spanish':
              locale = Locale('es');
              break;
            case 'French':
              locale = Locale('fr');
              break;
            case 'German':
              locale = Locale('de');
              break;
            case 'Italian':
              locale = Locale('it');
              break;
            default:
              locale = Locale('en');
          }
          return ListTile(
            leading: Image.asset(langIcons[index], scale: 12),
            title: Text(languages[index], style: TextStyle(fontSize: 16)),
            trailing: selectedLanguage == languages[index]
                ? Icon(Icons.check, color: Colors.green)
                : null,
            onTap: () => _onLanguageChanged(languages[index], locale),
          );
        },
      ),
    );
  }
}
