import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String sourceLanguage;
  final bool isVoiceInput;
  final bool isTextInput;
  final dynamic Function(String) onSubmit;

  const InputField({
    super.key,
    required this.onChanged,
    required this.sourceLanguage,
    required this.isVoiceInput,
    required this.isTextInput,
    required this.onSubmit,
  });

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

  // Function to clear input text
  void _clearInput() {
    _controller.clear();
    widget.onChanged(''); // Notify parent with an empty string
  }

  // Function for text input logic
  Widget buildTextInput() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 36, 0),
      child: TextInputField(
        controller: _controller,
        hintText: AppLocalizations.of(context)!.hintTextTranslation,
        onChanged: (text) {
          setState(() {
            _controller.text = text; // Ensure text is updated in the controller
          });
          widget.onChanged(text); // Pass text to the parent widget
        },
        onSubmit: widget.onSubmit,
      ),
    );
  }

  // Function for voice input logic
  Widget buildVoiceInput() {
    return VoiceInputButton(
      onResult: (text) {
        setState(() {
          _controller.text = text; // Update text input field with voice result
        });
        widget.onChanged(text); // Notify parent widget with recognized text
      },
      languageCode: widget.sourceLanguage,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Main Row with Text Input or Voice Input
        Row(
          children: [
            // Text Input Widget
            if (widget.isTextInput && !widget.isVoiceInput)
              Expanded(
                child: buildTextInput(),
              ),
            if (widget.isVoiceInput && !widget.isTextInput) buildVoiceInput(),
            if (widget.isTextInput && widget.isVoiceInput)
              Row(
                children: [
                  buildTextInput(),
                  buildVoiceInput(),
                ],
              ),
          ],
        ),
        // Clear Button Positioned in the Top Right
        if (_controller.text.isNotEmpty)
          Positioned(
            top: 16,
            right: 0,
            child: IconButton(
              icon: Icon(Icons.clear),
              onPressed: _clearInput,
              tooltip: 'Clear',
            ),
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
  final dynamic Function(String) onSubmit;

  const TextInputField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.onChanged,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      textInputAction: TextInputAction.done,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        hintText: hintText,
        helperMaxLines: 1,
        hintStyle: TextStyle(
          fontSize: 18,
          color: Colors.grey.shade500,
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 16),
      ),
      maxLines: null,
      onChanged: onChanged,
      onSubmitted: (value) {
        onSubmit(value);
      },
    );
  }
}

// Separate widget for Voice Input Button
class VoiceInputButton extends StatefulWidget {
  final ValueChanged<String> onResult;
  final String languageCode;

  const VoiceInputButton({
    super.key,
    required this.onResult,
    required this.languageCode,
  });

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
        SnackBar(
          content: Text(AppLocalizations.of(context)!.micPermissionRequired),
        ),
      );
      return;
    }

    if (_speech.isNotListening) {
      bool available =
          await _speech.initialize(onError: (_) => setState(() {}));
      if (available) {
        _speech.listen(
          localeId: widget.languageCode,
          onResult: (val) {
            setState(() {
              _text = val.recognizedWords;
              //widget.onResult(_text);
            });

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

  // Stop listening
  void _stopListening() async {
    await _speech.stop();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
      height: 40,
      width: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      child: IconButton(
        onPressed: _speech.isNotListening ? _listen : _stopListening,
        icon: Icon(
          _speech.isNotListening ? Icons.mic_none : Icons.mic,
          color: Colors.white,
        ),
        tooltip: 'Listen',
      ),
    );
  }
}
