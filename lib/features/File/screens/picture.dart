import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/screens/results.dart';
import 'dart:async';
import '../../translator/widgets/error_handler.dart';
import '../widgets/OcrFile.dart';
import '../widgets/upload.dart';

class PictureScreen extends StatefulWidget {
  final bool wifi;
  final String connectionStatus;
  final File? imageFile;
  const PictureScreen({
    super.key,
    this.imageFile,
    required this.wifi,
    required this.connectionStatus,
  });

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  List<Map<String, dynamic>> extractedLines = [];
  List<String> inputLines = [];
  bool isExtracting = false;

  final StreamController<String> controller = StreamController<String>();

  @override
  void initState() {
    super.initState();
    imageUpload();
  }

  @override
  void dispose() {
    controller.close();
    super.dispose();
  }

  void snackMassage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: micColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  Future<void> imageUpload() async {
    File? upLoadedFile = await Upload(
      imageFile: widget.imageFile,
    ).startUpload(context);
    if (upLoadedFile != null) {
      if (widget.wifi) {
        try {
          setState(() {
            isExtracting = true;
          });
          // Use compute to offload the OCR processing
          extractedLines = await compute(_performOcr, upLoadedFile);
          // Extracting text lines from the extracted lines
          inputLines =
              extractedLines.map((line) => line['LineText'] as String).toList();
          setState(() {
            isExtracting = false;
          });
        } catch (e) {
          ErrorHandlerTranslating.handleTranslationError(context, e);
        }
      }
    }
    setState(() {
      isExtracting = false;
    });
  }

  static Future<List<Map<String, dynamic>>> _performOcr(File file) async {
    // Your OCR processing logic
    return await OCR().getLinesWithAttributes(file);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: micColor,
        onPressed: () {
          (widget.wifi)
              ? (isExtracting)
                  ? null
                  : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Results(extractedText: inputLines),
                    ),
                  )
              : snackMassage(widget.connectionStatus);
        },
        label:
            (isExtracting)
                ? Text(
                  "Extracting Text...",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                )
                : Text(
                  "Translate",
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: bgColor,
                  ),
                ),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(children: [_buildImageView()]);
        },
      ),
    );
  }

  Widget _buildImageView() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height * 0.7,
      width: size.width,
      child: Image.file(widget.imageFile!, fit: BoxFit.contain),
    );
  }
}
