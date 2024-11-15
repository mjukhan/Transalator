import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import '../../../core/widgets/widgets.dart';

class Upload {
  bool _isUploading = false;
  final File? imageFile;
  String? _savedFilePath;

  Upload({required this.imageFile});

  bool get isUploading => _isUploading;
  String? get savedFilePath => _savedFilePath;

  Future<File?> startUpload(BuildContext context) async {
    _isUploading = true;

    try {
      // Obtain the app's document directory
      final directory = await getApplicationDocumentsDirectory();

      // Generate the new file path in the app's storage
      final fileName = imageFile!.path.split('/').last; // Get the file name
      final newFilePath =
          '${directory.path}/$fileName'; // Path within app storage

      // Copy the file to the app's storage directory
      File savedFile = await imageFile!.copy(newFilePath);


      // Update the saved file path and reset upload status
      _savedFilePath = savedFile.path;
      _isUploading = false;

      // Show success dialog
      ReFunctions().showSuccessDialog(context, fileName);
      // Print file path in console
      print(_savedFilePath);
      return savedFile;
    } catch (e) {
      _isUploading = false;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error uploading file: $e")),
      );
      return null;
    }
  }
}
