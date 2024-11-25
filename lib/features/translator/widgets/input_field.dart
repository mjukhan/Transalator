import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/widgets/permission_handler.dart';

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
  final stt.SpeechToText _speech = stt.SpeechToText();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // Function to clear input text
  void _clearInput() {
    _controller.clear();
    widget.onChanged(_controller.text); // Notify parent with an empty string
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

  // Function to paste the last copied text into the input field (_inputText)
  void _pasteFromClipboard() async {
    final clipboardData = await Clipboard.getData('text/plain');
    if (clipboardData != null && clipboardData.text != null) {
      setState(() {
        _controller.text = clipboardData.text!;
        print('paste controller.text = ${_controller.text}');
      });
      widget.onChanged(_controller.text);
      print("input text after paster : ${_controller.text}");
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Clipboard is empty')));
    }
  }

  // Function to handle speech recognition
  void _listen() async {
    //if (!await PermissionHelper().checkMicrophonePermission()) return;

    if (_speech.isNotListening) {
      bool available = await _speech.initialize(
        onError: (_) => setState(() {}),
      );
      if (available) {
        _speech.listen(
          onResult: (val) {
            setState(() {
              _controller.text = val.recognizedWords;
              print('at time of speech = ${_controller.text}');
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
    return Stack(
      children: [
        // Main Row with Text Input or Voice Input
        widget.isTextInput ? buildTextInput() : buildVoiceInput(),
        if (_controller.text.isEmpty && !widget.isVoiceInput)
          Positioned(
            top: 16,
            right: 0,
            child: IconButton(
              onPressed: () => _pasteFromClipboard(),
              icon: Icon(Icons.paste),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(pasteButtonColor),
              ),
            ),
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
        hintStyle: TextStyle(fontSize: 18, color: Colors.grey.shade500),
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

// // Separate widget for Voice Input Button
// class VoiceInputButton extends StatefulWidget {
//   final ValueChanged<String> onResult;
//   final String languageCode;
//
//   const VoiceInputButton({
//     super.key,
//     required this.onResult,
//     required this.languageCode,
//   });
//
//   @override
//   _VoiceInputButtonState createState() => _VoiceInputButtonState();
// }
//
// class _VoiceInputButtonState extends State<VoiceInputButton> {
//   final stt.SpeechToText _speech = stt.SpeechToText();
//   String _text = " ";
//
//   // Function to handle speech recognition
//   void _listen() async {
//     //if (!await PermissionHelper().checkMicrophonePermission()) return;
//
//     if (_speech.isNotListening) {
//       bool available = await _speech.initialize(
//         onError: (_) => setState(() {}),
//       );
//       if (available) {
//         _speech.listen(
//           localeId: widget.languageCode,
//           onResult: (val) {
//             setState(() {
//               _text = val.recognizedWords;
//               print('at time of speech = $_text');
//             });
//             // Triggering the parent widget's callback
//             if (widget.onResult != null) {
//               print('Passing Result to Parent: $_text'); // Debugging log
//               widget.onResult(_text); // Notify parent
//             }
//
//             if (val.hasConfidenceRating && val.confidence > 0.5) {
//               _stopListening();
//             }
//           },
//         );
//       }
//     } else {
//       _stopListening();
//     }
//   }
//
//   // Stop listening
//   void _stopListening() async {
//     await _speech.stop();
//     setState(() {});
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: EdgeInsets.fromLTRB(0, 16, 16, 0),
//       height: 40,
//       width: 40,
//       decoration: BoxDecoration(shape: BoxShape.circle, color: micColor),
//       child: IconButton(
//         onPressed: _speech.isNotListening ? _listen : _stopListening,
//         icon: Icon(
//           _speech.isNotListening ? Icons.mic_none : Icons.mic,
//           color: Colors.white,
//         ),
//         tooltip: 'Listen',
//       ),
//     );
//   }
// }
