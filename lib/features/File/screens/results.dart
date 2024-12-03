import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';

class Results extends StatefulWidget {
  final List<String> extractedText;
  const Results({super.key, required this.extractedText});

  @override
  State<Results> createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  String _targetLanguage = 'es';
  String _sourceLanguage = 'en';
  bool _isTranslating = false;
  List<String> translatedLines = [];
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
    _translateText(widget.extractedText);
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _targetLanguage = prefs.getString('targetLanguage') ?? 'es';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('targetLanguage', _targetLanguage);
  }

  @override
  Widget build(BuildContext context) {
    final _ = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text('Results'),
          backgroundColor: bgColor,
          scrolledUnderElevation: 0,
          elevation: 0,
        ),
        body: Column(
          children: [
            _buildLanguageSelector(),
            _buildTranslationContainer(widget.extractedText),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLanguageDropdown(_sourceLanguage, (newLang) {
            setState(() {
              _sourceLanguage = newLang;
            });
            _saveLanguagePreferences();
            (!_isTranslating)
                ? _translateText(widget.extractedText)
                : CircularProgressIndicator();
          }),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: changeLangColor,
              //border: Border.all(color: Colors.grey)
            ),
            child: IconButton(
              icon: Icon(Icons.swap_horiz, color: micColor),
              onPressed: () {
                setState(() {
                  final temp = _sourceLanguage;
                  _sourceLanguage = _targetLanguage;
                  _targetLanguage = temp;
                });
                _saveLanguagePreferences();
                (!_isTranslating)
                    ? _translateText(widget.extractedText)
                    : CircularProgressIndicator();
              },
            ),
          ),
          _buildLanguageDropdown(_targetLanguage, (newLang) {
            setState(() {
              _targetLanguage = newLang;
            });
            _saveLanguagePreferences();
            (!_isTranslating)
                ? _translateText(widget.extractedText)
                : CircularProgressIndicator();
          }),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
    String selectedLanguage,
    Function(String) onChanged,
  ) {
    return Container(
      height: 50,
      width: 120,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: langSelectorColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: LanguageSelector(
        selectedLanguage: selectedLanguage,
        onLanguageChanged: onChanged,
        fontSize: 16,
      ),
    );
  }

  // Function to translate each line of text in the selected target language
  Future<void> _translateText(List<String> inputLines) async {
    _isTranslating = true;
    if (inputLines.isEmpty) {
      setState(() {
        translatedLines = [];
        _isTranslating = false;
      });
      return;
    }

    List<String> translations = [];

    for (String line in inputLines) {
      try {
        // Use the dynamically set target language for translation
        String translation = await _translationService.translate(
          text: line,
          from: _sourceLanguage,
          to: _targetLanguage, // Uses selected language from dropdown
        );

        translations.add(
          translation.isNotEmpty
              ? translation
              : AppLocalizations.of(context)!.translationResultEmpty,
        );
        setState(() {
          _isTranslating = false;
        });
      } catch (e) {
        ErrorHandlerTranslating.handleTranslationError(context, e);
        translations.add(
          '${AppLocalizations.of(context)!.translationErrorInLine} $line',
        );
      }
    }

    setState(() {
      translatedLines = translations; // Update translatedLines state
      _isTranslating = false;
      print("translated lines : $translatedLines");
    });
  }

  Widget _buildTranslationContainer(List<String> lines) {
    return Flexible(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Displaying extracted text in a scrollable ListView
          Expanded(
            child: ListView.builder(
              itemCount: widget.extractedText.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                  child: AutoSizeText(
                    widget.extractedText[index],
                    maxFontSize: 24,
                    minFontSize: 18,
                  ),
                );
              },
            ),
          ),
          (widget.extractedText.isNotEmpty)
              ? _buildActionButtons(widget.extractedText.join(''))
              : SizedBox.shrink(),
          const Divider(),
          _buildTranslatedLinesView(translatedLines),
          (translatedLines.isNotEmpty)
              ? _buildActionButtons(widget.extractedText.join(''))
              : SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget _buildTranslatedLinesView(List<String> lines) {
    return (translatedLines.isNotEmpty &&
            widget.extractedText.isNotEmpty &&
            !_isTranslating)
        ? Expanded(
          child: ListView.builder(
            itemCount: translatedLines.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.fromLTRB(15, 2, 16, 2),
                child: AutoSizeText(
                  translatedLines[index],
                  maxFontSize: 24,
                  minFontSize: 18,
                  style: TextStyle(color: Colors.blue),
                ),
              );
            },
          ),
        )
        : Expanded(child: Center(child: CircularProgressIndicator()));
  }

  // Function to copy text to the clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(AppLocalizations.of(context)!.textCopied)),
    );
  }

  Widget _buildActionButtons(String textToCopy) {
    return IconButton(
      icon: Icon(Icons.copy),
      onPressed: () => _copyToClipboard(textToCopy),
      tooltip: 'Copy',
    );
  }
}
