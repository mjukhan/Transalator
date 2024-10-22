import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart'; // Import AutoSizeText
import 'package:translation_app/core/utilities/colors.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = 'en';
  String _targetLanguage = 'ur';
  String _inputText = '';
  String _translatedText = '';

  void _translateText(String inputText) {
    // Simulate translation logic (replace with actual API call)
    setState(() {
      _translatedText = '$inputText'; // Update translated text
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
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
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
            decoration: BoxDecoration(
              color: Colors.white,
              //borderRadius: BorderRadius.circular(40),
            ),
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
                          _sourceLanguage = newLang;
                        });
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
                          _targetLanguage = newLang;
                        });
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
              //height: size.height*0.6,
              decoration: BoxDecoration(
                //color: Colors.grey,
                border: Border.all(
                  color: Color.fromARGB(255, 42, 157, 143),
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: SingleChildScrollView(
                // Enable scrolling for long content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    InputField(
                      onChanged: (text) {
                        setState(() {
                          _inputText = text;
                        });
                        _translateText(_inputText);
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
