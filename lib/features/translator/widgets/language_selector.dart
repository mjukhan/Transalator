import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  LanguageSelector({required this.selectedLanguage, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    // List of available language codes and names
    List<Map<String, String>> languageOptions = [
      {'value': 'en', 'label': 'English (US)'},
      {'value': 'ur', 'label': 'Urdu (PK)'},
      // Add more languages here
    ];

    // Create DropdownMenuItems from the language options
    List<DropdownMenuItem<String>> dropdownItems = languageOptions.map((lang) {
      return DropdownMenuItem<String>(
        value: lang['value'],
        child: Text(lang['label']!),
      );
    }).toList();

    return DropdownButton<String>(
      value: selectedLanguage, // Ensure this value exists in the dropdownItems
      items: dropdownItems,
      onChanged: (newValue) {
        onLanguageChanged(newValue!); // Pass the new value to the parent widget
      },
    );
  }
}
