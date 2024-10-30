// dictionary_repository.dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/Word_model.dart';

class DictionaryRepository {
  static const String baseUrl =
      'https://api.dictionaryapi.dev/api/v2/entries/en/';

  Future<WordDefinition?> fetchWordDefinition(String word) async {
    final response = await http.get(Uri.parse('$baseUrl$word'));

    if (response.statusCode == 200) {
      // Parse the JSON data
      final List<dynamic> data = jsonDecode(response.body);
      return WordDefinition.fromJson(
          data[0]); // Assuming we want the first result
    } else {
      // Handle errors like word not found
      throw Exception('Failed to load word definition');
    }
  }
}
