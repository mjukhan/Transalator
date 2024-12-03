import 'dart:async';
import 'package:auto_size_text/auto_size_text.dart';
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
import 'package:flutter_tts/flutter_tts.dart';

class DictionaryScreen extends StatefulWidget {
  final String? searchWord;
  final bool wifi;
  final String connectionStatus;
  const DictionaryScreen({
    super.key,
    this.searchWord,
    required this.wifi,
    required this.connectionStatus,
  });

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with AutomaticKeepAliveClientMixin {
  final DictionaryService _dictionaryService = DictionaryService(
    DictionaryRepository(),
  );
  Future<WordDefinition?>? _wordDefinition;
  Future<WordDefinition?>? _wordOfTheDay;
  final TextEditingController _searchController = TextEditingController();
  final FlutterTts _flutterTts = FlutterTts();
  String _todayWord = '';
  List<String> _recentSearches = [];
  String _searchedWord = '';
  bool _isSpeaking = false;
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void initState() {
    super.initState();
    _searchedWord = widget.searchWord ?? '';
    if (_searchedWord.isNotEmpty) {
      _searchWord(_searchedWord);
    }
    _loadRecentSearches();

    fetchRandomWord();
    _searchController.clear();
  }

  @override
  bool get wantKeepAlive => true;

  // Load recent searches from SharedPreferences
  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('Recent Words') ?? [];
    });
  }

  // Save recent searches to SharedPreferences
  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('Recent Words', _recentSearches);
  }

  // Function to clear all recent searches
  Future<void> _clearRecentWords() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches.clear(); // Clear the in-memory list
    });
    await prefs.remove('Recent Words'); // Remove from SharedPreferences
  }

  // Function to fetch word meaning and update recent searches
  void _searchWord(String word) {
    _fetchDefinition(word);
    setState(() {
      _searchedWord = word;
      if (!_recentSearches.contains(word)) {
        _recentSearches.add(word); // Add to recent searches
        _saveRecentSearches(); // Save to local storage
        _searchController.clear();
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

  void fetchRandomWord() async {
    // Example: Fetch a random word from your service
    final randomWord =
        await _dictionaryService
            .getRandomWord(); // Adjust according to your API
    setState(() {
      _wordOfTheDay = _dictionaryService.getWordDefinition(randomWord!);
    });
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
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
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
                          (context) =>
                              ViewSearch(wordDefinition: _wordDefinition),
                    ),
                  );
                  _searchWord(text);
                  _searchController.clear();
                },

                onChanged: (text) {
                  setState(() {
                    _searchedWord = text;
                  });
                },
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
              padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
              decoration: BoxDecoration(
                color: Colors.yellow.shade100,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      AutoSizeText(
                        AppLocalizations.of(context)!.wordOfTheDay,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          !_isSpeaking ? _tts(_todayWord) : _stop_tts();
                        },

                        child:
                            _isSpeaking
                                ? Icon(
                                  Icons.stop_circle_outlined,
                                  size: 18,
                                  color: Colors.blue,
                                )
                                : Icon(
                                  Icons.volume_up,
                                  size: 18,
                                  color: Colors.blue,
                                ),
                      ),
                    ],
                  ),
                  Divider(),
                  FutureBuilder<WordDefinition?>(
                    future: _wordOfTheDay,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError ||
                          !snapshot.hasData ||
                          !widget.wifi) {
                        return Center(
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final wordDefinition = snapshot.data!;
                      _todayWord = wordDefinition.word;

                      print("today word : $_todayWord");

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            maxFontSize: 12,
                            minFontSize: 8,
                            wordDefinition.word,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue,
                            ),
                          ),
                          AutoSizeText(
                            maxFontSize: 12,
                            minFontSize: 8,
                            maxLines: null,
                            wordDefinition
                                .meanings
                                .first
                                .definitions[0]
                                .definition,
                            wrapWords: true,
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),

            // Recent Searches List
            Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.recentSearches,
                    style: TextStyle(fontSize: 14),
                  ),
                  (_recentSearches.isNotEmpty)
                      ? TextButton(
                        onPressed: _clearRecentWords,
                        child: Text('Clear all'),
                      )
                      : SizedBox.shrink(),
                ],
              ),
            ),
            _recentSearches.isNotEmpty
                ? Expanded(
                  child: NotificationListener<ScrollNotification>(
                    onNotification: (scrollNotification) {
                      if (scrollNotification is ScrollStartNotification) {
                        _hideKeyboard(context);
                      }
                      return false;
                    },
                    child: ListView.builder(
                      itemCount: _recentSearches.length,
                      itemBuilder: (context, index) {
                        final word = _recentSearches[index];
                        return ListTile(
                          leading: Icon(
                            Icons.access_time_rounded,
                            color: Colors.grey,
                          ),
                          title: Text(word),
                          onTap: () {
                            _searchWord(word);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) => ViewSearch(
                                      wordDefinition: _wordDefinition,
                                    ),
                              ),
                            );
                          },
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                )
                : Expanded(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(0, size.height * 0.2, 0, 50),
                    child: Text(AppLocalizations.of(context)!.findWordBySearch),
                  ),
                ),
          ],
        ),
      ),
    );
  }

  Widget voiceInput() {
    return Container(
      margin: EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      child: IconButton(
        onPressed: () {
          _listen();
        },
        icon: Icon(Icons.mic, color: bgColor),
      ),
    );
  }

  Widget searchButton() {
    return Container(
      margin: EdgeInsets.all(8),
      height: 40,
      width: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      child: IconButton(
        onPressed: () {
          if (widget.wifi) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => ViewSearch(wordDefinition: _wordDefinition),
              ),
            );
            _searchWord(_searchController.text);
            _searchController.clear();
          } else {
            snackMassage(widget.connectionStatus);
          }
        },
        icon: Icon(Icons.search, color: bgColor),
      ),
    );
  }

  Future<void> _tts(String text) async {
    setState(() {
      _isSpeaking = false;
    });

    if (text.isNotEmpty) {
      await _flutterTts.setLanguage('en');
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);
      setState(() {
        _isSpeaking = true; // Start speaking state
      });

      // Speak the text and handle completion
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false;
        });
      });

      _flutterTts.setErrorHandler((error) {
        setState(() {
          _isSpeaking = false;
        });
      });
    } else {
      snackMassage("No Word, or No Internet");
    }
  }

  void _stop_tts() {
    _flutterTts.stop();
    setState(() {
      _isSpeaking = false;
    });
  }
}
