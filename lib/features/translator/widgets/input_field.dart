import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;

  InputField({required this.onChanged});

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  TextEditingController _controller = TextEditingController();
  double _fontSize = 20.0;
  stt.SpeechToText _speech = stt.SpeechToText();
  bool _isListening = false;
  String _text = "";

  @override
  void initState() {
    super.initState();
    // Listen for changes in the text field
    _controller.addListener(() {
      setState(() {
        _text = _controller.text; // Update text based on input field
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to check microphone permission
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
      bool available = await _speech.initialize(
        onError: (val) {
          setState(() => _isListening = false); // Reset on error
        },
      );

      if (available) {
        setState(() => _isListening = true);
        _speech.listen(onResult: (val) {
          setState(() {
            _text = val.recognizedWords;
            _controller.text = _text; // Update the input field
            widget.onChanged(_text); // Trigger callback with recognized text
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

  // Function to clear the input field
  void _clearInput() {
    _controller.clear(); // Clear the TextField
    widget.onChanged(''); // Notify parent with empty string
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _controller,
            decoration: InputDecoration(
              hintText: 'Enter or speak text here',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
            ),
            maxLines: null,
            style: TextStyle(fontSize: _fontSize),
            onChanged: (text) {
              widget.onChanged(text); // Pass text to parent
            },
          ),
        ),
        // Show clear button only when there is text
        if (_text.isNotEmpty) ...[
          IconButton(
            icon: Icon(Icons.clear), // Clear button icon
            onPressed: _clearInput, // Clear input action
            tooltip: 'Clear',
          ),
        ],
        IconButton(
          icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
          onPressed: _listen, // Trigger voice input
        ),
      ],
    );
  }
}
