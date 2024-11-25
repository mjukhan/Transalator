import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/services.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/widgets/imagePickerUtility.dart';
import 'package:translation_app/features/translator/screens/setting/setting.dart';
import '../../../core/widgets/translator_provider.dart';
import '../../../core/widgets/permission_handler.dart';
import '../../File/screens/picture.dart';
import '../widgets/error_handler.dart';
import '../widgets/input_field.dart';
import '../widgets/language_selector.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;

class TranslatorScreen extends StatefulWidget {
  const TranslatorScreen({super.key});

  @override
  _TranslatorScreenState createState() => _TranslatorScreenState();
}

class _TranslatorScreenState extends State<TranslatorScreen> {
  String _sourceLanguage = 'en';
  String _targetLanguage = 'es';
  String _inputText = '';
  String _translatedText = '';
  bool _isSaved = false; // Toggle for changing the icon
  List<String> _savedTranslations = []; // List of saved translations
  final FlutterTts _flutterTts = FlutterTts();
  bool _isSpeaking = false;
  bool _isListening = false;
  final stt.SpeechToText _speech = stt.SpeechToText();

  final TranslationService _translationService = TranslationService();

  @override
  void initState() {
    super.initState();
    _loadLanguagePreferences();
    _loadSavedTranslations();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _sourceLanguage = prefs.getString('sourceLanguage') ?? 'en';
      _targetLanguage = prefs.getString('targetLanguage') ?? 'es';
    });
  }

  // Save the language preferences to SharedPreferences
  void _saveLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('sourceLanguage', _sourceLanguage);
    prefs.setString('targetLanguage', _targetLanguage);
  }

  // Load saved translations from SharedPreferences
  void _loadSavedTranslations() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _savedTranslations = prefs.getStringList('savedTranslations') ?? [];
    });
  }

  void _translateText(String inputText) async {
    //if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (!await PermissionHelper().checkWifiConnection(context)) {
      CircularProgressIndicator();
    }
    if (inputText.isEmpty) {
      setState(() {
        _translatedText = '';
      });
      return;
    }

    try {
      // Call the translation service
      final translation = await _translationService.translate(
        text: inputText,
        from: _sourceLanguage,
        to: _targetLanguage,
      );

      setState(() {
        _translatedText = translation; // Update translated text
      });
    } catch (e) {
      ErrorHandlerTranslating.handleTranslationError(context, e);
      setState(() {
        _translatedText = AppLocalizations.of(context)!.errorInTranslation;
      });
    }
  }

  void _saveInstance() async {
    final prefs = await SharedPreferences.getInstance();
    if (!_isSaved && _translatedText.isNotEmpty) {
      // Combine input and translated text into a map
      final instance = {
        'source': _sourceLanguage,
        'target': _targetLanguage,
        'input': _inputText,
        'translate': _translatedText,
      };
      _savedTranslations.add(jsonEncode(instance)); // Save as JSON string
      // Update SharedPreferences with the new list
      await prefs.setStringList(
        AppLocalizations.of(context)!.savedTranslations,
        _savedTranslations,
      );
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Translation saved!')));
      setState(() {
        _isSaved = true;
      });
    }
  }

  // Function to copy text to the clipboard
  void _copyToClipboard(String text) {
    Clipboard.setData(ClipboardData(text: text));
    print(text);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Text copied to clipboard')));
  }

  // Method to handle speech recognition for Person 1
  void _listen() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (!_isListening) {
      if (await _speech.initialize()) {
        setState(() {
          _isListening = true;
        });
        _speech.listen(
          onResult: (val) {
            setState(() {
              _inputText = val.recognizedWords;
            });

            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _speech.stop();
              setState(() {
                _isListening = false;
              });
            }
          },
        );
      }
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return SafeArea(
      child: Scaffold(
        floatingActionButton:
            _inputText.isNotEmpty && _translatedText.isEmpty
                ? FloatingActionButton.extended(
                  onPressed: () => _translateText(_inputText),
                  backgroundColor: translateButtonColor,
                  label: Text('Translate', style: TextStyle(color: bgColor)),
                )
                : SizedBox.shrink(),
        backgroundColor: Colors.grey.shade300,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: bgColor,
          title: Text(AppLocalizations.of(context)!.translation),
          scrolledUnderElevation: 0,
          leading: IconButton(
            icon: Icon(Icons.menu),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) =>
                          Setting(savedTranslation: _savedTranslations),
                ),
              );
            },
          ),
        ),
        body: Container(
          height: (_inputText.isEmpty) ? size.height * 0.7 : size.height,
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius:
                (_inputText.isEmpty)
                    ? BorderRadius.only(
                      bottomLeft: Radius.circular(36),
                      bottomRight: Radius.circular(36),
                    )
                    : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [_buildLanguageSelector(), _buildTranslationContainer()],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    final size = MediaQuery.of(context).size;
    return Container(
      height: size.height * 0.08,
      width: size.width,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLanguageDropdown(_sourceLanguage, (newLang) {
            setState(() {
              _sourceLanguage = newLang;
            });
            _saveLanguagePreferences();
            if (_inputText.isNotEmpty) _translateText(_inputText);
          }),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: changeLangColor,
              //3border: Border.all(color: Colors.grey)
            ),
            child: IconButton(
              icon: Icon(Icons.swap_horiz, color: micColor),
              onPressed: () {
                setState(() {
                  final temp = _sourceLanguage;
                  _sourceLanguage = _targetLanguage;
                  _targetLanguage = temp;
                });
                _saveLanguagePreferences();
                if (_inputText.isNotEmpty) _translateText(_inputText);
              },
            ),
          ),
          _buildLanguageDropdown(_targetLanguage, (newLang) {
            setState(() {
              _targetLanguage = newLang;
            });
            _saveLanguagePreferences();
            if (_inputText.isNotEmpty) _translateText(_inputText);
          }),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
    String selectedLanguage,
    Function(String) onChanged,
  ) {
    return Container(
      height: 50,
      width: 120,
      alignment: Alignment.center,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      decoration: BoxDecoration(
        color: langSelectorColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor),
      ),
      child: LanguageSelector(
        selectedLanguage: selectedLanguage,
        onLanguageChanged: onChanged,
        fontSize: 16,
      ),
    );
  }

  Widget _buildTranslationContainer() {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Stack(
          children: [
            // Main Content (Translation and Input)
            SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text Input Field at the Top
                  InputField(
                    onChanged: (text) {
                      setState(() {
                        _inputText = text;
                        _translatedText = '';
                        _isSaved = false;
                      });
                      //_translateText(_inputText);
                    },
                    sourceLanguage: '',
                    isVoiceInput: false,
                    isTextInput: true,
                    onSubmit: (_) => _translateText(_inputText),
                  ),
                  _inputText.isNotEmpty && _translatedText.isNotEmpty
                      ? _buildActionButtons(
                        true,
                        false,
                        false,
                        true,
                        _inputText,
                        _sourceLanguage,
                      )
                      : SizedBox.shrink(),
                  const SizedBox(height: 16),
                  (_translatedText.isNotEmpty)
                      ? _buildTranslatedText()
                      : SizedBox.shrink(),
                ],
              ),
            ),

            _inputText.isEmpty
                ? // Voice Input Icon at the Bottom Right
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: Row(
                    children: [
                      _cameraButton(),
                      InputField(
                        onChanged: (text) {
                          setState(() {
                            _inputText = text;
                            _translatedText = '';
                            _isSaved = false;
                          });
                          //_translateText(_inputText);
                        },
                        sourceLanguage: '',
                        isVoiceInput: true,
                        isTextInput: false,
                        onSubmit: (_) => _translateText(_inputText),
                      ),
                    ],
                  ),
                )
                : SizedBox.shrink(),
          ],
        ),
      ),
    );
  }

  Widget _buildTranslatedText() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Divider(),
        Container(
          //decoration: BoxDecoration(border: Border.all(color: Colors.yellow)),
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          child: FittedBox(
            child: AutoSizeText(
              _translatedText,
              textAlign: TextAlign.start,
              style: TextStyle(color: translatedTextColor),
              maxFontSize: 24,
              minFontSize: 18,
              maxLines: null,
            ),
          ),
        ),
        _buildActionButtons(
          true,
          true,
          true,
          true,
          _translatedText,
          _targetLanguage,
        ),
      ],
    );
  }

  Widget _buildActionButtons(
    bool copy,
    bool favorite,
    bool share,
    bool speak,
    String textToCopy,
    String languageCode,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        // IconButton(
        //   icon: const Icon(Icons.search),
        //   onPressed: _findInDictionary,
        //   tooltip: 'Find in Dictionary',
        // ),
        share
            ? IconButton(
              onPressed: () => shareTranslatedText(textToCopy),
              icon: Icon(Icons.share),
            )
            : SizedBox.shrink(),
        favorite
            ? IconButton(
              icon: Icon(_isSaved ? Icons.star : Icons.star_border),
              onPressed: _saveInstance,
              tooltip: 'Save Instance',
            )
            : SizedBox.shrink(),
        copy
            ? IconButton(
              icon: Icon(Icons.copy),
              onPressed: () => _copyToClipboard(textToCopy),
              tooltip: 'Copy',
            )
            : SizedBox.shrink(),
        speak
            ? IconButton(
              icon: Icon(Icons.volume_up),
              onPressed: () => _handleTextToSpeech(textToCopy, languageCode),
              tooltip: 'Speak',
            )
            : SizedBox.shrink(),
      ],
    );
  }

  _cameraButton() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
      height: 40,
      width: 40,
      child: Center(
        child: IconButton(
          onPressed: () => _getFromCamera(),
          icon: Icon(Icons.camera_alt, color: bgColor),
        ),
      ),
    );
  }

  void _getFromCamera() async {
    File? imageFile;
    File? file = await ImagePickerUtility.pickImageFromCamera(context);
    if (file != null) {
      setState(() {
        imageFile = file;
      });

      // Navigate to PictureScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PictureScreen(imageFile: imageFile!),
        ),
      ).then((result) {
        if (result != null) {
          setState(() {
            _inputText = result;
          });
        }
      });
    }
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
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please enter some text to speak.")),
      );
    }
  }

  Future<void> shareTranslatedText(String translation) async {
    if (translation.isNotEmpty) {
      Share.share(translation); // Share the text
    } else {
      // Handle case when text is empty
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No text to share.")));
    }
  }
}
