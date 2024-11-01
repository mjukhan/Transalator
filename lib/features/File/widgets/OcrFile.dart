import 'dart:io';
import '../../../data/models/ocr_model.dart';
import '../../../data/repositories/ocr_repository.dart';

class OCR {
  String _extractedText = '';
  bool _isExtractingText = false;

  final OcrRepository _ocrRepository = OcrRepository();

  bool get isExtractingText => _isExtractingText;
  String get extractedText => _extractedText;

  Future<String> ocrOnFile(File file) async {
    _isExtractingText = true;

    try {
      OcrModel result = await _ocrRepository.uploadFile(file);

      // Combine all lines and words into a single string for `extractedText`
      _extractedText = result.parsedResults!
          .map((parsedResult) => parsedResult.textOverlay!.lines!
              .map((line) => line.words!.map((word) => word.wordText).join(' '))
              .join('\n'))
          .join('\n\n');

      print('Text Extracted: $_extractedText');
      return _extractedText;
    } catch (e) {
      print('Error: $e');
      return '';
    } finally {
      _isExtractingText = false;
    }
  }

  // Function to get each line of text along with MaxHeight and MinTop
  Future<List<Map<String, dynamic>>> getLinesWithAttributes(File file) async {
    List<Map<String, dynamic>> linesWithAttributes = [];

    try {
      // Upload the file and get OCR results
      final OcrModel result = await _ocrRepository.uploadFile(file);

      // If parsedResults or nested lists are null, set to an empty list to prevent null errors
      final parsedResults = result.parsedResults ?? [];

      for (var parsedResult in parsedResults) {
        final lines = parsedResult.textOverlay?.lines ?? [];

        for (var line in lines) {
          linesWithAttributes.add({
            "LineText": line.lineText,
            "Words": (line.words ?? []).map((word) {
              return {
                "WordText": word.wordText,
                "Left": word.left,
                "Top": word.top,
                "Height": word.height,
                "Width": word.width,
              };
            }).toList(), // Returning words as a list of attributes
            "MaxHeight": line.maxHeight,
            "MinTop": line.minTop,
          });
        }
      }
    } catch (e) {
      // Log the error message and stack trace to help with debugging
      print('Error fetching lines with attributes: $e');
    }

    return linesWithAttributes;
  }

  // Function to get each word with its Left, Top, Height, and Width
  Future<List<Map<String, dynamic>>> getWordsWithAttributes(File file) async {
    try {
      OcrModel result = await _ocrRepository.uploadFile(file);
      List<Map<String, dynamic>> wordsWithAttributes = result.parsedResults!
          .expand((parsedResult) => parsedResult.textOverlay!.lines!
              .expand((line) => line.words!.map((word) => {
                    "text": word.wordText,
                    "left": word.left,
                    "top": word.top,
                    "height": word.height,
                    "width": word.width,
                  })))
          .toList();

      return wordsWithAttributes;
    } catch (e) {
      print('Error fetching words with attributes: $e');
      return [];
    }
  }
}
