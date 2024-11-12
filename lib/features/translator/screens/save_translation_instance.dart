import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';

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
  late List<String> savedTranslation;

  @override
  void initState() {
    super.initState();
    savedTranslation = widget.savedTranslations;
  }

  // Remove specific translation instance
  Future<void> _removeTranslation(int index) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      savedTranslation.removeAt(index);
    });
    await prefs.setStringList('savedTranslations', savedTranslation);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Translation removed!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Saved Translations")),
      body: savedTranslation.isEmpty
          ? const Center(child: Text("No saved translations"))
          : ListView.builder(
              itemCount: savedTranslation.length,
              itemBuilder: (context, index) {
                final instance = jsonDecode(savedTranslation[index]);
                print(instance);
                return ListTile(
                  title: Text(
                    "${instance['input']}  ->  ${instance['translate']}",
                  ),
                  trailing: IconButton(
                    icon: Image.asset(
                      'assets/icons/bin.png',
                      scale: 14,
                    ),
                    onPressed: () => _removeTranslation(index),
                    tooltip: 'Delete this translation',
                  ),
                  style: ListTileStyle.drawer,
                  //tileColor: listTileColor,
                  contentPadding: EdgeInsets.fromLTRB(16, 4, 16, 4),
                  horizontalTitleGap: 16,
                );
              },
            ),
    );
  }
}
