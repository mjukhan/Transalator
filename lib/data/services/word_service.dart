// dictionary_service.dart
import '../models/Word_model.dart';
import '../repositories/word_repository.dart';


class DictionaryService {
  final DictionaryRepository repository;

  DictionaryService(this.repository);

  Future<WordDefinition?> getWordDefinition(String word) async {
    try {
      return await repository.fetchWordDefinition(word);
    } catch (e) {
      return null;
    }
  }
  Future<String?> getRandomWord() async {
    try {
      return await repository.fetchRandomWord();
    } catch (e) {
      return null;
    }
  }


}
