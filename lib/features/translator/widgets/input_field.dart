import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/core/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/widgets/permission_handler.dart';
import '../../File/screens/picture.dart';
import '../../File/widgets/imagePickerUtility.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String sourceLanguage;
  final bool wifi;
  final String connectionStatus;

  const InputField({
    super.key,
    required this.onChanged,
    required this.sourceLanguage,
    required this.wifi,
    required this.connectionStatus,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

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

  // Function to paste the last copied text into the input field (_inputText)
  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _controller.text = clipboardData.text!;
      });
      widget.onChanged(_controller.text);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Clipboard is empty')));
    }
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
          builder:
              (context) => PictureScreen(
                imageFile: imageFile!,
                wifi: widget.wifi,
                connectionStatus: widget.connectionStatus,
              ),
        ),
      );
    }
  }

  Widget _cameraButton() {
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

  Widget _pasteButton() {
    return Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
      margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
      height: 40,
      width: 40,
      child: Center(
        child: IconButton(
          onPressed: () => _pasteFromClipboard(),
          icon: Icon(Icons.paste, color: bgColor),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Text Input Widget
        Expanded(
          child: TextInputField(
            controller: _controller,
            hintText: AppLocalizations.of(context)!.hintTextTranslation,
            onChanged: (text) {
              setState(() {
                _controller.text = text;
              });
              widget.onChanged(text); // Pass text to parent widget
            },
          ),
        ),
        if (_controller.text.isNotEmpty) ...[
          IconButton(
            icon: Icon(Icons.clear),
            onPressed: _clearInput,
            tooltip: 'Clear',
          ),
        ],

        // Show clear button only when there is text
        if (_controller.text.isEmpty) ...[
          // Voice Input Widget
          Column(
            children: [
              VoiceInputButton(
                onResult: (text) {
                  setState(() {
                    _controller.text = text;
                  });
                  widget.onChanged(
                    text,
                  ); // Notify parent widget with recognized text
                },
                languageCode: widget.sourceLanguage,
              ),
              _cameraButton(),
              _pasteButton(),
            ],
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
        hintText: hintText,
        helperMaxLines: 1,
        hintStyle: TextStyle(fontSize: 24, color: Colors.grey.shade500),
        border: InputBorder.none,
        contentPadding: EdgeInsets.fromLTRB(16, 20, 16, 16),
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

  // Function to handle speech recognition
  void _listen() async {
    if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(
        onError: (val) {
          setState(() {}); // Reset on error
        },
      );

      if (available) {
        _speech.listen(
          localeId: widget.languageCode,
          onResult: (val) {
            _text = val.recognizedWords;
            widget.onResult(_text);

            // Stop listening if the speech is complete
            if (val.hasConfidenceRating && val.confidence > 0.5) {
              _stopListening();
            }
          },
          listenOptions: stt.SpeechListenOptions().cancelOnError,
        );
      }
    } else {
      _stopListening();
    }
  }

  // Helper function to stop listening
  void _stopListening() async {
    await _speech.stop();
    if (mounted) {
      // Check if the widget is still part of the widget tree
      setState(() {});
    }
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
