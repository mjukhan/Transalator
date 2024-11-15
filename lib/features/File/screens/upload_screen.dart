import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/screens/picture.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({
    super.key,
  });

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  File? imageFile; // Store the picked image file
  File? _selectedFile; // Store the picked PDF file

  void _getFromCamera() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });

        // Navigate to PictureScreen if an image is captured
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PictureScreen(
              imageFile: imageFile!,
            ),
          ),
        ).then((value) {
          setState(() {
            imageFile = null; // Clear the image if needed
          });
        });
      }
    } catch (e) {
      _logException(
          "${AppLocalizations.of(context)!.errorInPickImageFromCamera} ${e.toString()}");
    }
  }

  void _getFromUpload() {
    _pickImage();
    //_showFileTypeDialog();
  }

  void _pickImage() async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        setState(() {
          imageFile = File(pickedFile.path);
        });

        // Navigate to PictureScreen if an image is captured
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PictureScreen(
              imageFile: imageFile!,
            ),
          ),
        ).then((value) {
          setState(() {
            imageFile = null; // Clear the image if needed
          });
        });
      }
    } catch (e) {
      _logException(
          "${AppLocalizations.of(context)!.errorInPickImageFromGallery} ${e.toString()}");
    }
  }

  void _logException(String message) {
    print(message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
          ),
        ),
        backgroundColor: borderColor,
      ),
    );
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _getFromUpload,
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
                SizedBox(
                  height: 10,
                ),
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
