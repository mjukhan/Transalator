import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import AutoSizeText
import 'package:translation_app/core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = 'en'; // Default source language
  String _targetLanguage = 'ur'; // Default target language
  String _inputText = '';
  String _translatedText = '';

  final TranslationService _translationService =
      TranslationService(); // Create an instance of TranslationService

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
      print("Translation Error: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in translation: $e')),
      );
      setState(() {
        _translatedText = 'Error in translation';
      });
    }
  }

  void _clearInput() {
    setState(() {
      _inputText = ''; // Clear the input text
      _translatedText = ''; // Optionally clear translated text
    });
  }

  void _updateLanguages(String newTargetLanguage) {
    setState(() {
      _targetLanguage = newTargetLanguage; // Update target language
      _sourceLanguage = 'auto'; // Set source language to auto for detection
    });

    // Translate the text immediately after changing the target language
    _translateText(_inputText);
  }

  void _saveInstance() {
    // Implement saving logic here
    print("Instance saved: $_translatedText");
  }

  void _findInDictionary() {
    // Implement dictionary lookup logic here
    print("Finding '$_inputText' in dictionary");
  }

  void _copyToClipboard() {
    // Implement copy to clipboard logic here
    print("Copied: $_translatedText");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text('Translator'),
        actions: [
          IconButton(
            icon: Icon(Icons.star_border),
            onPressed: () {
              // Handle saved translations
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: size.height * 0.08,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: langSelectorColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
                    child: LanguageSelector(
                      selectedLanguage: _sourceLanguage,
                      onLanguageChanged: (newLang) {
                        setState(() {
                          _sourceLanguage = newLang; // Update source language
                        });
                        // Check if _inputText is not empty before translating
                        if (_inputText.isNotEmpty) {
                          _translateText(
                              _inputText); // Translate with the new source language
                        }
                      },
                    ),
                  ),
                ),
                IconButton(
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
                Container(
                  height: size.height * 0.06,
                  width: size.width * 0.4,
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: langSelectorColor,
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Center(
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
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              width: size.width * 1,
              decoration: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 42, 157, 143),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      onChanged: (text) {
                        setState(() {
                          _inputText = text; // Update input text
                        });
                        _translateText(_inputText); // Translate input text
                      },
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
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.search),
                                    onPressed: _findInDictionary,
                                    tooltip: 'Find in Dictionary',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.star),
                                    onPressed: _saveInstance,
                                    tooltip: 'Save Instance',
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.copy),
                                    onPressed: _copyToClipboard,
                                    tooltip: 'Copy',
                                  ),
                                ],
                              )
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
        ],
      ),
    );
  }
}
