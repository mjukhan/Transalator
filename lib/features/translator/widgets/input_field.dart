import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String sourceLanguage;

  InputField({required this.onChanged, required this.sourceLanguage});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController _controller = TextEditingController();

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
        // Voice Input Widget
        VoiceInputButton(
          onResult: (text) {
            _controller.text = text; // Update the text field with voice input
            widget.onChanged(text); // Notify parent widget with recognized text
          },
        ),
      ],
    );
  }
}

// Separate widget for Text Input
class TextInputField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;
  final String hintText;

  TextInputField({
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
      style: TextStyle(fontSize: 20.0),
      onChanged: onChanged,
    );
  }
}

// Separate widget for Voice Input Button
class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onResult;

  VoiceInputButton({required this.onResult});

  @override
  _VoiceInputButtonState createState() => _VoiceInputButtonState();
}

class _VoiceInputButtonState extends State<VoiceInputButton> {
  final stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
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

    if (!_isListening) {
      bool available = await _speech.initialize(onError: (val) {
        setState(() => _isListening = false); // Reset on error
      });

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            widget.onResult(_text); // Trigger callback with recognized text
          });

          // Stop listening if the speech is complete
          if (val.hasConfidenceRating && val.confidence > 0.5) {
            _stopListening();
          }
        });
      }
    } else {
      _stopListening(); // Stop listening if already listening
    }
  }

  // Helper function to stop listening
  void _stopListening() {
    setState(() => _isListening = false);
    _speech.stop();
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
      onPressed: _listen,
    );
  }
}
