import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  Widget build(BuildContext context) {
    // List of available language codes and names
    List<Map<String, String>> languageOptions = [
      {'value': 'en', 'label': AppLocalizations.of(context)!.english},
      {'value': 'es', 'label': AppLocalizations.of(context)!.spanish},
      {'value': 'fr', 'label': AppLocalizations.of(context)!.french},
      {'value': 'it', 'label': AppLocalizations.of(context)!.italian},
      {'value': 'de', 'label': AppLocalizations.of(context)!.german},
      {'value': 'nl', 'label': AppLocalizations.of(context)!.dutch},
      {'value': 'hu', 'label': AppLocalizations.of(context)!.hungarian},
      {'value': 'ro', 'label': AppLocalizations.of(context)!.romanian},
      // Add more languages here
    ];

    // Create DropdownMenuItems from the language options
    List<DropdownMenuItem<String>> dropdownItems = languageOptions.map((lang) {
      return DropdownMenuItem<String>(
        value: lang['value'], // This is how you're getting the value
        child: Text(
          lang['label']!,
          textAlign: TextAlign.center,
        ), // This is the display text
      );
    }).toList();

    // Check if selectedLanguage exists in dropdownItems, default to 'en' if not
    final String defaultLanguage = 'en';
    final String dropdownValue =
        dropdownItems.any((item) => item.value == selectedLanguage)
            ? selectedLanguage
            : defaultLanguage;

    return DropdownButton<String>(
      value: dropdownValue,
      items: dropdownItems,
      onChanged: (newValue) {
        if (newValue != null) {
          onLanguageChanged(newValue);
        }
      },
      isExpanded: true,
      underline: SizedBox.shrink(),
      icon: SizedBox.shrink(),
      style: TextStyle(
        color: Colors.black,
        fontSize: fontSize,
      ),
      dropdownColor: Colors.white,
    );
  }
}
