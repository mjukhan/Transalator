import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

class ShareApp extends StatelessWidget {
  final String appLink =
      'https://play.google.com/store/apps/details?id=com.example.yourapp';

  const ShareApp({super.key});

  void _shareApp() {
    Share.share('Check out this amazing app: $appLink');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Share App'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: _shareApp,
          child: Text('Share App'),
        ),
      ),
    );
  }
}
