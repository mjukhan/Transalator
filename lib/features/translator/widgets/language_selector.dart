import 'package:flutter/material.dart';

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
      {'value': 'en', 'label': 'English'},
      {'value': 'es', 'label': 'Spanish'},
      {'value': 'fr', 'label': 'French)'},
      {'value': 'de', 'label': 'German'},
      {'value': 'nl', 'label': 'Dutch'},
      {'value': 'cs', 'label': 'Czech'},
      {'value': 'hu', 'label': 'Hungarian'},
      {'value': 'ro', 'label': 'Romanian'},
      {'value': 'sk', 'label': 'Slovak'},
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
