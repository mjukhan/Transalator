import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translation_app/core/utilities/colors.dart';

// Language Selector widget
class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;
  final double fontSize;

  const LanguageSelector({
    super.key,
    required this.selectedLanguage,
    required this.onLanguageChanged,
    required this.fontSize,
  });

  List<Map<String, String>> getLanguageOptions(BuildContext context) {
    return [
      {'value': 'en', 'label': AppLocalizations.of(context)!.english},
      {'value': 'es', 'label': AppLocalizations.of(context)!.spanish},
      {'value': 'fr', 'label': AppLocalizations.of(context)!.french},
      {'value': 'it', 'label': AppLocalizations.of(context)!.italian},
      {'value': 'de', 'label': AppLocalizations.of(context)!.german},
      {'value': 'nl', 'label': AppLocalizations.of(context)!.dutch},
      {'value': 'hu', 'label': AppLocalizations.of(context)!.hungarian},
      {'value': 'ro', 'label': AppLocalizations.of(context)!.romanian},
      {'value': 'fil', 'label': AppLocalizations.of(context)!.filipino},
      {'value': 'cs', 'label': AppLocalizations.of(context)!.czech},
      {'value': 'ar', 'label': AppLocalizations.of(context)!.arabic},
      {'value': 'af', 'label': AppLocalizations.of(context)!.afrikaans},
      {'value': 'hi', 'label': AppLocalizations.of(context)!.hindi},
      {'value': 'ja', 'label': AppLocalizations.of(context)!.japanese},
      {'value': 'ko', 'label': AppLocalizations.of(context)!.korean},
      {'value': 'pt', 'label': AppLocalizations.of(context)!.portuguese},
      {'value': 'zh', 'label': AppLocalizations.of(context)!.chinese},
      {'value': 'ru', 'label': AppLocalizations.of(context)!.russian},
      {'value': 'tr', 'label': AppLocalizations.of(context)!.turkish},
      {'value': 'pl', 'label': AppLocalizations.of(context)!.polish},
      {'value': 'sw', 'label': AppLocalizations.of(context)!.swahili},
      {'value': 'ta', 'label': AppLocalizations.of(context)!.tamil},
      {'value': 'bn', 'label': AppLocalizations.of(context)!.bengali},
      {'value': 'th', 'label': AppLocalizations.of(context)!.thai},
      {'value': 'vi', 'label': AppLocalizations.of(context)!.vietnamese},
      {
        'value': 'ms',
        'label': AppLocalizations.of(context)!.malay
      }, // Added Malay
      {
        'value': 'ml',
        'label': AppLocalizations.of(context)!.malayalam
      }, // Added Malayalam
      {
        'value': 'ne',
        'label': AppLocalizations.of(context)!.nepali
      }, // Added Nepali
      {
        'value': 'sr',
        'label': AppLocalizations.of(context)!.serbian
      }, // Added Serbian
      {
        'value': 'sq',
        'label': AppLocalizations.of(context)!.albanian
      }, // Added Albanian
      {
        'value': 'iw',
        'label': AppLocalizations.of(context)!.hebrew
      }, // Added Hebrew
      {
        'value': 'yu',
        'label': AppLocalizations.of(context)!.croatian
      }, // Added Croatian
      {
        'value': 'uz',
        'label': AppLocalizations.of(context)!.uzbek
      }, // Added Uzbek
      {
        'value': 'ka',
        'label': AppLocalizations.of(context)!.georgian
      }, // Added Georgian
      {
        'value': 'hy',
        'label': AppLocalizations.of(context)!.armenian
      }, // Added Armenian
      {
        'value': 'km',
        'label': AppLocalizations.of(context)!.khmer
      }, // Added Khmer
      {
        'value': 'la',
        'label': AppLocalizations.of(context)!.latin
      }, // Added Latin
      {
        'value': 'cy',
        'label': AppLocalizations.of(context)!.welsh
      }, // Added Welsh
      {
        'value': 'eu',
        'label': AppLocalizations.of(context)!.basque
      }, // Added Basque
      {
        'value': 'is',
        'label': AppLocalizations.of(context)!.icelandic
      }, // Added Icelandic
      {
        'value': 'bs',
        'label': AppLocalizations.of(context)!.bosnian
      }, // Added Bosnian
    ];
  }

  @override
  Widget build(BuildContext context) {
    // Find the label of the selected language or fallback to a default
    String selectedLanguageLabel = getLanguageOptions(context).firstWhere(
      (lang) => lang['value'] == selectedLanguage,
      orElse: () => {
        'value': 'en',
        'label': AppLocalizations.of(context)!.english
      }, // Default language
    )['label']!;

    return GestureDetector(
      onTap: () {
        // Show modal bottom sheet
        showModalBottomSheet(
          backgroundColor: bgColor,
          context: context,
          isScrollControlled: true, // Allow for scrollable content
          builder: (context) {
            return Container(
              padding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
              height: MediaQuery.of(context).size.height *
                  0.8, // 80% height of the screen
              child: Column(
                children: [
                  SizedBox(height: 10),
                  // Drag handle - a small indicator at the top
                  Container(
                    height: 5.0,
                    width: 40.0,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          "Select Language",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: micColor,
                          ),
                        ),
                      )),

                  // Expanded widget allows the list to take the available space
                  Expanded(
                    child: SingleChildScrollView(
                      child: Column(
                        children: getLanguageOptions(context).map((lang) {
                          return Container(
                            decoration: BoxDecoration(
                              color: lang['value'] == selectedLanguage
                                  ? micColor
                                  : bgColor,
                              borderRadius: BorderRadius.circular(
                                  16), // Set border radius here
                            ),
                            margin: EdgeInsets.symmetric(
                                vertical:
                                    4), // Optional: Add some margin for spacing
                            child: ListTile(
                              title: Text(
                                lang['label']!, // Language label
                                style: TextStyle(
                                  color: lang['value'] == selectedLanguage
                                      ? Colors.white
                                      : null, // Optional: Text color change
                                ),
                              ),
                              trailing: lang['value'] == selectedLanguage
                                  ? Icon(Icons.check,
                                      color: Colors.white) // Icon for selected
                                  : null,
                              onTap: () {
                                onLanguageChanged(lang[
                                    'value']!); // Update the selected language
                                Navigator.pop(context); // Close the modal
                              },
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Text(
        selectedLanguageLabel, // Show the selected language label here
        style: TextStyle(fontSize: fontSize),
      ),
    );
  }
}
