import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translation_app/core/widgets/widgets.dart';
import 'package:translator/translator.dart';
import 'dart:async';
import 'package:path/path.dart' as p;
import '../../../core/utilities/colors.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../../data/models/ocr_model.dart';
import '../../../data/repositories/ocr_repository.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';

class PictureScreen extends StatefulWidget {
  final File? imageFile;
  const PictureScreen({super.key, this.imageFile});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  bool _isLoading = false;
  String? _savedFilePath;
  bool _isTranslating = false;
  final OcrRepository _ocrRepository = OcrRepository();
  String _resultText = '';
  String _sourceLanguage = 'auto';
  String _targetLanguage = 'ur';
  String _translatedText = '';
  final TranslationService _translationService = TranslationService();
  final StreamController<String> controller = StreamController<String>();

  @override
  void initState() {
    super.initState();
    _startUpload();
  }

  void setText(value) {
    controller.add(value);
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  Future<void> _startUpload() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Obtain the app's document directory
      final directory = await getApplicationDocumentsDirectory();

      // Generate the new file path in the app's storage
      final fileName =
          widget.imageFile!.path.split('/').last; // Get the file name
      final newFilePath =
          '${directory.path}/$fileName'; // Path within app storage

      // Copy the file to the app's storage directory
      File savedFile = await widget.imageFile!.copy(newFilePath);

      final fileExtension = p.extension(savedFile.path);
      print('file extension : $fileExtension');

      setState(() {
        _savedFilePath =
            savedFile.path; // Set saved path to display or use later
        _isLoading = false; // Upload completed
      });
      // Show success dialog
      ReFunctions().showSuccessDialog(context, fileName);
      print(_savedFilePath);
      _ocrOnFile(savedFile);
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
    }
  }

  Future<void> _ocrOnFile(File file) async {
    setState(() {
      _isTranslating = true;
    });
    try {
      OcrModel result = await _ocrRepository.uploadFile(file);
      setState(() {
        _resultText = result.parsedResults![0].parsedText!;
        _isTranslating = false;
      });
      print('OCR Result: $_resultText');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Display the image file
              if (widget.imageFile != null)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(
                    widget.imageFile!,
                    fit: BoxFit.fitWidth, // Change to cover for better fit
                  ),
                ),
              _buildBottomControls(size),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBottomControls(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildLanguageSelector(size),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel_outlined,
              size: 50,
              color: borderColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(Size size) {
    return Container(
      height: 50,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('Translate to :'),
          _buildLanguageDropdown(
            size,
            _targetLanguage,
            (newLang) => setState(() {
              _targetLanguage = newLang;
            }),
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
}
