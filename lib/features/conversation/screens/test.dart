// import 'package:auto_size_text/auto_size_text.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:translation_app/core/utilities/colors.dart';
// import 'package:speech_to_text/speech_to_text.dart' as stt;
// import '../../../core/widgets/translator_provider.dart';
// import '../../translator/widgets/error_handler.dart';
// import '../../translator/widgets/language_selector.dart';
//
// class ConversationScreen extends StatefulWidget {
//   const ConversationScreen({super.key});
//
//   @override
//   State<ConversationScreen> createState() => _ConversationScreenState();
// }
//
// class _ConversationScreenState extends State<ConversationScreen> {
//   String _sourceLanguage = 'en';
//   String _targetLanguage = 'ur';
//   String _inputText = '';
//   String _translatedText = '';
//   bool _isSourceListening = false;
//   bool _isTargetListening = false;
//   final TextEditingController _controller = TextEditingController();
//
//   final stt.SpeechToText _speech =
//       stt.SpeechToText(); // Speech-to-text instance
//   final TranslationService _translationService = TranslationService();
//
//   void _translateText(String inputText) async {
//     if (inputText.isEmpty) {
//       setState(() {
//         _translatedText = ''; // Clear translated text if input is empty
//       });
//       return;
//     }
//
//     try {
//       // Call the translation service
//       final translation = await _translationService.translate(
//           text: inputText, from: _sourceLanguage, to: _targetLanguage);
//
//       setState(() {
//         _translatedText = translation;
//       });
//     } catch (e) {
//       // Use centralized error handler to manage the error
//       ErrorHandler.handleTranslationError(context, e);
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Error in translation')),
//       );
//       setState(() {
//         _translatedText = 'Error in translation';
//       });
//     }
//   }
//
//   // Check microphone permission
//   Future<bool> _checkMicrophonePermission() async {
//     var status = await Permission.microphone.status;
//     if (!status.isGranted) {
//       status = await Permission.microphone.request();
//     }
//     return status.isGranted;
//   }
//
//   // Method to handle speech recognition for source language (Person 1)
//   void _listen() async {
//     bool hasPermission = await _checkMicrophonePermission();
//     if (!hasPermission) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Microphone permission is required.')),
//       );
//       return;
//     }
//     if (!_isSourceListening) {
//       bool available = await _speech.initialize();
//       if (available) {
//         _speech.listen(onResult: (val) {
//           setState(() {
//             _inputText = '';
//             _translatedText = '';
//             _inputText = val.recognizedWords;
//             _controller.text =
//                 _inputText; // Update the controller with recognized words
//             _translateText(_inputText); // Uncomment to translate automatically
//             // Stop listening if the speech is complete
//             if (val.hasConfidenceRating && val.confidence > 0.5) {
//               _speech.stop();
//             }
//           });
//         });
//       }
//     } else {
//       setState(() {
//         _speech.stop();
//       });
//     }
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//     _speech.stop();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final size = MediaQuery.of(context).size;
//     return Scaffold(
//       backgroundColor: Color.fromARGB(255, 248, 249, 250),
//       appBar: AppBar(
//         title: Text("Conversation"),
//         backgroundColor: bgColor,
//       ),
//       body: Column(
//         children: [
//           Container(
//             margin: EdgeInsets.fromLTRB(16, 4, 16, 0),
//             height: size.height * 0.6,
//             width: size.width,
//             decoration: BoxDecoration(
//               border: Border.all(color: borderColor),
//               borderRadius: BorderRadius.circular(16),
//             ),
//             child: Container(
//               margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     SizedBox(
//                       height: size.height * 0.25,
//                       width: size.width,
//                       //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                       // decoration: BoxDecoration(
//                       //   border: Border.all(color: Colors.yellow),
//                       // ),
//                       child: AutoSizeText(
//                         _inputText,
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           color: Colors.black87,
//                           fontSize: 32,
//                         ),
//                         maxFontSize: 32,
//                         minFontSize: 24,
//                         maxLines: null,
//                       ),
//                     ),
//                     Divider(
//                       thickness: 2,
//                       color: dividerColor.withOpacity(0.5),
//                     ),
//                     // Translated Text Container
//                     SizedBox(
//                       height: size.height * 0.25,
//                       width: size.width,
//                       //margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                       child: AutoSizeText(
//                         _translatedText, // Display the translated text here
//                         textAlign: TextAlign.start,
//                         style: TextStyle(
//                           color: Colors.black87,
//                         ),
//                         maxFontSize: 32,
//                         minFontSize: 24,
//                         maxLines: null,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//           SizedBox(
//             height: size.height * 0.2,
//             width: size.width,
//             child: Row(
//               children: [
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: [
//                     Container(
//                       height: size.height * 0.05,
//                       width: size.width * 0.4,
//                       margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
//                       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                       decoration: BoxDecoration(
//                         color: langSelectorColor,
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       child: LanguageSelector(
//                         selectedLanguage: _sourceLanguage,
//                         onLanguageChanged: (newLang) {
//                           setState(() {
//                             // Update source language
//                             _sourceLanguage = newLang;
//                           });
//                           if (_inputText.isNotEmpty) {
//                             _translateText(_inputText);
//                           }
//                         },
//                         fontSize: 12,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _listen,
//                       child: Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: borderColor),
//                         ),
//                         child: Icon(
//                           _isSourceListening ? Icons.mic : Icons.mic_none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 Column(
//                   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                   children: [
//                     Container(
//                       height: size.height * 0.05,
//                       width: size.width * 0.4,
//                       margin: EdgeInsets.fromLTRB(16, 16, 16, 8),
//                       padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
//                       decoration: BoxDecoration(
//                         color: langSelectorColor,
//                         borderRadius: BorderRadius.circular(32),
//                       ),
//                       child: LanguageSelector(
//                         selectedLanguage: _targetLanguage,
//                         onLanguageChanged: (newLang) {
//                           setState(() {
//                             // Update target language
//                             _targetLanguage = newLang;
//                           });
//                           if (_inputText.isNotEmpty) {
//                             _translateText(_inputText);
//                           }
//                         },
//                         fontSize: 12,
//                       ),
//                     ),
//                     GestureDetector(
//                       onTap: _listen, // Call the listen method for person 2
//                       child: Container(
//                         height: 60,
//                         width: 60,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           border: Border.all(color: borderColor),
//                         ),
//                         child: Icon(
//                           _isTargetListening ? Icons.mic : Icons.mic_none,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
