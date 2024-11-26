import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/translator/screens/setting/view_favorite_translation/view_favorite_translation.dart';
import 'package:translation_app/features/translator/screens/translation_screen.dart';

class SavedTranslationsPage extends StatefulWidget {
  final List<String> savedTranslations; // Parameter for initial translations

  const SavedTranslationsPage({super.key, required this.savedTranslations});

  @override
  _SavedTranslationsPageState createState() => _SavedTranslationsPageState();
}

class _SavedTranslationsPageState extends State<SavedTranslationsPage> {
  List<String> savedTranslations = [];
  final FlutterTts _flutterTts = FlutterTts();

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
      SnackBar(content: Text(AppLocalizations.of(context)!.translationRemoved)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.favoriteTranslations),
      ),
      body:
          savedTranslations.isEmpty
              ? Center(
                child: Text(AppLocalizations.of(context)!.noSavedTranslations),
              )
              : ListView.builder(
                itemCount: savedTranslations.length,
                itemBuilder: (context, index) {
                  final instance = jsonDecode(savedTranslations[index]);

                  return Container(
                    margin: EdgeInsets.all(16),
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: bgColor,
                      border: Border.all(color: borderColor),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "${instance['input']}",
                          style: TextStyle(overflow: TextOverflow.fade),
                        ),
                        SizedBox(height: 10),
                        Divider(endIndent: 100, indent: 100),
                        SizedBox(height: 10),
                        Text(
                          '${instance['translate']}',
                          style: TextStyle(overflow: TextOverflow.fade),
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: Icon(Icons.delete_outline),
                              onPressed: () => _removeTranslation(index),
                              tooltip:
                                  AppLocalizations.of(
                                    context,
                                  )!.deleteThisTranslation,
                            ),
                            IconButton(
                              icon: Icon(Icons.volume_up),
                              onPressed:
                                  () => _handleTextToSpeech(
                                    instance['translate'],
                                    instance['source'],
                                  ),
                              tooltip: 'Speak',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                  // return ListTile(
                  //   title: Text(
                  //     "${instance['input']}",
                  //     style: TextStyle(overflow: TextOverflow.fade),
                  //     maxLines: 1,
                  //   ),
                  //   subtitle: Text(
                  //     '${instance['translate']}',
                  //     style: TextStyle(overflow: TextOverflow.fade),
                  //     maxLines: 1,
                  //   ),
                  //   trailing: IconButton(
                  //     icon: Image.asset('assets/icons/bin.png', scale: 14),
                  //     onPressed: () => _removeTranslation(index),
                  //     tooltip:
                  //         AppLocalizations.of(context)!.deleteThisTranslation,
                  //   ),
                  //   style: ListTileStyle.drawer,
                  //   contentPadding: const EdgeInsets.fromLTRB(16, 4, 16, 4),
                  //   horizontalTitleGap: 16,
                  //   onTap: () {
                  //     Navigator.push(
                  //       context,
                  //       MaterialPageRoute(
                  //         builder:
                  //             (context) => ViewFavoriteTranslation(
                  //               text1: instance['input'],
                  //               text2: instance['translate'],
                  //             ),
                  //       ),
                  //     );
                  //   },
                  // );
                },
              ),
    );
  }

  Future<void> _handleTextToSpeech(String text, String languageCode) async {
    if (text.isNotEmpty) {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      // Speak the text and handle completion
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {});

      _flutterTts.setErrorHandler((error) {});
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some text to speak.")),
      );
    }
  }
}
