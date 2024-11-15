import 'package:translator/translator.dart';

class TranslationService {
  final GoogleTranslator _translator;

  TranslationService() : _translator = GoogleTranslator();

  // Function to translate text from source to target language
  Future<String> translate({
    required String text,
    String? from,
    required String to,
  }) async {
    try {
      final translation = await _translator.translate(
        text,
        from: from ?? 'en',
        to: to,
      );
      return translation.text; // Return the translated text
    } catch (e) {
      print("Translation Error: $e");
      return "Error translating text."; // Provide a fallback message
    }
  }
}
