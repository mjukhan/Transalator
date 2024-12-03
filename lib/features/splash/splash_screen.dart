import 'package:flutter/material.dart';
import '../../core/utilities/colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  void _navigateToHome() async {
    // Simulate a loading delay
    await Future.delayed(const Duration(seconds: 3));
    Navigator.pushReplacementNamed(context, '/home'); // Navigate to home
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
                child: Image.asset('assets/icons/splash.png'),
              ),
              SizedBox(height: size.height * 0.05),
              Text(
                'Language Translator',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Communicate with the World',
                style: TextStyle(fontSize: 13, color: Colors.grey.shade500),
              ),
              const Spacer(),
              Column(
                children: [
                  const Text('Loading...'),
                  const SizedBox(height: 16),
                  AnimatedLoader(), // Replace progress bar with AnimatedLoader
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AnimatedLoader extends StatefulWidget {
  const AnimatedLoader({super.key});

  @override
  _AnimatedLoaderState createState() => _AnimatedLoaderState();
}

class _AnimatedLoaderState extends State<AnimatedLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..repeat(reverse: false);

    // Define the animation
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130, // Fixed width of the loader
      height: 4, // Height of the loader
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.2),
        borderRadius: BorderRadius.circular(30),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Align(
            alignment: Alignment.centerLeft,
            child: FractionallySizedBox(
              widthFactor: _animation.value,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF0071E2),
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
