import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:translation_app/core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../widgets/error_handler.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';

class TranslatorScreen extends StatefulWidget {
  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = 'auto'; // Default source language
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
      ErrorHandler.handleTranslationError(context, e);
      setState(() {
        _translatedText = 'Error in translation';
      });
    }
  }

  void _clearInput() {
    setState(() {
      _inputText = ''; // Clear input text
      _translatedText = ''; // Optionally clear translated text
    });
  }

  void _saveInstance() {
    print("Instance saved: $_translatedText");
  }

  void _findInDictionary() {
    print("Finding '$_inputText' in dictionary");
  }

  void _copyToClipboard() {
    print("Copied: $_translatedText");
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFFF8F9FA),
        title: const Text('Translator'),
        actions: [
          IconButton(
            icon: const Icon(Icons.star_border),
            onPressed: () {
              // Handle saved translations
            },
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildLanguageSelector(size),
          Expanded(
            child: _buildTranslationContainer(size),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector(Size size) {
    return Container(
      height: size.height * 0.08,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLanguageDropdown(_sourceLanguage, (newLang) {
            setState(() {
              _sourceLanguage = newLang;
            });
            if (_inputText.isNotEmpty) _translateText(_inputText);
          }),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              setState(() {
                final temp = _sourceLanguage;
                _sourceLanguage = _targetLanguage;
                _targetLanguage = temp;
              });
              if (_inputText.isNotEmpty) _translateText(_inputText);
            },
          ),
          _buildLanguageDropdown(_targetLanguage, (newLang) {
            setState(() {
              _targetLanguage = newLang;
            });
            if (_inputText.isNotEmpty) _translateText(_inputText);
          }),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
      String selectedLanguage, Function(String) onChanged) {
    return Container(
      height: 50,
      width: 120,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: langSelectorColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LanguageSelector(
        selectedLanguage: selectedLanguage,
        onLanguageChanged: onChanged,
        fontSize: 12,
      ),
    );
  }

  Widget _buildTranslationContainer(Size size) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
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
              sourceLanguage: '',
            ),
            if (_translatedText.isNotEmpty) _buildTranslatedText(),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslatedText() {
    return Column(
      children: [
        Divider(thickness: 2, color: dividerColor),
        _buildActionButtons(),
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: AutoSizeText(
            _translatedText,
            textAlign: TextAlign.start,
            style: const TextStyle(color: Colors.black87),
            maxFontSize: 24,
            minFontSize: 16,
            maxLines: null,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        IconButton(
          icon: const Icon(Icons.search),
          onPressed: _findInDictionary,
          tooltip: 'Find in Dictionary',
        ),
        IconButton(
          icon: const Icon(Icons.star),
          onPressed: _saveInstance,
          tooltip: 'Save Instance',
        ),
        IconButton(
          icon: const Icon(Icons.copy),
          onPressed: _copyToClipboard,
          tooltip: 'Copy',
        ),
      ],
    );
  }
}
