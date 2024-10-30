import 'dart:async';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:flutter/material.dart';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:translation_app/core/widgets/widgets.dart';
import 'package:translation_app/data/models/ocr_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/widgets/translator_provider.dart';
import '../../../../data/repositories/ocr_repository.dart';

class OCR extends StatefulWidget {
  const OCR({super.key});

  @override
  State<OCR> createState() => _OCRState();
}

class _OCRState extends State<OCR> {
  String _extractedText = '';
  bool _isExtractingText = false;

  final OcrRepository _ocrRepository = OcrRepository();

  Future<void> ocrOnFile(File file) async {
    setState(() {
      _isExtractingText = true;
    });
    try {
      OcrModel result = await _ocrRepository.uploadFile(file);
      setState(() {
        _extractedText = result.parsedResults![0].parsedText!;
        _isExtractingText = false;
      });
      print('OCR Result: $_extractedText');
    } catch (e) {
      setState(() {
        _isExtractingText = false;
      });
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}
