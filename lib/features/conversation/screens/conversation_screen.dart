import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../../../core/widgets/translator_provider.dart';
import '../../translator/widgets/error_handler.dart';
import '../../translator/widgets/language_selector.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({super.key});

  @override
  State<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String _person1Language = 'auto';
  String _person2Language = 'ur';
  String _inputText = '';
  String _translatedText = '';
  bool speaker1 = false;
  bool speaker2 = false;
  bool _isListeningPerson1 = false;
  bool _isListeningPerson2 = false;
  final TextEditingController _controller = TextEditingController();

  final stt.SpeechToText _speech =
      stt.SpeechToText(); // Speech-to-text instance
  final TranslationService _translationService = TranslationService();

  void _translateText(String inputText, bool speaker1, bool speaker2) async {
    if (inputText.isEmpty) {
      setState(() {
        _translatedText = ''; // Clear translated text if input is empty
      });
      return;
    }

    try {
      // Call the translation service
      if (speaker1) {
        final translation = await _translationService.translate(
          text: inputText,
          from: _person1Language,
          to: _person2Language,
        );
        setState(() {
          _translatedText = translation;
        });
      }
      if (speaker2) {
        final translation = await _translationService.translate(
          text: inputText,
          from: _person2Language,
          to: _person1Language,
        );
        setState(() {
          _translatedText = translation;
        });
      }
    } catch (e) {
      // Use centralized error handler to manage the error
      ErrorHandler.handleTranslationError(context, e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error in translation')),
      );
      setState(() {
        _translatedText = 'Error in translation';
      });
    }
  }

  // Check microphone permission
  Future<bool> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  // Method to handle speech recognition for source language (Person 1)
  void _listenPerson1() async {
    bool hasPermission = await _checkMicrophonePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }
    if (!_isListeningPerson1) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListeningPerson1 = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _inputText = '';
            _translatedText = '';
            _inputText = val.recognizedWords;
            _controller.text = _inputText;
            setState(() {
              speaker2 = false;
              speaker1 = true;
            });
            _translateText(_inputText, speaker1, speaker2);
            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _speech.stop();
              _isListeningPerson1 = false;
            }
          });
        });
      }
    } else {
      setState(() {
        _speech.stop();
        _isListeningPerson1 = false;
      });
    }
  }

  // Method to handle speech recognition for target language (Person 2)
  void _listenPerson2() async {
    bool hasPermission = await _checkMicrophonePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }
    if (!_isListeningPerson2) {
      bool available = await _speech.initialize();
      if (available) {
        setState(() {
          _isListeningPerson2 = true;
        });
        _speech.listen(onResult: (val) {
          setState(() {
            _inputText = '';
            _translatedText = '';
            _inputText = val.recognizedWords;
            _controller.text = _inputText;
            setState(() {
              speaker1 = false;
              speaker2 = true;
            });
            _translateText(_inputText, speaker1, speaker2);
            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _speech.stop();
              _isListeningPerson2 = false;
            }
          });
        });
      }
    } else {
      setState(() {
        _speech.stop();
        _isListeningPerson2 = false;
      });
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    if (_speech.isListening) {
      _speech.stop();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 248, 249, 250),
      appBar: AppBar(
        title: Text("Conversation"),
        backgroundColor: bgColor,
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
            height: size.height * 0.6,
            width: size.width,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Container(
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: size.height * 0.25,
                      width: size.width,
                      //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      // decoration: BoxDecoration(
                      //   border: Border.all(color: Colors.yellow),
                      // ),
                      child: AutoSizeText(
                        _inputText,
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                          fontSize: 32,
                        ),
                        maxFontSize: 32,
                        minFontSize: 24,
                        maxLines: null,
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      color: dividerColor.withOpacity(0.5),
                    ),
                    // Translated Text Container
                    SizedBox(
                      height: size.height * 0.25,
                      width: size.width,
                      //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      child: AutoSizeText(
                        _translatedText, // Display the translated text here
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          color: Colors.black87,
                        ),
                        maxFontSize: 32,
                        minFontSize: 24,
                        maxLines: null,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: size.height * 0.2,
            width: size.width,
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: size.height * 0.05,
                      width: size.width * 0.4,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person1Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            // Update source language
                            _person1Language = newLang;
                            print('person 1 lang : $_person1Language');
                            print('person 2 lang : $_person2Language');
                          });
                          if (_inputText.isNotEmpty) {
                            _translateText(_inputText, speaker1, speaker2);
                          }
                        },
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap: _listenPerson1,
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(
                          _isListeningPerson1 ? Icons.mic : Icons.mic_none,
                        ),
                      ),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      height: size.height * 0.05,
                      width: size.width * 0.4,
                      margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
                      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
                      decoration: BoxDecoration(
                        color: langSelectorColor,
                        borderRadius: BorderRadius.circular(32),
                      ),
                      child: LanguageSelector(
                        selectedLanguage: _person2Language,
                        onLanguageChanged: (newLang) {
                          setState(() {
                            // Update target language
                            _person2Language = newLang;
                            print('person 1 lang : $_person1Language');
                            print('person 2 lang : $_person2Language');
                          });
                          if (_inputText.isNotEmpty) {
                            _translateText(_inputText, speaker1, speaker2);
                          }
                        },
                        fontSize: 12,
                      ),
                    ),
                    GestureDetector(
                      onTap:
                          _listenPerson2, // Call the listen method for person 2
                      child: Container(
                        height: 60,
                        width: 60,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: borderColor),
                        ),
                        child: Icon(
                          _isListeningPerson2 ? Icons.mic : Icons.mic_none,
                        ),
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
}
