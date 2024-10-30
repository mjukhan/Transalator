import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/features/translator/widgets/input_field.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _person1Language = 'en'; // Default source language
  String _person2Language = 'ur'; // Default target language
  String _inputText = '';
  String _translatedText = '';
  bool _isListeningperson1 = false;
  bool _isListeningperson2 = false;

  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Speech-to-text instance

  final TranslationService _translationService = TranslationService();

  void _translateText(String inputText) async {
    if (inputText.isEmpty) {
      setState(() {
        _translatedText = ''; // Clear translated text if input is empty
      });
      return;
    }

    try {
      // Call the translation service
      final translation = await _translationService.translate(
        text: inputText,
        from: _person1Language,
        to: _person2Language,
      );

      setState(() {
        _translatedText = translation; // Update translated text
      });
    } catch (e) {
      // Use centralized error handler to manage the error
      ErrorHandler.handleTranslationError(context, e);
      setState(() {
        _translatedText = 'Error in translation';
      });
    }
  }

  // Method to handle speech recognition for source language
  void _listenPerson1() async {
    if (!_isListeningperson1) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListeningperson1 = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _inputText = val.recognizedWords;
            _translateText(_inputText); // Translate from source to target
          });
        });
      }
    } else {
      setState(() => _isListeningperson1 = false);
      _speech.stop();
    }
  }

  // Method to handle speech recognition for target language
  void _listenPerson2() async {
    if (!_isListeningperson2) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() => _isListeningperson2 = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _translatedText = val.recognizedWords;
            _translateText(_translatedText); // Translate from target to source
          });
        });
      }
    } else {
      setState(() => _isListeningperson2 = false);
      _speech.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 249, 250),
      appBar: AppBar(
        title: Text("Conversation"),
        backgroundColor: bgColor,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
            height: size.height * 0.6,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: AutoSizeText(
                        _inputText, // Display the translated text here
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        maxFontSize: 24,
                        minFontSize: 16,
                        maxLines: null, // Remove maxLines limit
                      ),
                    ),
                    // Translated Text Container
                    if (_translatedText.isNotEmpty)
                      Column(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Divider(
                                thickness: 2,
                                color: dividerColor,
                              ),
                              // Row(
                              //   mainAxisAlignment: MainAxisAlignment.start,
                              //   children: [
                              //     IconButton(
                              //       icon: Icon(Icons.search),
                              //       onPressed: _findInDictionary,
                              //       tooltip: 'Find in Dictionary',
                              //     ),
                              //     IconButton(
                              //       icon: Icon(Icons.star),
                              //       onPressed: _saveInstance,
                              //       tooltip: 'Save Instance',
                              //     ),
                              //     IconButton(
                              //       icon: Icon(Icons.copy),
                              //       onPressed: _copyToClipboard,
                              //       tooltip: 'Copy',
                              //     ),
                              //   ],
                              // ),
                            ],
                          ),
                          Container(
                            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                            child: AutoSizeText(
                              _translatedText, // Display the translated text here
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.black87,
                              ),
                              maxFontSize: 24,
                              minFontSize: 16,
                              maxLines: null, // Remove maxLines limit
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.2,
            width: size.width,
            // decoration: BoxDecoration(
            //   color: bgColor,
            //   border: Border.all(color: Colors.yellow),
            // ),
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: size.height * 0.05,
                      width: size.width * 0.4,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person1Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            _person1Language =
                                newLang; // Update source language
                          });
                          // Check if _inputText is not empty before translating
                          if (_inputText.isNotEmpty) {
                            _translateText(
                                _inputText); // Translate with the new source language
                          }
                        }, fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _listenPerson1,
                        icon: _isListeningperson1
                            ? Icon(Icons.mic)
                            : Icon(Icons.mic_none),
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
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person2Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            _person2Language =
                                newLang; // Update source language
                          });
                          // Check if _inputText is not empty before translating
                          if (_inputText.isNotEmpty) {
                            _translateText(
                                _inputText); // Translate with the new source language
                          }
                        }, fontSize: 12,
                      ),
                    ),
                    Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: borderColor,
                        ),
                      ),
                      child: IconButton(
                        onPressed: _listenPerson2,
                        icon: _isListeningperson2
                            ? Icon(Icons.mic)
                            : Icon(Icons.mic_none),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
