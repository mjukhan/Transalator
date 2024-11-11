import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'features/File/screens/upload_screen.dart';
import 'features/splash/splash_screen.dart';
import 'features/translator/screens/translation_screen.dart';
import 'features/conversation/screens/conversation_screen.dart';

import 'features/dictionary/screens/dictionary_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TranslatorApp());
}

class TranslatorApp extends StatelessWidget {
  const TranslatorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const SplashScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    TranslatorScreen(),
    ConversationScreen(),
    FileScreen(),
    DictionaryScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: _buildBottomNavigationBar(),
    );
  }

  Widget _buildBottomNavigationBar() {
    return BottomNavigationBar(
      backgroundColor: bgColor,
      unselectedItemColor: unSelectedTebColor,
      selectedItemColor: selectedTebColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      elevation: 0,
      onTap: _onItemTapped,
      items: [
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/translate.png',
            scale: 24,
          ),
          label: 'Translator',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/chat (3).png',
            scale: 24,
          ),
          label: 'Conversation',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/upload.png',
            scale: 24,
          ),
          label: 'Upload',
        ),
        BottomNavigationBarItem(
          icon: Image.asset(
            'assets/icons/dictionary (1).png',
            scale: 24,
          ),
          label: 'Dictionary',
        ),
      ],
    );
  }
}
