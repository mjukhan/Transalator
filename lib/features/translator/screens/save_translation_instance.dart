import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SavedTranslationsPage extends StatefulWidget {
  final List<String> savedTranslations;

  const SavedTranslationsPage({
    super.key,
    required this.savedTranslations,
  });

  @override
  _SavedTranslationsPageState createState() => _SavedTranslationsPageState();
}

class _SavedTranslationsPageState extends State<SavedTranslationsPage> {
  late List<String> _savedTranslations;

  @override
  void initState() {
    super.initState();
    _savedTranslations = widget.savedTranslations;
  }

  // Remove specific translation instance
  Future<void> _removeTranslation(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedTranslations.removeAt(index);
    });
    await prefs.setStringList('savedTranslations', _savedTranslations);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translation removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Translations")),
      body: _savedTranslations.isEmpty
          ? const Center(child: Text("No saved translations"))
          : ListView.builder(
              itemCount: _savedTranslations.length,
              itemBuilder: (context, index) {
                final instance = jsonDecode(_savedTranslations[index]);
                return ListTile(
                  title: Text("Input: ${instance['inputText']}"),
                  subtitle: Text("Translation: ${instance['translatedText']}"),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _removeTranslation(index),
                    tooltip: 'Delete this translation',
                  ),
                );
              },
            ),
    );
  }
}
