import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'core/navigation/app_routes.dart';
import 'features/translator/screens/translation_screen.dart';
import 'features/conversation/screens/conversation_screen.dart';
import 'features/camera/screens/camera_screen.dart';
import 'features/dictionary/screens/dictionary_screen.dart';

void main() {
  runApp(TranslatorApp());
}

class TranslatorApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Translator App',
      home: HomeScreen(), // Set HomeScreen as the main screen
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0; // Current index for Bottom Navigation Bar

  // List of widget pages that corresponds to the selected index
  final List<Widget> _pages = [
    TranslatorScreen(),
    ConversationScreen(),
    CameraScreen(),
    DictionaryScreen(),
  ];

  // Method to handle bottom navigation bar taps
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index; // Update the selected index
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex], // Show the currently selected page
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        unselectedItemColor: unSelectedTebColor,
        selectedItemColor: selectedTebColor,
        type: BottomNavigationBarType.fixed, // Keeps items from shifting
        currentIndex: _selectedIndex, // Highlight the current index
        onTap: _onItemTapped, // Update the current index on tap
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.translate),
            label: 'Translator',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat),
            label: 'Conversation',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_alt),
            label: 'Camera',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Dictionary',
          ),
        ],
      ),
    );
  }
}
