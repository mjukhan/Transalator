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

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key,});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _person1Language = 'auto';
  String _person2Language = 'auto';
  String _inputText = '';
  String _translatedText = '';
  bool speaker1 = false;
  bool speaker2 = false;
  bool _isListeningPerson1 = false;
  bool _isListeningPerson2 = false;
  StreamSubscription? _connectivitySubscription;
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TranslationService _translationService = TranslationService();
  Timer? _debounce; // Timer for debounce mechanism

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _person1Language = prefs.getString('person1Language') ?? 'auto';
      _person2Language = prefs.getString('person2Language') ?? 'auto';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('person1Language', _person1Language);
    prefs.setString('person2Language', _person2Language);
  }

  // Debounced text translation
  void _translateText(String inputText, bool speaker1, bool speaker2) async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (!await PermissionHelper().checkWifiConnection(context)) return;
    if (inputText.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    // Debounce the translation to avoid multiple calls
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      try {
        final translation = await _translationService.translate(
          text: inputText,
          from: speaker1 ? _person1Language : _person2Language,
          to: speaker1 ? _person2Language : _person1Language,
        );
        setState(() {
          _translatedText = translation;
        });
      } catch (e) {
        ErrorHandler.handleTranslationError(context, e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context)!.errorInTranslation)),
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
              _isListeningPerson2 = false;
            });
          }
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListeningPerson1 = false;
        _isListeningPerson2 = false;
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
              _isListeningPerson1 = false;
            });
          }
        });
      }
    } else {
      _speech.stop();
      setState(() {
        _isListeningPerson2 = false;
        _isListeningPerson1 = false;
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
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
            height: size.height * 0.6,
            width: size.width,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.25,
                      width: size.width,
                      //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.yellow),
                      // ),
                      child: AutoSizeText(
                        _inputText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 32,
                        ),
                        maxFontSize: 32,
                        minFontSize: 24,
                        maxLines: null,
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: dividerColor.withOpacity(0.5),
                    ),
                    // Translated Text Container
                    SizedBox(
                      height: size.height * 0.25,
                      width: size.width,
                      //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: AutoSizeText(
                        _translatedText, // Display the translated text here
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        maxFontSize: 32,
                        minFontSize: 24,
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            width: size.width,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: size.height * 0.05,
                      width: size.width * 0.4,
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
                            print('person 1 lang : $_person1Language');
                            print('person 2 lang : $_person2Language');
                          });
                          _saveLanguagePreferences();
                          if (_inputText.isNotEmpty) {
                            _translateText(_inputText, speaker1, speaker2);
                          }
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
                      height: size.height * 0.05,
                      width: size.width * 0.4,
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
                            print('person 1 lang : $_person1Language');
                            print('person 2 lang : $_person2Language');
                          });
                          _saveLanguagePreferences();
                          if (_inputText.isNotEmpty) {
                            _translateText(_inputText, speaker1, speaker2);
                          }
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
}
