import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translation_app/core/utilities/colors.dart';

class Favorite extends StatefulWidget {
  final List<String> savedTranslations;

  const Favorite({super.key, required this.savedTranslations});

  @override
  _FavoriteState createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  List<String> savedTranslations = [];
  final FlutterTts _flutterTts = FlutterTts();
  late bool _isSpeaking = false;

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
      SnackBar(
        content: Text(AppLocalizations.of(context)!.translationRemoved),
        duration: Durations.short3,
      ),
    );
  }

  Future<void> _handleTextToSpeech(String text, String languageCode) async {
    setState(() {
      _isSpeaking = false;
    });

    if (text.isNotEmpty) {
      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      setState(() {
        _isSpeaking = true; // Start speaking state
      });

      // Speak the text and handle completion
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setErrorHandler((error) {
        setState(() {
          _isSpeaking = false;
        });
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Empty Text")));
    }
  }

  void _stop_tts() {
    _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        elevation: 0,
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
                      color: Colors.white,
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
                              icon: Icon(Icons.star, color: Colors.yellow),
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
                                    instance['target'],
                                  ),
                              tooltip: 'Speak',
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
    );
  }
}
