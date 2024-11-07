import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../../core/widgets/permission_handler.dart';
import '../widgets/error_handler.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = 'auto';
  String _targetLanguage = 'auto';
  String _inputText = '';
  String _translatedText = '';

  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sourceLanguage =
          prefs.getString('sourceLanguage') ?? 'en'; // Default to 'en'
      _targetLanguage =
          prefs.getString('targetLanguage') ?? 'ur'; // Default to 'ur'
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sourceLanguage', _sourceLanguage);
    prefs.setString('targetLanguage', _targetLanguage);
  }

  void _translateText(String inputText) async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (!await PermissionHelper().checkWifiConnection(context)) return;
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
          _buildLanguageSelector(),
          Expanded(
            child: _buildTranslationContainer(),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final size = MediaQuery.of(context).size;
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
            _saveLanguagePreferences();
            if (_inputText.isNotEmpty) _translateText(_inputText);
          }),
          IconButton(
            icon: const Icon(Icons.swap_horiz),
            onPressed: () {
              print("source language before : $_sourceLanguage");
              print("target language before : $_targetLanguage");
              setState(() {
                final temp = _sourceLanguage;
                _sourceLanguage = _targetLanguage;
                _targetLanguage = temp;
              });
              _saveLanguagePreferences();
              print("source language after : $_sourceLanguage");
              print("target language after : $_targetLanguage");
              if (_inputText.isNotEmpty) _translateText(_inputText);
            },
          ),
          _buildLanguageDropdown(_targetLanguage, (newLang) {
            setState(() {
              _targetLanguage = newLang;
            });
            _saveLanguagePreferences();
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

  Widget _buildTranslationContainer() {
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
            if (_inputText.isNotEmpty) _buildTranslatedText()
          ],
        ),
      ),
    );
  }

  Widget _buildTranslatedText() {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: AutoSizeText(
            _translatedText,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.black87),
            maxFontSize: 32,
            minFontSize: 24,
            maxLines: null,
          ),
        ),
        Divider(
          thickness: 2,
          color: dividerColor,
          indent: 16,
          endIndent: 16,
        ),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
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
