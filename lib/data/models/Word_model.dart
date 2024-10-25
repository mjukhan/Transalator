// word_definition.dart
class WordDefinition {
  final String word;
  final String phonetic;
  final List<Phonetic> phonetics;
  final List<Meaning> meanings;
  final License license;
  final List<String> sourceUrls;

  WordDefinition({
    required this.word,
    required this.phonetic,
    required this.phonetics,
    required this.meanings,
    required this.license,
    required this.sourceUrls,
  });

  // Factory constructor to parse JSON data
  factory WordDefinition.fromJson(Map<String, dynamic> json) {
    return WordDefinition(
      word: json['word'],
      phonetic: json['phonetic'] ?? '',
      phonetics:
          (json['phonetics'] as List).map((i) => Phonetic.fromJson(i)).toList(),
      meanings:
          (json['meanings'] as List).map((i) => Meaning.fromJson(i)).toList(),
      license: License.fromJson(json['license']),
      sourceUrls: List<String>.from(json['sourceUrls']),
    );
  }
}

class Phonetic {
  final String text;
  final String? audio;
  final String? sourceUrl;

  Phonetic({required this.text, this.audio, this.sourceUrl});

  factory Phonetic.fromJson(Map<String, dynamic> json) {
    return Phonetic(
      text: json['text'],
      audio: json['audio'],
      sourceUrl: json['sourceUrl'],
    );
  }
}

class Meaning {
  final String partOfSpeech;
  final List<Definition> definitions;

  Meaning({required this.partOfSpeech, required this.definitions});

  factory Meaning.fromJson(Map<String, dynamic> json) {
    return Meaning(
      partOfSpeech: json['partOfSpeech'],
      definitions: (json['definitions'] as List)
          .map((i) => Definition.fromJson(i))
          .toList(),
    );
  }
}

class Definition {
  final String definition;

  Definition({required this.definition});

  factory Definition.fromJson(Map<String, dynamic> json) {
    return Definition(
      definition: json['definition'],
    );
  }
}

class License {
  final String name;
  final String url;

  License({required this.name, required this.url});

  factory License.fromJson(Map<String, dynamic> json) {
    return License(
      name: json['name'],
      url: json['url'],
    );
  }
}
