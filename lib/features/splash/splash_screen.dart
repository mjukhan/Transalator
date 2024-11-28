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
        child: SizedBox(
          height: size.height * 0.6,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 16, 32, 0),
                child: Image.asset(
                  'assets/icons/splash.png',
                  // width: 100,
                  // height: 100,
                ),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                'Language Translator',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              Text(
                'Communicate with the World',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              Spacer(),

              Column(
                children: [
                  Text('Loading...'),
                  Container(
                    width: size.width * 0.6,
                    height: 8,
                    padding: EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      //border: Border.all(color: Colors.yellow),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: LinearProgressIndicator(
                      borderRadius: BorderRadius.circular(16),

                      value: _progress, // Progress value (0.0 to 1.0)
                      backgroundColor: Colors.grey.shade200,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
