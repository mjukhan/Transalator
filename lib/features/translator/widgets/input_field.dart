import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String sourceLanguage;

  const InputField(
      {super.key, required this.onChanged, required this.sourceLanguage});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to clear the input field
  void _clearInput() {
    _controller.clear();
    widget.onChanged(''); // Notify parent with empty string
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Text Input Widget
        Expanded(
          child: TextInputField(
            controller: _controller,
            hintText: 'Enter or speak text here', // Static hint text
            onChanged: (text) {
              widget.onChanged(text); // Pass text to parent widget
            },
          ),
        ),
        // Show clear button only when there is text
        if (_controller.text.isNotEmpty) ...[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearInput,
            tooltip: 'Clear',
          ),
        ],
        if (_controller.text.isEmpty) ...[
          // Voice Input Widget
          VoiceInputButton(
            onResult: (text) {
              _controller.text = text; // Update the text field with voice input
              widget
                  .onChanged(text); // Notify parent widget with recognized text
            },
            languageCode: widget.sourceLanguage,
          ),
        ],
      ],
    );
  }
}

// Separate widget for Text Input
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText, // Static hint text
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
      ),
      maxLines: null,
      style: TextStyle(fontSize: 24.0),
      onChanged: onChanged,
    );
  }
}

// Separate widget for Voice Input Button
class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onResult;
  final String languageCode; // Language code for speech recognition

  const VoiceInputButton(
      {super.key, required this.onResult, required this.languageCode});

  @override
  _VoiceInputButtonState createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();

  String _text = "";

  // Check microphone permission
  Future<bool> _checkMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (!status.isGranted) {
      status = await Permission.microphone.request();
    }
    return status.isGranted;
  }

  // Function to handle speech recognition
  void _listen() async {
    bool hasPermission = await _checkMicrophonePermission();
    if (!hasPermission) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Microphone permission is required.')),
      );
      return;
    }

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(onError: (val) {
        setState(() {}); // Reset on error
      });

      if (available) {
        _speech.listen(
            localeId: widget.languageCode,
            onResult: (val) {
              setState(() {
                _text = val.recognizedWords;
                // Trigger callback with recognized text
                widget.onResult(_text);
              });

              // Stop listening if the speech is complete
              if (val.hasConfidenceRating && val.confidence > 0.5) {
                _stopListening();
              }
            });
      }
    } else {
      _stopListening();
    }
  }

  // Helper function to stop listening
  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: _speech.isNotListening ? _listen : _stopListening,
      icon: Icon(_speech.isNotListening ? Icons.mic_none : Icons.mic),
      tooltip: 'Listen',
    );
  }
}
