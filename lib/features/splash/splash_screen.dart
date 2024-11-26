import 'package:flutter/material.dart';
import 'dart:async';
import '../../core/utilities/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  double _progress = 0.0;
  void _startProgress() {
    setState(() {
      _progress = 0.0; // Reset progress
    });

    Future.doWhile(() async {
      if (_progress >= 1.0) {
        // Navigate to the home page when progress completes
        Navigator.pushReplacementNamed(context, '/home');
        return false; // Stop updating progress
      }
      await Future.delayed(Duration(milliseconds: 500));
      setState(() {
        _progress += 0.05; // Increment progress
      });
      return true;
    });
  }

  @override
  void initState() {
    super.initState();
    _startProgress();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: bgColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/translate.png',
              width: 100, // Adjust size as needed
              height: 100,
            ),
            SizedBox(height: size.height * 0.3),
            // Image.asset(
            //   'assets/files/loading/loading.gif',
            //   width: 50, // Adjust width as needed
            //   height: 50, // Adjust height as needed
            // ),
            Text('Loading...'),
            Container(
              width: size.width * 0.8,
              height: 20,
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.yellow),
                borderRadius: BorderRadius.circular(8),
              ),
              child: LinearProgressIndicator(
                borderRadius: BorderRadius.circular(8),
                minHeight: 5,
                value: _progress, // Progress value (0.0 to 1.0)
                backgroundColor: bgColor,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
