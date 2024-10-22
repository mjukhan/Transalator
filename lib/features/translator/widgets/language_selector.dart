import 'package:flutter/material.dart';

class LanguageSelector extends StatelessWidget {
  final String selectedLanguage;
  final Function(String) onLanguageChanged;

  LanguageSelector(
      {required this.selectedLanguage, required this.onLanguageChanged});

  @override
  Widget build(BuildContext context) {
    // List of available language codes and names
    List<Map<String, String>> languageOptions = [
      {'value': 'en', 'label': 'English (US)'},
      {'value': 'ur', 'label': 'Urdu (PK)'},
      {'value': 'es', 'label': 'Spanish (ES)'},
      {'value': 'fr', 'label': 'French (FR)'},
      {'value': 'de', 'label': 'German (DE)'},
      {'value': 'zh', 'label': 'Chinese (Simplified)'},
      {'value': 'ar', 'label': 'Arabic'},
      {'value': 'hi', 'label': 'Hindi'},
      {'value': 'pt', 'label': 'Portuguese'},
      {'value': 'ja', 'label': 'Japanese'},
      {'value': 'ko', 'label': 'Korean'},
      {'value': 'it', 'label': 'Italian'},
      {'value': 'ru', 'label': 'Russian'},
      {'value': 'tr', 'label': 'Turkish'},
      {'value': 'fa', 'label': 'Persian (Farsi)'},
      {'value': 'pl', 'label': 'Polish'},
      {'value': 'th', 'label': 'Thai'},
      {'value': 'vi', 'label': 'Vietnamese'},
      {'value': 'nl', 'label': 'Dutch'},
      {'value': 'sv', 'label': 'Swedish'},
      {'value': 'no', 'label': 'Norwegian'},
      {'value': 'fi', 'label': 'Finnish'},
      {'value': 'da', 'label': 'Danish'},
      {'value': 'cs', 'label': 'Czech'},
      {'value': 'hu', 'label': 'Hungarian'},
      {'value': 'ro', 'label': 'Romanian'},
      {'value': 'sk', 'label': 'Slovak'},
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
        if (newValue != null) {
          onLanguageChanged(
              newValue); // Pass the new value to the parent widget
        }
      },
      isExpanded: true, // Expands to fit available width
      underline: Container(
        height: 1,
        color:
            Color.fromARGB(255, 42, 157, 143), // Customize the underline color
      ),
      style: TextStyle(
        color: Colors.black,
        fontSize: 16,
      ), // Customize text style
      dropdownColor: Colors.white, // Customize dropdown background color
    );
  }
}
