import 'dart:io';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/screens/picture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../widgets/imagePickerUtility.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({super.key});

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  File? imageFile;

  void _getFromGallery() async {
    File? file = await ImagePickerUtility.pickImageFromGallery(context);
    if (file != null) {
      setState(() {
        imageFile = file;
      });

      // Navigate to PictureScreen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PictureScreen(imageFile: imageFile!),
        ),
      ).then((value) {
        setState(() {
          imageFile = null; // Clear the image
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: Text(AppLocalizations.of(context)!.file),
        scrolledUnderElevation: 0,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: size.height * 0.4,
          width: size.width * 0.8,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: <Widget>[
              Flexible(
                flex: 2,
                child: Image.asset('assets/icons/upload-file.png', scale: 4),
              ),
              Flexible(
                child: Text(
                  'Select Document',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              Flexible(
                child: Text(
                  'Upload file .png, .jpg, .jpeg',
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ),
              SizedBox(height: 50),
              Flexible(
                flex: 1,
                child: GestureDetector(
                  onTap: _getFromGallery,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    height: 50,
                    width: 150,
                    child: Center(
                      child: Text(AppLocalizations.of(context)!.upload),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
