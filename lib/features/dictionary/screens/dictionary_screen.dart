import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/dictionary/screens/view_search.dart';
import '../../../core/widgets/permission_handler.dart';
import '../../../data/models/Word_model.dart';
import '../../../data/repositories/word_repository.dart';
import '../../../data/services/word_service.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class DictionaryScreen extends StatefulWidget {
  final String? searchWord;
  const DictionaryScreen({super.key, this.searchWord});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with AutomaticKeepAliveClientMixin {
  final DictionaryService _dictionaryService = DictionaryService(
    DictionaryRepository(),
  );
  Future<WordDefinition?>? _wordDefinition;
  final TextEditingController _searchController = TextEditingController();

  List<String> _recentSearches = [];
  String _searchedWord = '';
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _searchedWord = widget.searchWord ?? '';
    if (_searchedWord.isNotEmpty) {
      _searchWord(_searchedWord);
    }
    _loadRecentSearches();
    _clearRecentWords();
  }

  @override
  bool get wantKeepAlive => true;

  // Load recent searches from SharedPreferences
  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('Recent Searched Words') ?? [];
    });
  }

  // Save recent searches to SharedPreferences
  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('Recent Searched Words', _recentSearches);
  }

  // Function to clear all recent searches
  Future<void> _clearRecentWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.clear(); // Clear the in-memory list
    });
    await prefs.remove(
      'Recent Searched Words',
    ); // Remove from SharedPreferences
  }

  // Function to fetch word meaning and update recent searches
  void _searchWord(String word) {
    _fetchDefinition(word);
    setState(() {
      _searchedWord = word;
      if (!_recentSearches.contains(word)) {
        _recentSearches.add(word); // Add to recent searches
        _saveRecentSearches(); // Save to local storage
      }
    });
  }

  void _fetchDefinition(String word) {
    setState(() {
      _wordDefinition = _dictionaryService.getWordDefinition(word);
    });
  }

  // Hide the keyboard when the user scrolls
  void _hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // Function to handle speech recognition
  void _listen() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(
        onError: (val) {
          setState(() {}); // Reset on error
        },
      );

      if (available) {
        _speech.listen(
          onResult: (val) {
            _searchController.text = val.recognizedWords;
            _searchedWord = _searchController.text;
            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _stopListening();
            }
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  // Helper function to stop listening
  void _stopListening() async {
    await _speech.stop();
    if (mounted) {
      // Check if the widget is still part of the widget tree
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _hideKeyboard(context);
      },
      child: Scaffold(
        backgroundColor: bgColor,
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.dictionary),
          backgroundColor: bgColor,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context)!.hintTextForSearchWord,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
                borderSide: BorderSide(color: borderColor),
              ),
              suffixIcon:
                  (_searchController.text.isNotEmpty)
                      ? searchButton()
                      : voiceInput(),
            ),
            onSubmitted: (text) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => ViewSearch(wordDefinition: _wordDefinition),
                ),
              );
              _searchWord(text);
              //_searchController.clear();
            },

            onChanged: (text) {
              setState(() {
                _searchedWord = text;
              });
            },
          ),
        ),
      ),
    );
  }

  Widget voiceInput() {
    return IconButton(
      onPressed: () {
        _listen();
      },
      icon: Image.asset('assets/icons/mic.png', scale: 16),
    );
  }

  Widget searchButton() {
    return IconButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ViewSearch(wordDefinition: _wordDefinition),
          ),
        );
        _searchWord(_searchController.text);
      },
      icon: Image.asset('assets/icons/search.png', scale: 16),
    );
  }
}
