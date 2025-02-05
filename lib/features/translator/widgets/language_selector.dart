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
        {'value': 'af', 'label': AppLocalizations.of(context)!.afrikaans},
        {'value': 'sq', 'label': AppLocalizations.of(context)!.albanian},
        {'value': 'ar', 'label': AppLocalizations.of(context)!.arabic},
        {'value': 'hy', 'label': AppLocalizations.of(context)!.armenian},
        {'value': 'eu', 'label': AppLocalizations.of(context)!.basque},
        {'value': 'bn', 'label': AppLocalizations.of(context)!.bengali},
        {'value': 'bs', 'label': AppLocalizations.of(context)!.bosnian},
        {'value': 'cs', 'label': AppLocalizations.of(context)!.czech},
        {'value': 'nl', 'label': AppLocalizations.of(context)!.dutch},
        {'value': 'en', 'label': AppLocalizations.of(context)!.english},
        {'value': 'fil', 'label': AppLocalizations.of(context)!.filipino},
        {'value': 'fr', 'label': AppLocalizations.of(context)!.french},
        {'value': 'ka', 'label': AppLocalizations.of(context)!.georgian},
        {'value': 'de', 'label': AppLocalizations.of(context)!.german},
        {'value': 'iw', 'label': AppLocalizations.of(context)!.hebrew},
        {'value': 'hi', 'label': AppLocalizations.of(context)!.hindi},
        {'value': 'hu', 'label': AppLocalizations.of(context)!.hungarian},
        {'value': 'is', 'label': AppLocalizations.of(context)!.icelandic},
        {'value': 'it', 'label': AppLocalizations.of(context)!.italian},
        {'value': 'ja', 'label': AppLocalizations.of(context)!.japanese},
        {'value': 'km', 'label': AppLocalizations.of(context)!.khmer},
        {'value': 'ko', 'label': AppLocalizations.of(context)!.korean},
        {'value': 'la', 'label': AppLocalizations.of(context)!.latin},
        {'value': 'ml', 'label': AppLocalizations.of(context)!.malayalam},
        {'value': 'ms', 'label': AppLocalizations.of(context)!.malay},
        {'value': 'ne', 'label': AppLocalizations.of(context)!.nepali},
        {'value': 'pl', 'label': AppLocalizations.of(context)!.polish},
        {'value': 'pt', 'label': AppLocalizations.of(context)!.portuguese},
        {'value': 'ro', 'label': AppLocalizations.of(context)!.romanian},
        {'value': 'ru', 'label': AppLocalizations.of(context)!.russian},
        {'value': 'sr', 'label': AppLocalizations.of(context)!.serbian},
        {'value': 'es', 'label': AppLocalizations.of(context)!.spanish},
        {'value': 'sw', 'label': AppLocalizations.of(context)!.swahili},
        {'value': 'ta', 'label': AppLocalizations.of(context)!.tamil},
        {'value': 'th', 'label': AppLocalizations.of(context)!.thai},
        {'value': 'tr', 'label': AppLocalizations.of(context)!.turkish},
        {'value': 'uz', 'label': AppLocalizations.of(context)!.uzbek},
        {'value': 'vi', 'label': AppLocalizations.of(context)!.vietnamese},
        {'value': 'cy', 'label': AppLocalizations.of(context)!.welsh},
        {'value': 'yu', 'label': AppLocalizations.of(context)!.croatian}

    ];
  }

  @override
  Widget build(BuildContext context) {
    String selectedLanguageLabel = getLanguageOptions(context).firstWhere(
      (lang) => lang['value'] == selectedLanguage,
      orElse: () =>
          {'value': 'en', 'label': AppLocalizations.of(context)!.english},
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
