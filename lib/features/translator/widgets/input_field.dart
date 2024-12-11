import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:translation_app/core/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:translation_app/core/widgets/example.dart';
import '../../File/screens/picture.dart';
import '../../File/widgets/imagePickerUtility.dart';

class InputField extends StatefulWidget {
  final ValueChanged<String> onChanged;
  final String sourceLanguage;
  final String targetLanguage;
  final bool wifi;
  final String connectionStatus;

  const InputField({
    super.key,
    required this.onChanged,
    required this.sourceLanguage,
    required this.wifi,
    required this.connectionStatus,
    required this.targetLanguage,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final TextEditingController _controller = TextEditingController();
  final stt.SpeechToText _speech = stt.SpeechToText();

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
          builder: (context) => PictureScreen(
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
            hintText: (_speech.isListening)
                ? 'Listening...'
                : AppLocalizations.of(context)!.hintTextTranslation,
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
              MicWidget(
                onResult: (text) {
                  _controller.text = text;
                  widget.onChanged(text);
                  print(text);
                },
                person1Language: widget.sourceLanguage,
                person2Language: widget.targetLanguage,
                person1or2: true,
                height: 40.0,
                width: 40.0,
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
