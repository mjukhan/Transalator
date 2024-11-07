import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/File/screens/picture.dart';


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
      _logException("Error picking image from camera: ${e.toString()}");
    }
  }

  void _getFromUpload() {
    _pickImage();
    //_showFileTypeDialog();
  }

  // void _showFileTypeDialog() {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Select File Type'),
  //         content: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             ListTile(
  //               title: Text('Picture'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _pickImage();
  //               },
  //             ),
  //             ListTile(
  //               title: Text('PDF'),
  //               onTap: () {
  //                 Navigator.pop(context);
  //                 _pickPDF(); // Add this method to handle PDF selection
  //               },
  //             ),
  //           ],
  //         ),
  //       );
  //     },
  //   );
  // }

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
      _logException("Error picking image from gallery: ${e.toString()}");
    }
  }

  // Future<void> _pickPDF() async {
  //   try {
  //     FilePickerResult? result = await FilePicker.platform.pickFiles(
  //       allowMultiple: false,
  //     );
  //
  //     if (result != null && result.files.isNotEmpty) {
  //       setState(() {
  //         _selectedFile = File(result.files.single.path!);
  //       });
  //       _goToUploadPage();
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Error selecting file: $e")),
  //     );
  //   }
  // }

  // void _goToUploadPage() {
  //   if (_selectedFile != null) {
  //     Navigator.push(
  //       context,
  //       MaterialPageRoute(
  //         builder: (context) => FileUpload(file: _selectedFile!),
  //       ),
  //     );
  //   } else {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text("Please select a file first")),
  //     );
  //   }
  // }

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
        backgroundColor:
            Colors.red, // Optional: Set background color for the SnackBar
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
        title: Text('File'),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file_outlined,
                            size: 50,
                          ),
                          Text('Upload Image'),
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
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.camera_alt_outlined,
                            size: 50,
                          ),
                          Text('Take Picture'),
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
