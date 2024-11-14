import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedTranslationsPage extends StatefulWidget {
  final List<String> savedTranslations; // Parameter for initial translations

  const SavedTranslationsPage({
    super.key,
    required this.savedTranslations,
  });

  @override
  _SavedTranslationsPageState createState() => _SavedTranslationsPageState();
}

class _SavedTranslationsPageState extends State<SavedTranslationsPage> {
  List<String> savedTranslations = [];

  @override
  void initState() {
    super.initState();
    _initializeTranslations(); // Initialize translations on page load
  }

  // Initialize translations with the initial list, save if empty
  Future<void> _initializeTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    savedTranslations = prefs.getStringList('savedTranslations') ?? [];

    // If savedTranslations is empty, populate with initialTranslations and save
    if (savedTranslations.isEmpty) {
      savedTranslations = widget.savedTranslations;
      await prefs.setStringList('savedTranslations', savedTranslations);
    }

    setState(() {}); // Update UI after loading translations
  }

  // Save current list of translations to SharedPreferences
  Future<void> _saveTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('savedTranslations', savedTranslations);
  }

  // Remove specific translation instance and update SharedPreferences
  Future<void> _removeTranslation(int index) async {
    setState(() {
      savedTranslations.removeAt(index);
    });
    await _saveTranslations();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translation removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Translations")),
      body: savedTranslations.isEmpty
          ? const Center(child: Text("No saved translations"))
          : ListView.builder(
              itemCount: savedTranslations.length,
              itemBuilder: (context, index) {
                final instance = jsonDecode(savedTranslations[index]);
                return ListTile(
                  title: Text(
                    "${instance['input']}  ->  ${instance['translate']}",
                  ),
                  subtitle:
                      Text('${instance['source']} -> ${instance['target']}'),
                  trailing: IconButton(
                    icon: Image.asset(
                      'assets/icons/bin.png',
                      scale: 14,
                    ),
                    onPressed: () => _removeTranslation(index),
                    tooltip: 'Delete this translation',
                  ),
                  style: ListTileStyle.drawer,
                  contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  horizontalTitleGap: 16,
                );
              },
            ),
    );
  }
}
