import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translator/translator.dart';
import 'dart:async';
import '../../../core/utilities/colors.dart';
import '../../translator/widgets/language_selector.dart';

class PictureScreen extends StatefulWidget {
  final File? imageFile;
  const PictureScreen({super.key, this.imageFile});

  @override
  State<PictureScreen> createState() => _PictureScreenState();
}

class _PictureScreenState extends State<PictureScreen> {
  final GoogleTranslator _translator = GoogleTranslator();

  String _detectedText = '';
  String _translatedText = '';
  bool _isLoading = false;

  String _sourceLanguage = 'auto'; // Set source language to auto-detect
  String _targetLanguage = 'ur'; // Default target language

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              // Display the image file
              if (widget.imageFile != null)
                SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: Image.file(
                    widget.imageFile!,
                    fit: BoxFit.fitWidth, // Change to cover for better fit
                  ),
                ),
              if (_isLoading)
                const Center(
                  child: CircularProgressIndicator(),
                ),
              // Detected and Translated Text Overlay
              if (!_isLoading &&
                  _detectedText.isNotEmpty &&
                  _translatedText.isNotEmpty)
                Positioned(
                  top: 100,
                  left: 20,
                  right: 20,
                  child: Column(
                    children: [
                      Text(
                        "Detected Text:\n$_detectedText",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      SizedBox(height: 10),
                      Text(
                        "Translated Text:\n$_translatedText",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.yellow),
                      ),
                    ],
                  ),
                ),
              _buildTextOverlay(),
              _buildBottomControls(size),
              // // Container and Button positioned at the bottom center
              // Column(
              //   mainAxisAlignment:
              //       MainAxisAlignment.end, // Align items at the bottom
              //   children: [
              //     Container(
              //       height: 50,
              //       width: 250,
              //       decoration: BoxDecoration(
              //           //border: Border.all(color: Colors.yellow),
              //           ),
              //       child: Row(
              //         mainAxisAlignment: MainAxisAlignment.spaceAround,
              //         children: [
              //           Container(
              //             height: size.height * 0.04,
              //             width: size.width * 0.25,
              //             padding: EdgeInsets.all(8),
              //             decoration: BoxDecoration(
              //               color: langSelectorColor,
              //               borderRadius: BorderRadius.circular(32),
              //             ),
              //             child: LanguageSelector(
              //               selectedLanguage: _sourceLanguage,
              //               onLanguageChanged: (newLang) {
              //                 setState(() {
              //                   _sourceLanguage =
              //                       newLang; // Update source language
              //                 });
              //               },
              //               fontSize: 10,
              //             ),
              //           ),
              //           Icon(
              //             Icons.arrow_forward_rounded,
              //             size: 20,
              //           ),
              //           Container(
              //             height: size.height * 0.04,
              //             width: size.width * 0.25,
              //             padding: EdgeInsets.all(8),
              //             decoration: BoxDecoration(
              //               color: langSelectorColor,
              //               borderRadius: BorderRadius.circular(32),
              //             ),
              //             child: LanguageSelector(
              //               selectedLanguage: _targetLanguage,
              //               onLanguageChanged: (newLang) {
              //                 setState(() {
              //                   _targetLanguage =
              //                       newLang; // Update target language
              //                 });
              //               },
              //               fontSize: 10,
              //             ),
              //           ),
              //         ],
              //       ), // Optional: Add text or widget inside
              //     ),
              //     SizedBox(height: 10), // Space between container and button
              //     Padding(
              //       padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
              //       child: Row(
              //         children: [
              //           ElevatedButton(
              //             onPressed: _detectAndTranslateText,
              //             child: Text('translate'),
              //           ),
              //           IconButton(
              //             onPressed: () {
              //               Navigator.pop(context);
              //             },
              //             icon: Icon(
              //               Icons.cancel_outlined,
              //               size: 50,
              //               color: borderColor,
              //             ),
              //           ),
              //         ],
              //       ),
              //     ),
              //   ],
              // ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildTextOverlay() {
    return Positioned(
      top: 100,
      left: 20,
      right: 20,
      child: Column(
        children: [
          Text(
            "$_detectedText",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.white),
          ),
          const SizedBox(height: 10),
          Text(
            "$_translatedText",
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 16, color: Colors.yellow),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomControls(Size size) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        _buildLanguageSelector(size),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 8, 0, 32),
          child: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(
              Icons.cancel_outlined,
              size: 50,
              color: borderColor,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLanguageSelector(Size size) {
    return Container(
      height: 50,
      width: 250,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildLanguageDropdown(
            size,
            _sourceLanguage,
            (newLang) => setState(() {
              _sourceLanguage = newLang;
            }),
          ),
          const Icon(Icons.arrow_forward_rounded, size: 20),
          _buildLanguageDropdown(
            size,
            _targetLanguage,
            (newLang) => setState(() {
              _targetLanguage = newLang;
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageDropdown(
      Size size, String selectedLang, Function(String) onChanged) {
    return Container(
      height: size.height * 0.04,
      width: size.width * 0.25,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: langSelectorColor,
        borderRadius: BorderRadius.circular(32),
      ),
      child: LanguageSelector(
        selectedLanguage: selectedLang,
        onLanguageChanged: onChanged,
        fontSize: 10,
      ),
    );
  }
}
