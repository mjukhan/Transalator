import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translation_app/data/models/ocr_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../core/widgets/translator_provider.dart';
import '../../../data/repositories/ocr_repository.dart';
import '../../translator/widgets/error_handler.dart';

class FileUpload extends StatefulWidget {
  final File? file;
  const FileUpload({super.key, this.file});

  @override
  State<FileUpload> createState() => _FileUploadState();
}

class _FileUploadState extends State<FileUpload> {
  bool _isLoading = false;
  String? _savedFilePath;
  bool _isTranslating = false;
  final OcrRepository _ocrRepository = OcrRepository();
  String _resultText = '';
  String _sourceLanguage = 'auto'; // Default source language
  String _targetLanguage = 'ur'; // Default target language
  String _translatedText = '';

  final TranslationService _translationService = TranslationService();

  void _translateText(String inputText) async {
    if (inputText.isEmpty) {
      setState(() {
        _translatedText = '';
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
      final fileName = widget.file!.path.split('/').last; // Get the file name
      final newFilePath =
          '${directory.path}/$fileName'; // Path within app storage

      // Copy the file to the app's storage directory
      File savedFile = await widget.file!.copy(newFilePath);

      final fileExtension = p.extension(savedFile.path);
      print('file extension : $fileExtension');

      setState(() {
        _savedFilePath =
            savedFile.path; // Set saved path to display or use later
        _isLoading = false; // Upload completed
      });
      // Show success dialog
      _showSuccessDialog(fileName);
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
      _translateText(_resultText);
      print('OCR Result: $_resultText');
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
      ),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text(
              'File Uploaded',
              textAlign: TextAlign.start,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          Builder(
            builder: (BuildContext context) {
              if (_isLoading) {
                return _buildLoadingIndicator();
              } else if (_savedFilePath != null) {
                return Column(
                  children: [
                    _buildSingleFileDisplay(context),
                    Divider(),
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                      'Translation',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * 0.6,
                      width: double.infinity,
                      child: Container(
                        margin: EdgeInsets.fromLTRB(16, 4, 16, 8),
                        height: 250,
                        width: double.infinity,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Center(
                              child: _isTranslating
                                  ? CircularProgressIndicator()
                                  : Text(_translatedText),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              } else {
                return const SizedBox();
              }
            },
          ),
        ],
      ),
    );
  }

  /// Shows a loading indicator while the file is being uploaded.
  Widget _buildLoadingIndicator() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40.0),
        child: CircularProgressIndicator(),
      ),
    );
  }

  /// Displays the saved file path after upload.
  Widget _buildSingleFileDisplay(BuildContext context) {
    if (_savedFilePath != null) {
      return Center(
        child: ListTile(
          onTap: () => openFile(widget.file!),
          title: Text(_savedFilePath!.split('/').last),
          subtitle: Text('File Type : ${p.extension(_savedFilePath!)}'),
          trailing: elevatedButton(widget.file!),
        ),
      );
    }
    throw Exception('File not uploaded');
  }

  void _showSuccessDialog(String? fileName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Upload Successful'),
          content: Text('File "$fileName" has been uploaded successfully.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void openFile(File pdfFile) {
    OpenFile.open(pdfFile.path).then((result) {
      if (result.type == ResultType.error) {
        _logException("Could not open the PDF file: ${result.message}");
      }
    });
  }

  void _logException(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor:
            Colors.red, // Optional: Set background color for the SnackBar
      ),
    );
  }

  ElevatedButton elevatedButton(File savedFile) {
    return ElevatedButton(
      onPressed: () {
        _ocrOnFile(savedFile);
        // _showTranslatedDialog(
        //   savedFile.path.split('/').last,
        //   Uri.parse(
        //       'https://api.ocr.space/SearchablePDF/325b4985-f02f-40d3-811f-b6d71f52ee73.pdf'),
        // );
      },
      child: Text('Translate'),
    );
  }

  _showTranslatedDialog(String filename, Uri downloadableLink) {
    // return showDialog(
    //     context: context,
    //     builder: (BuildContext context) {
    //       return AlertDialog(
    //         title: const Text('Translated Successful'),
    //         content: Text('File "$filename" has been translated successfully.'),
    //         actions: <Widget>[
    //           TextButton(
    //             child: const Text('OK'),
    //             onPressed: () {
    //               Navigator.of(context).pop();
    //             },
    //           ),
    //           TextButton(
    //             onPressed: () => _downloadFile(downloadableLink),
    //             child: Text('Download'),
    //           ),
    //         ],
    //       );
    //     });
  }

  Future<void> _downloadFile(Uri url) async {
    if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
      throw Exception('Could not Download');
    }
  }
}

class Result extends StatelessWidget {
  const Result({
    Key? key,
    required this.text,
  }) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text("Readed text: $text");
  }
}
