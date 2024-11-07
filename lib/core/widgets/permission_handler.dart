import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionHelper {
  static Future<bool> requestPermission({
    required Permission permission,
    required BuildContext context,
  }) async {
    var status = await permission.status;

    // Check if permission is already granted
    if (status.isGranted) {
      return true;
    }
    // Check if permission is denied
    else if (status.isDenied) {
      status = await permission.request();
      if (status.isGranted) {
        return true;
      } else {
        _showPermissionDeniedDialog(context, permission);
        return false;
      }
    }
    // Handle other cases like permanently denied
    else {
      _showPermissionDeniedDialog(context, permission);
      return false;
    }
  }

  // Permission request function specifically for Camera and Gallery access
  static Future<bool> requestCameraAndGalleryPermissions(
      BuildContext context) async {
    // Request both Camera and Photos permissions in sequence
    bool cameraGranted = await requestPermission(
        permission: Permission.camera, context: context);
    bool galleryGranted = await requestPermission(
        permission: Permission.photos, context: context);

    return cameraGranted && galleryGranted;
  }

  static void _showPermissionDeniedDialog(
      BuildContext context, Permission permission) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Permission Required'),
        content: Text(
          'This app needs ${permission.toString().split('.').last} permission to proceed. Please grant it in settings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              openAppSettings();
              Navigator.of(context).pop();
            },
            child: Text('Settings'),
          ),
        ],
      ),
    );
  }



}
