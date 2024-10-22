import 'package:flutter/material.dart';
import 'input_field.dart';
import 'language_selector.dart';

class TranslationInstance extends StatefulWidget {
  final Function onNext; // Callback to add a new translation instance

  TranslationInstance({required this.onNext});

  @override
  _TranslationInstanceState createState() => _TranslationInstanceState();
}

class _TranslationInstanceState extends State<TranslationInstance> {
  String _sourceLanguage = 'en';
  String _targetLanguage = 'ur';
  String _inputText = '';
  String _translatedText = '';
  bool _isExpanded = false; // Track the expansion state

  // Mock translation function
  void _translateText() {
    if (_inputText.isEmpty) return; // Handle empty input
    setState(() {
      _translatedText = "Translation: '$_inputText' from $_sourceLanguage to $_targetLanguage"; // Mock translation
      _isExpanded = true; // Expand card when there's input text
    });
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
    return Card(
      elevation: 8.0,
      margin: EdgeInsets.symmetric(vertical: 10.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LanguageSelector(
                  selectedLanguage: _sourceLanguage,
                  onLanguageChanged: (newLang) {
                    setState(() {
                      _sourceLanguage = newLang;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    // Implement voice input
                  },
                ),
              ],
            ),
            InputField(
              onChanged: (text) {
                setState(() {
                  _inputText = text;
                  _isExpanded = text.isNotEmpty; // Expand card if there's input
                });
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: Icon(Icons.swap_horiz),
                  onPressed: () {
                    setState(() {
                      // Swap languages
                      String temp = _sourceLanguage;
                      _sourceLanguage = _targetLanguage;
                      _targetLanguage = temp;
                    });
                  },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LanguageSelector(
                  selectedLanguage: _targetLanguage,
                  onLanguageChanged: (newLang) {
                    setState(() {
                      _targetLanguage = newLang;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.mic),
                  onPressed: () {
                    // Implement voice input
                  },
                ),
              ],
            ),
            // Show the translated text only if the card is expanded
            if (_isExpanded) ...[
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _translateText,
                child: Text('Translate'),
              ),
              SizedBox(height: 10),
              Text(
                _translatedText,
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 10),
              // New buttons to save, find in dictionary, copy, and go to next instance
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  IconButton(
                    icon: Icon(Icons.star),
                    onPressed: _saveInstance,
                    tooltip: 'Save Instance',
                  ),
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: _findInDictionary,
                    tooltip: 'Find in Dictionary',
                  ),
                  IconButton(
                    icon: Icon(Icons.copy),
                    onPressed: _copyToClipboard,
                    tooltip: 'Copy',
                  ),
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  widget.onNext(); // Callback to add a new instance
                  setState(() {
                    _inputText = ''; // Reset input text
                    _translatedText = ''; // Reset translated text
                    _isExpanded = false; // Collapse the card
                  });
                },
                child: Text('Next'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
