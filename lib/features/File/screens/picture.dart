import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../../../core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';
import '../widgets/OcrFile.dart';
import '../widgets/upload.dart';

class PictureScreen extends StatefulWidget {
  final File? imageFile;
  const PictureScreen({super.key, this.imageFile});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  String _targetLanguage = '';
  List<Map<String, dynamic>> extractedLines = [];
  List<String> translatedLines = [];
  List<String> inputLines = [];
  bool _isTranslating = false;
  final StreamController<String> controller = StreamController<String>();
  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    imageUpload();
    _loadLanguagePreferences();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _targetLanguage = prefs.getString('targetLanguage') ?? 'auto';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('targetLanguage', _targetLanguage);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<void> imageUpload() async {
    File? upLoadedFile =
        await Upload(imageFile: widget.imageFile).startUpload(context);
    if (upLoadedFile != null) {
      // Use compute to offload the OCR processing
      extractedLines = await compute(_performOcr, upLoadedFile);
      // Extracting text lines from the extracted lines
      inputLines =
          extractedLines.map((line) => line['LineText'] as String).toList();
      print(inputLines);
      await _translateText(inputLines);
    }
  }

  static Future<List<Map<String, dynamic>>> _performOcr(File file) async {
    // Your OCR processing logic
    return await OCR().getLinesWithAttributes(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            children: [
              _buildImageView(),
              _buildBottomControls(),
            ],
          );
        },
      ),
    );
  }

  Widget _buildImageView() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      width: size.width,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.file(
            widget.imageFile!,
            fit: BoxFit.contain,
          ),
          _isTranslating
              ? CircularProgressIndicator()
              : _buildTranslatedLinesView(translatedLines),
        ],
      ),
    );
  }

  Widget _buildTranslatedLinesView(List<String> lines) {
    return IntrinsicHeight(
      child: Container(
        color: bgColor,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: lines
              .map(
                (line) => Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Text(
                    line,
                  ),
                ),
              )
              .toList(),
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return _buildLanguageSelector();
  }

  Widget _buildLanguageSelector() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: 100,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Translate to:'),
          _buildLanguageDropdown(
            size,
            _targetLanguage,
            (newLang) {
              setState(() => _targetLanguage = newLang);
              _translateText(inputLines);
              _saveLanguagePreferences();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
      Size size, String selectedLang, Function(String) onChanged) {
    return Container(
      height: size.height * 0.04,
      width: size.width * 0.25,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: langSelectorColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LanguageSelector(
        selectedLanguage: selectedLang,
        onLanguageChanged: onChanged,
        fontSize: 10,
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
          from: 'auto',
          to: _targetLanguage, // Uses selected language from dropdown
        );

        translations.add(translation.isNotEmpty
            ? translation
            : 'Translation result is empty.');
      } catch (e) {
        ErrorHandler.handleTranslationError(context, e);
        translations.add('Translation error occurred for line: $line');
        _isTranslating = false;
      }
    }

    setState(() {
      translatedLines = translations; // Update translatedLines state
      _isTranslating = false;
    });
  }
}
