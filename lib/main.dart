import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';

import 'features/File/screens/upload_screen.dart';
import 'features/conversation/screens/test.dart';
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
      home: const HomeScreen(),
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
    //FilePickerDemo(),
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
      backgroundColor: const Color(0xFFF8F9FA),
      unselectedItemColor: unSelectedTebColor,
      selectedItemColor: selectedTebColor,
      type: BottomNavigationBarType.fixed,
      currentIndex: _selectedIndex,
      onTap: _onItemTapped,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.translate),
          label: 'Translator',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat),
          label: 'Conversation',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.file_upload),
          label: 'File',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Dictionary',
        ),
      ],
    );
  }
}
