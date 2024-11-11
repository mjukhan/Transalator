import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class RateUs extends StatelessWidget {
  final String appLink =
      'https://play.google.com/store/apps/details?id=com.example.yourapp';

  const RateUs({super.key});

  Future<void> _rateApp(BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(appLink))) {
      await launchUrl(Uri.parse(appLink), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open the app store.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rate Us'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _rateApp(context),
          child: Text('Rate App'),
        ),
      ),
    );
  }
}
