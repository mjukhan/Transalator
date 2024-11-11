import 'package:flutter/material.dart';

import '../../core/utilities/colors.dart';
import '../../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to HomeScreen after a 3-second delay
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    });
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
            Image.asset(
              'assets/files/loading/loading.gif',
              width: 50, // Adjust width as needed
              height: 50, // Adjust height as needed
            ),
          ],
        ),
      ),
    );
  }
}
