import 'dart:async';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/core/widgets/permission_handler.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({
    super.key,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _person1Language = 'en';
  String _person2Language = 'es';
  String _inputText = '';
  String _translatedText = '';
  bool speaker1 = false;
  bool speaker2 = false;
  bool _isListeningPerson1 = false;
  bool _isListeningPerson2 = false;
  bool _isSpeaking = false;
  StreamSubscription? _connectivitySubscription;
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TranslationService _translationService = TranslationService();
  Timer? _debounce; // Timer for debounce mechanism
  final List<Map<String, String>> _translations = [];
  final FlutterTts _flutterTts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _person1Language = prefs.getString('person1Language') ?? 'en';
      _person2Language = prefs.getString('person2Language') ?? 'es';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('person1Language', _person1Language);
    prefs.setString('person2Language', _person2Language);
  }

  // Debounced text translation
  void _translateText(
      String inputText, bool isSpeaker1, bool isSpeaker2) async {
    //if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (!await PermissionHelper().checkWifiConnection(context)) return;

    if (inputText.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    // Debounce the translation to avoid multiple calls
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 2000), () async {
      try {
        final translation = await _translationService.translate(
          text: inputText,
          from: isSpeaker1 ? _person1Language : _person2Language,
          to: isSpeaker1 ? _person2Language : _person1Language,
        );

        setState(() {
          _translatedText = translation;

          // Add the new translation to the list
          _translations.add({
            "input": inputText,
            "translated": translation,
            "person": isSpeaker1 ? "1" : "2",
          });
          print(_translations);
        });
      } catch (e) {
        ErrorHandlerTranslating.handleTranslationError(context, e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.errorInTranslation),
          ),
        );
        setState(() {
          _translatedText = AppLocalizations.of(context)!.errorInTranslation;
        });
      }
    });
  }

  // Method to handle speech recognition for Person 1
  void _listenPerson1() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (!_isListeningPerson1) {
      if (await _speech.initialize()) {
        setState(() {
          _isListeningPerson1 = true;
          _isListeningPerson2 = false;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _inputText = val.recognizedWords;
            _controller.text = _inputText;
            speaker1 = true;
            speaker2 = false;
            _translateText(_inputText, speaker1, speaker2);
          });

          if (val.hasConfidenceRating && val.confidence > 0.5) {
            _speech.stop();
            setState(() {
              _isListeningPerson1 = false;
            });
          }
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListeningPerson1 = false;
      });
    }
  }

  // Method to handle speech recognition for Person 2
  void _listenPerson2() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (!_isListeningPerson2) {
      if (await _speech.initialize()) {
        setState(() {
          _isListeningPerson2 = true;
          _isListeningPerson1 = false;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _inputText = val.recognizedWords;
            _controller.text = _inputText;
            speaker1 = false;
            speaker2 = true;
            _translateText(_inputText, speaker1, speaker2);
          });

          if (val.hasConfidenceRating && val.confidence > 0.5) {
            _speech.stop();
            setState(() {
              _isListeningPerson2 = false;
            });
          }
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListeningPerson2 = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    if (_speech.isListening) {
      _speech.stop();
    }
    _connectivitySubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.conversation),
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
              height: size.height * 0.7,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _translations.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/empty_conversation.png',
                          scale: 4,
                        ),
                        SizedBox(height: 20),
                        Text(
                          "Start Conversation",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.yellow),
                      // ),
                      child: ListView.builder(
                        itemCount: _translations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(
                                (_translations[index]["person"] == '1')
                                    ? 0
                                    : 50,
                                0,
                                (_translations[index]["person"] == '1')
                                    ? 50
                                    : 0,
                                8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                  child: AutoSizeText(
                                    _translations[index]["input"].toString(),
                                    maxLines: null,
                                    maxFontSize: 24,
                                    minFontSize: 16,
                                  ),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => _handleTextToSpeech(
                                          _translations[index]["input"]
                                              .toString(),
                                          _person1Language),
                                      icon: Icon(Icons.volume_up),
                                    ),
                                  ],
                                ),
                                _translations.isNotEmpty
                                    ? Divider(
                                        indent: 32,
                                        endIndent: 32,
                                      )
                                    : SizedBox.shrink(),
                                // Translated Text Container
                                _translations.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: AutoSizeText(
                                          _translations[index]['translated']
                                              .toString(),
                                          maxLines: null,
                                          maxFontSize: 24,
                                          minFontSize: 16,
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.star_border),
                                      onPressed: () {},
                                    ),
                                    IconButton(
                                      onPressed: () => _handleTextToSpeech(
                                          _translations[index]["translated"]
                                              .toString(),
                                          _person2Language),
                                      icon: Icon(Icons.volume_up),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: borderColor),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person1Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            // Update source language
                            _person1Language = newLang;
                            _translations.clear();
                          });
                          _saveLanguagePreferences();
                        },
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap: _listenPerson1,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: micColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(
                          _isListeningPerson1 ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: borderColor),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person2Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            // Update target language
                            _person2Language = newLang;
                            _translations.clear();
                          });
                          _saveLanguagePreferences();
                        },
                        fontSize: 14,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          _listenPerson2, // Call the listen method for person 2
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: borderColor),
                            color: micColor),
                        child: Icon(
                          _isListeningPerson2 ? Icons.mic : Icons.mic_none,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTextToSpeech(String text, String languageCode) async {
    if (_isSpeaking) {
      await _flutterTts.stop(); // Stop speaking if already speaking
      setState(() {
        _isSpeaking = false;
      });
      return;
    }

    if (text.isNotEmpty) {
      setState(() {
        _isSpeaking = true; // Start speaking state
      });

      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      // Speak the text and handle completion
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false; // Reset to original icon when speech completes
        });
      });

      _flutterTts.setErrorHandler((error) {
        setState(() {
          _isSpeaking = false; // Reset on error
        });
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Please enter some text to speak."),
        ),
      );
    }
  }
}
