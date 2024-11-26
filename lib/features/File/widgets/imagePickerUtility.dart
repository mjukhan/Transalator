import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ImagePickerUtility {
  static Future<File?> pickImageFromCamera(BuildContext context) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.camera,
        preferredCameraDevice: CameraDevice.rear,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {
      _showError(
        context,
        AppLocalizations.of(context)!.errorInPickImageFromCamera,
      );
    }
    return null;
  }

  static Future<File?> pickImageFromGallery(BuildContext context) async {
    try {
      XFile? pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 1000,
        maxWidth: 1000,
      );
      if (pickedFile != null) {
        return File(pickedFile.path);
      }
    } catch (e) {

      _showError(context, AppLocalizations.of(context)!.errorInPickImageFromGallery);
    }
    return null;
  }

  static void _showError(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message, style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.red,
      ),
    );
  }
}
