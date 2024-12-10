import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../widgets/permission_handler.dart';
import 'colors.dart';

class MicWidget extends StatefulWidget {
  final double height;
  final double width;
  final ValueChanged<String> onResult;
  final String person1Language;
  final String person2Language;
  final bool person1or2;

  MicWidget({
    super.key,
    required this.onResult,
    required this.person1Language,
    required this.person2Language,
    required this.person1or2,
    required this.height,
    required this.width,
  });

  @override
  State<MicWidget> createState() => _MicWidgetState();
}

class _MicWidgetState extends State<MicWidget> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  //final TextEditingController _pauseForController = TextEditingController();
  bool _available = false;
  String lastStatus = '';
  bool _logEvents = false;
  String text = '';
  String person1Language = 'en';
  String person2Language = 'hi';

  @override
  void initState() {
    _initSpeech();
    _loadLanguagePreferences();
    super.initState();
    print('language 1 : ${widget.person1Language}');
    print('language 2 : ${widget.person2Language}');
  }

  @override
  void dispose() {
    //_initSpeech();
    super.dispose();
  }

  // Load the previously selected languages from SharedPreferences
  void _loadLanguagePreferences() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      person1Language = prefs.getString('person1Language') ?? 'en';
      person2Language = prefs.getString('person2Language') ?? 'hi';
    });
  }

  void _initSpeech() async {
    _available = await _speech.initialize(
      onStatus: statusListener,
    );
    setState(() {});
  }

  void _startListening() async {
    //_showSpeechRecognitionDialog();
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (_available) {
      await _speech.listen(
        localeId: (widget.person1or2) ? person1Language : person2Language,
        onResult: (text) {
          if (text.hasConfidenceRating && text.confidence > 0.5) {
            // Update the text with the recognized words
            _onSpeechResult(text.recognizedWords);
            _stopListening();
            //Navigator.pop(context);
          }
        },
      );
    }
    setState(() {});
  }

  void _onSpeechResult(String result) {
    setState(() {
      text = result;
    });
    widget.onResult(text);
  }

  void statusListener(String status) {
    _logEvent(
        'Received listener status: $status, listening: ${_speech.isListening}');
    setState(() {
      lastStatus = status;
    });

    print("lastStatus : $lastStatus");
    print("logEvent : $_logEvent");
  }

  void _logEvent(String eventDescription) {
    if (_logEvents) {
      var eventTime = DateTime.now().toIso8601String();
      debugPrint('$eventTime $eventDescription');
    }
  }

  // Helper function to stop listening
  void _stopListening() {
    _speech.stop();
    _speech.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      child: IconButton(
        onPressed: _speech.isNotListening ? _startListening : _stopListening,
        icon: Icon(
          _speech.isNotListening ? Icons.mic_none : Icons.mic,
          color: Colors.white,
        ),
        tooltip: 'Listen',
      ),
    );
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

  Widget _buildSpeechDialog() {
    return AlertDialog(
      backgroundColor: Colors.white,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_speech.lastStatus),
          SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 3,
              ),
            ),
          ),
        ],
      ),
    );
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
}
