import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';

import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _sourceLanguage = 'en'; // Default source language
  String _targetLanguage = 'ur'; // Default target language
  String _inputText = '';
  String _translatedText = '';

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
        from: _sourceLanguage,
        to: _targetLanguage,
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

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('Conversation')),
      body: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                height: size.height * 0.35,
                width: size.width,
                decoration: BoxDecoration(
                  color: person1Color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 50,
                          width: 150,
                          padding: EdgeInsets.all(16),
                          margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                          decoration: BoxDecoration(
                            color: langSelectorColor,
                            borderRadius: BorderRadius.circular(32),
                          ),
                          child: LanguageSelector(
                            selectedLanguage: _sourceLanguage,
                            onLanguageChanged: (newLang) {
                              setState(() {
                                _sourceLanguage =
                                    newLang; // Update source language
                              });
                              // Check if _inputText is not empty before translating
                              if (_inputText.isNotEmpty) {
                                _translateText(
                                    _inputText); // Translate with the new source language
                              }
                            },
                          ),
                        ),
                      ],
                    ),

                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                margin: EdgeInsets.fromLTRB(16, 4, 16, 4),
                height: size.height * 0.35,
                width: size.width,
                decoration: BoxDecoration(
                  color: person2Color,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 50,
                      width: 150,
                      padding: EdgeInsets.all(16),
                      margin: EdgeInsets.fromLTRB(16, 16, 0, 0),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _targetLanguage,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            _targetLanguage = newLang; // Update target language
                          });
                          // Check if _inputText is not empty before translating
                          if (_inputText.isNotEmpty) {
                            _translateText(
                                _inputText); // Translate with the new target language
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.yellow,
            ),
            child: IconButton(
              icon: Icon(Icons.swap_horiz),
              onPressed: () {
                setState(() {
                  // Swap languages
                  String temp = _sourceLanguage;
                  _sourceLanguage = _targetLanguage;
                  _targetLanguage = temp;
                });
                // Check if _inputText is not empty before translating
                if (_inputText.isNotEmpty) {
                  _translateText(_inputText); // Translate after swapping
                }
              },
            ),
          )
        ],
      ),
    );
  }
}
