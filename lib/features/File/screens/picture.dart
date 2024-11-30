import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/screens/results.dart';
import 'package:translation_app/features/translator/screens/translation_screen.dart';
import 'package:translation_app/features/translator/widgets/input_field.dart';
import 'dart:async';
import '../widgets/OcrFile.dart';
import '../widgets/upload.dart';

class PictureScreen extends StatefulWidget {
  final File? imageFile;
  const PictureScreen({super.key, this.imageFile});

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

  Future<void> imageUpload() async {
    File? upLoadedFile = await Upload(
      imageFile: widget.imageFile,
    ).startUpload(context);
    if (upLoadedFile != null) {
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
      appBar: AppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: micColor,
        onPressed: () {
          (isExtracting)
              ? null
              : Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => Results(extractedText: inputLines),
                ),
              );
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
