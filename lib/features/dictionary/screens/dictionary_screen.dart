import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import '../../../data/models/Word_model.dart';
import '../../../data/repositories/word_repository.dart';
import '../../../data/services/word_service.dart';

class DictionaryScreen extends StatefulWidget {
  const DictionaryScreen({super.key});

  @override
  State<DictionaryScreen> createState() => _DictionaryScreenState();
}

class _DictionaryScreenState extends State<DictionaryScreen>
    with AutomaticKeepAliveClientMixin {
  final DictionaryService _dictionaryService =
      DictionaryService(DictionaryRepository());
  Future<WordDefinition?>? _wordDefinition;
  final TextEditingController _searchController = TextEditingController();

  List<String> _recentSearches = [];
  String _searchedWord = '';

  @override
  void initState() {
    super.initState();
    _loadRecentSearches(); // Load recent searches only once during initialization
  }

  @override
  bool get wantKeepAlive => true;

  // Load recent searches from SharedPreferences
  Future<void> _loadRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _recentSearches = prefs.getStringList('recent_searches') ?? [];
    });
  }

  // Save recent searches to SharedPreferences
  Future<void> _saveRecentSearches() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('recent_searches', _recentSearches);
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

  @override
  Widget build(BuildContext context) {
    super.build(
        context); // Need to call this because of AutomaticKeepAliveClientMixin
    final size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () {
        _hideKeyboard(
            context); // Hide the keyboard when tapping outside the TextField
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text('Dictionary'),
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: Column(
          children: [
            // Search Bar
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search for a word...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                    borderSide: BorderSide(color: borderColor),
                  ),
                  prefixIcon: Icon(Icons.search),
                ),
                onSubmitted: (text) {
                  _searchWord(text); // Perform search on submit
                  _searchController.clear(); // Clear input after search
                },
              ),
            ),

            // Recent Searches List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Recent Searches',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            _recentSearches.isNotEmpty
                ? Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (scrollNotification) {
                        if (scrollNotification is ScrollStartNotification) {
                          _hideKeyboard(
                              context); // Hide the keyboard when scrolling starts
                        }
                        return false;
                      },
                      child: ListView.builder(
                        itemCount: _recentSearches.length,
                        itemBuilder: (context, index) {
                          final word = _recentSearches[index];
                          return ListTile(
                            title: Text(word),
                            onTap: () {
                              _searchWord(word); // Search the word when tapped
                            },
                          );
                        },
                      ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      'No recent searches',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
          ],
        ),

        // Bottom Sheet for word meaning
        bottomSheet: _searchedWord.isNotEmpty
            ? FutureBuilder<WordDefinition?>(
                future: _wordDefinition,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SizedBox(
                      height: size.height * 0.3,
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      height: size.height * 0.3,
                      child: Center(child: Text('Error fetching meaning')),
                    );
                  } else if (snapshot.hasData && snapshot.data != null) {
                    final wordDefinition = snapshot.data!;
                    return Container(
                      height: size.height * 0.3,
                      width: size.width,
                      decoration: BoxDecoration(
                        color: bgColor,
                        border: Border.all(color: borderColor),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16),
                          topRight: Radius.circular(16),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '"${wordDefinition.word}" ',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10),
                            Expanded(
                              child: ListView(
                                children:
                                    wordDefinition.meanings.map((meaning) {
                                  return Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      '${meaning.partOfSpeech}: ${meaning.definitions.first.definition}',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: size.height * 0.3,
                      child: Center(
                          child: Text('No data found for "$_searchedWord"')),
                    );
                  }
                },
              )
            : SizedBox(), // Empty space if no word is searched
      ),
    );
  }
}
