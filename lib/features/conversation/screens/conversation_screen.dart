import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/core/widgets/permission_handler.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';
import 'package:flutter_tts/flutter_tts.dart';

class ConversationScreen extends StatefulWidget {
  final bool wifi;
  final String connectionStatus;
  const ConversationScreen({
    super.key,
    required this.wifi,
    required this.connectionStatus,
  });

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _person1Language = 'en';
  String _person2Language = 'es';
  String _inputText = '';
  String _translatedText = '';
  bool _isSpeaking = false;
  bool _isTranslating = false;
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();
  final TranslationService _translationService = TranslationService();
  final List<Map<String, String>> _translations = [];
  final ScrollController _scrollController = ScrollController();
  final FlutterTts _flutterTts = FlutterTts();
  final TextEditingController _pauseForController =
      TextEditingController(text: '5');
  final ValueNotifier<String> _speechStatus =
      ValueNotifier<String>("Speak Now...");

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
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

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _person1Language = prefs.getString('person1Language') ?? 'en';
      _person2Language = prefs.getString('person2Language') ?? 'es';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('person1Language', _person1Language);
    prefs.setString('person2Language', _person2Language);
  }

  void _translateText(
    String inputText,
    bool isSpeaker1,
    bool isSpeaker2,
  ) async {
    if (inputText.isEmpty) {
      setState(() {
        _isTranslating = true;
        _translatedText = '';
      });
      return;
    }

    // Show dialog for translation
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              AppLocalizations.of(context)!.translating, // "Translating..."
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Image.asset('assets/icons/translating.gif', scale: 6),
          ],
        ),
      ),
    );

    try {
      final translation = await _translationService.translate(
        text: inputText,
        from: isSpeaker1 ? _person1Language : _person2Language,
        to: isSpeaker1 ? _person2Language : _person1Language,
      );

      setState(() {
        _translatedText = translation;

        // Add the new translation to the list
        _translations.add({
          "input": inputText,
          "translated": translation,
          "person": isSpeaker1 ? "1" : "2",
        });

        _isTranslating = false;
      });
      // Scroll to the last item
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });

      Navigator.of(context).pop(); // Close translation dialog
    } catch (e) {
      ErrorHandlerTranslating.handleTranslationError(context, e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.errorInTranslation),
        ),
      );
      setState(() {
        _translatedText = AppLocalizations.of(context)!.errorInTranslation;
      });

      Navigator.of(context).pop();
    }
  }

  // Function to handle speech recognition
  void _listenPerson1() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    final pauseFor = int.tryParse(_pauseForController.text);

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(onError: (val) {
        setState(() {});
      }, onStatus: (val) {
        _speechStatus.value = val;

        if (kDebugMode) {
          print('status: $_speechStatus');
        }
      });
      if (!available) {
        snackMassage("Microphone not available");
        return;
      }
      _showSpeechRecognitionDialog();

      if (available) {
        _speech.listen(
          pauseFor: Duration(seconds: pauseFor ?? 5),
          localeId: _person1Language,
          onResult: (val) {
            _inputText = val.recognizedWords;
            _speechStatus.value = val.recognizedWords;
            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _stopListening();
              Navigator.pop(context);
              _translateText(_inputText, true, false);
            }
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  // Function to handle speech recognition
  void _listenPerson2() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    final pauseFor = int.tryParse(_pauseForController.text);

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(onError: (val) {
        setState(() {}); // Reset on error
      }, onStatus: (val) {
        _speechStatus.value = val;
        if (kDebugMode) {
          print('status: $_speechStatus');
        }
      });
      if (!available) {
        snackMassage("Microphone not available");
        return;
      }

      _showSpeechRecognitionDialog();

      if (available) {
        _speech.listen(
          pauseFor: Duration(seconds: pauseFor ?? 5),
          localeId: _person2Language,
          onResult: (val) {
            _inputText = val.recognizedWords;
            _speechStatus.value = val.recognizedWords;
            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _stopListening();
              Navigator.pop(context);
              _translateText(_inputText, false, true);
            }
          },
        );
      }
    } else {
      _stopListening();
    }
  }

  void _showSpeechRecognitionDialog() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => _buildSpeechDialog(),
    ).then((_) {
      _stopListening();
    });
  }

  // Helper function to stop listening
  void _stopListening() async {
    await _speech.stop();
  }

  @override
  void dispose() {
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.conversation),
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
              height: size.height * 0.7,
              width: size.width,
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: borderColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: _translatedText.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/icons/empty_conversation.png',
                          scale: 4,
                        ),
                        SizedBox(height: 20),
                        Text(
                          AppLocalizations.of(context)!.startConvo,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    )
                  : Container(
                      margin: EdgeInsets.fromLTRB(8, 8, 8, 8),
                      child: ListView.builder(
                        controller: _scrollController,
                        itemCount: _translations.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Container(
                            margin: EdgeInsets.fromLTRB(
                              (_translations[index]["person"] == '1') ? 0 : 50,
                              0,
                              (_translations[index]["person"] == '1') ? 50 : 0,
                              8,
                            ),
                            decoration: BoxDecoration(
                              color: (_translations[index]["person"] == '1')
                                  ? Colors.grey.shade200
                                  : Colors.blue,
                              borderRadius:
                                  (_translations[index]["person"] == '1')
                                      ? BorderRadius.only(
                                          topRight: Radius.circular(16),
                                          topLeft: Radius.circular(16),
                                          bottomRight: Radius.circular(16),
                                        )
                                      : BorderRadius.only(
                                          topLeft: Radius.circular(16),
                                          topRight: Radius.circular(16),
                                          bottomLeft: Radius.circular(16),
                                        ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(
                                    8,
                                    8,
                                    8,
                                    0,
                                  ),
                                  child: AutoSizeText(
                                    _translations[index]["input"].toString(),
                                    maxLines: null,
                                    maxFontSize: 24,
                                    minFontSize: 14,
                                    style: TextStyle(
                                      color: (_translations[index]['person'] ==
                                              '2')
                                          ? bgColor
                                          : Colors.black,
                                    ),
                                  ),
                                ),
                                _translations.isNotEmpty
                                    ? Divider(indent: 8, endIndent: 32)
                                    : SizedBox.shrink(),
                                // Translated Text Container
                                _translations.isNotEmpty
                                    ? Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                          8,
                                          0,
                                          8,
                                          0,
                                        ),
                                        child: AutoSizeText(
                                          _translations[index]['translated']
                                              .toString(),
                                          maxLines: null,
                                          maxFontSize: 24,
                                          minFontSize: 16,
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: (_translations[index]
                                                        ['person'] ==
                                                    '2')
                                                ? bgColor
                                                : Colors.black,
                                          ),
                                        ),
                                      )
                                    : SizedBox.shrink(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      onPressed: () => _handleTextToSpeech(
                                        _translations[index]["translated"]
                                            .toString(),
                                        (_translations[index]['person'] == '1')
                                            ? _person2Language
                                            : _person1Language,
                                      ),
                                      icon: Icon(
                                        Icons.volume_up,
                                        color: (_translations[index]
                                                    ['person'] ==
                                                '1')
                                            ? Colors.grey
                                            : bgColor,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
          SizedBox(
            height: 150,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: LanguageSelector(
                          selectedLanguage: _person1Language,
                          onLanguageChanged: (newLang) {
                            setState(() {
                              // Update source language
                              _person1Language = newLang;
                            });
                            _saveLanguagePreferences();
                          },
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (widget.wifi)
                          ? _listenPerson1
                          : () => snackMassage(widget.connectionStatus),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          color: micColor,
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(Icons.mic_none, color: Colors.white),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: 50,
                      width: 120,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                        border: Border.all(color: borderColor),
                      ),
                      child: Center(
                        child: LanguageSelector(
                          selectedLanguage: _person2Language,
                          onLanguageChanged: (newLang) {
                            setState(() {
                              // Update target language
                              _person2Language = newLang;
                            });
                            _saveLanguagePreferences();
                          },
                          fontSize: 14,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (widget.wifi)
                          ? _listenPerson2
                          : () => snackMassage(widget.connectionStatus),
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                          color: micColor,
                        ),
                        child: Icon(Icons.mic_none, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleTextToSpeech(String text, String languageCode) async {
    if (_isSpeaking) {
      await _flutterTts.stop(); // Stop speaking if already speaking
      setState(() {
        _isSpeaking = false;
      });
      return;
    }

    if (text.isNotEmpty) {
      setState(() {
        _isSpeaking = true; // Start speaking state
      });

      await _flutterTts.setLanguage(languageCode);
      await _flutterTts.setPitch(1.0);
      await _flutterTts.setSpeechRate(0.5);

      // Speak the text and handle completion
      await _flutterTts.speak(text);

      _flutterTts.setCompletionHandler(() {
        setState(() {
          _isSpeaking = false; // Reset to original icon when speech completes
        });
      });

      _flutterTts.setErrorHandler((error) {
        setState(() {
          _isSpeaking = false; // Reset on error
        });
      });
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No Text to Speak")));
    }
  }

  Widget _buildSpeechDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: ValueListenableBuilder<String>(
        valueListenable: _speechStatus,
        builder: (context, status, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                status,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    width: 3,
                    color: (status == 'done') ? Colors.red : micColor,
                  ),
                ),
                child: Icon(Icons.mic,
                    size: 64,
                    color: (status == 'done') ? Colors.red : micColor),
              ),
            ],
          );
        },
      ),
    );
  }
}
