import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'permission_handler.dart';
import '../utilities/colors.dart';

class MicWidget extends StatefulWidget {
  final double height;
  final double width;
  final ValueChanged<String> onResult;
  final String person1Language;
  final String person2Language;
  final bool person1or2;

  const MicWidget({
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
  bool _available = false;
  String lastStatus = '';
  //final bool _logEvents = false;
  String text = '';
  bool _isListening = false;

  @override
  void initState() {
    _initSpeech();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initSpeech() async {
    _available = await _speech.initialize(
      onStatus: statusListener,
    );
    setState(() {});
  }

  void _startListening() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;
    if (_available) {
      setState(() {
        _isListening = true;
      });
      _showSpeechRecognitionDialog();
      await _speech.listen(
        localeId: (widget.person1or2)
            ? widget.person1Language
            : widget.person2Language,
        onResult: (text) {
          if (text.hasConfidenceRating && text.confidence > 0.5) {
            // Update the text with the recognized words
            _onSpeechResult(text.recognizedWords);
            _stopListening();
            setState(() {
              _isListening = false;
            });
            Navigator.pop(context);
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
    // _logEvent(
    //     'Received listener status: $status, listening: ${_speech.isListening}');
    setState(() {
      lastStatus = status;
    });
  }

  // void _logEvent(String eventDescription) {
  //   if (_logEvents) {
  //     var eventTime = DateTime.now().toIso8601String();
  //     debugPrint('$eventTime $eventDescription');
  //   }
  // }

  // Helper function to stop listening
  void _stopListening() {
    _speech.stop();
    _speech.cancel();
    setState(() {
      _isListening = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
      height: widget.height,
      width: widget.width,
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      child: IconButton(
        onPressed: !_isListening ? _startListening : _stopListening,
        icon: Icon(
          !_isListening ? Icons.mic_none : Icons.mic,
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
          Text(
            AppLocalizations.of(context)!.listening,
            key: const ValueKey<String>('listening'),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          IconButton(
            onPressed: () {
              _speech.stop();
              Navigator.pop(context);
            },
            icon: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  width: 3,
                  color: micColor,
                ),
              ),
              child: Icon(Icons.mic, size: 64, color: micColor),
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
