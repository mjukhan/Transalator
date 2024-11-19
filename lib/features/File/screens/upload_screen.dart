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

  void _getFromCamera() async {
    File? file = await ImagePickerUtility.pickImageFromCamera(context);
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _getFromGallery,
                  child: SizedBox(
                    height: size.height * 0.15,
                    width: size.width * 0.5,
                    child: Card(
                      color: langSelectorColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/upload.png',
                            scale: 10,
                          ),
                          Text(AppLocalizations.of(context)!.uploadImage),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: _getFromCamera,
                  child: SizedBox(
                    height: size.height * 0.15,
                    width: size.width * 0.5,
                    child: Card(
                      color: langSelectorColor,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/icons/camera.png',
                            scale: 10,
                          ),
                          Text(AppLocalizations.of(context)!.takePicture),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
