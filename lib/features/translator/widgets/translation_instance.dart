import 'package:flutter/material.dart';
import 'input_field.dart';
import 'language_selector.dart';

class TranslationInstance extends StatefulWidget {
  //final Function onNext; // Callback to add a new translation instance

  TranslationInstance();

  @override
  _TranslationInstanceState createState() => _TranslationInstanceState();
}

class _TranslationInstanceState extends State<TranslationInstance> {
  final String _sourceLanguage = 'en';
  final String _targetLanguage = 'ur';
  final String _inputText = '';
  String _translatedText = '';
  bool _isExpanded = false;
  bool _isTranslated = false;

  // Mock translation function
  void _translateText() {
    if (_inputText.isEmpty) return; // Handle empty input
    setState(() {
      _translatedText =
          "Translation: '$_inputText' from $_sourceLanguage to $_targetLanguage"; // Mock translation
      _isExpanded = true; // Expand card when there's input text
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.35,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.grey,
      ),
      child: Column(
        children: [],
      ),
    );
  }
}
