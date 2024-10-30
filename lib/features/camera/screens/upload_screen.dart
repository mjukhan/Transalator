import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:translation_app/features/camera/screens/file_upload.dart';
import 'package:translation_app/features/camera/screens/picture.dart';

class FileScreen extends StatefulWidget {
  const FileScreen({
    super.key,
  });

  @override
  State<FileScreen> createState() => _FileScreenState();
}

class _FileScreenState extends State<FileScreen> {
  File? imageFile; // Store the picked image file
  File? pdfFile; // Store the picked PDF file

  void _getFromCamera() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
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
        // Refresh or handle any state if needed when returning
        setState(() {
          imageFile = null; // Clear the image if needed
        });
      });
    }
  }

  void _getFromUpload() {
    _showFileTypeDialog();
  }

  void _showFileTypeDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Select File Type'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text('Picture'),
                onTap: () {
                  Navigator.pop(context);
                  _pickImage();
                },
              ),
              ListTile(
                title: Text('PDF'),
                onTap: () {
                  Navigator.pop(context);
                  _pickPDF(); // Add this method to handle PDF selection
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _pickImage() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
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
  }

  void _pickPDF() async {
    // Use the file_picker package to select a PDF file
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null && result.files.isNotEmpty) {
      try {
        // Set the selected PDF file
        final pdfFilePath = result.files.single.path;
        if (pdfFilePath != null) {
          setState(() {
            pdfFile = File(pdfFilePath);
          });

          // Handle the PDF upload logic here
          await _uploadPDF(pdfFile);
        } else {
          throw Exception("PDF file path is null");
        }
      } catch (e) {
        // Handle any errors during file processing
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error processing the PDF file: ${e.toString()}"),
          ),
        );
      }
    } else {
      // Handle the case when no file is selected
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No PDF file selected")),
      );
    }
  }

  void _uploadPDF(File? file) async {
    if (file != null) {
      try {
        // Show a loading indicator or change UI state to indicate upload in progress
        setState(() {
          _isLoading = true; // Assuming you have a loading state variable
        });

        // Example: Upload the PDF file to a server or perform any action
        print("Uploading PDF file: ${file.path}");

        // TODO: Implement your actual upload logic here
        // For example, using http package to upload to a server:
        // var response = await http.post(
        //   Uri.parse("YOUR_UPLOAD_URL"),
        //   body: {
        //     'file': await http.MultipartFile.fromPath('file', file.path),
        //   },
        // );

        // Simulate upload delay (for demo purposes only)
        await Future.delayed(Duration(seconds: 2));

        // Handle the response as needed
        // if (response.statusCode == 200) {
        //   ScaffoldMessenger.of(context).showSnackBar(
        //     SnackBar(content: Text("PDF uploaded successfully!")),
        //   );
        // } else {
        //   throw Exception("Failed to upload PDF: ${response.reasonPhrase}");
        // }

        // Simulate successful upload for demo purposes
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("PDF uploaded successfully!")),
        );
      } catch (e) {
        // Handle any errors during the upload process
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("Error uploading PDF file: ${e.toString()}"),
          ),
        );
      } finally {
        // Reset loading state
        setState(() {
          _isLoading = false; // Reset loading state
        });
      }
    } else {
      // Handle the case when the file is null
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("No PDF file to upload")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('File'),
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: _getFromUpload,
                  child: SizedBox(
                    height: size.height * 0.2,
                    width: size.width * 0.5,
                    child: Card(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.upload_file_outlined,
                            size: 50,
                          ),
                          Text('Upload File'),
                        ],
                      ),
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: _getFromCamera,
                  child: SizedBox(
                    height: size.height * 0.2,
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
