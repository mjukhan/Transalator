import 'package:flutter/material.dart';
import 'core/utilities/colors.dart';
import 'features/File/screens/upload_screen.dart';
import 'features/conversation/screens/conversation_screen.dart';
import 'features/dictionary/screens/dictionary_screen.dart';
import 'features/translator/screens/translation_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
          icon:
              (_selectedIndex == 0)
                  ? Image.asset('assets/icons/home-fill.png', scale: 24)
                  : Image.asset('assets/icons/home.png', scale: 24),
          label: AppLocalizations.of(context)!.translation,
        ),
        BottomNavigationBarItem(
          icon:
              (_selectedIndex == 1)
                  ? Image.asset('assets/icons/chat-fill.png', scale: 24)
                  : Image.asset('assets/icons/chat.png', scale: 24),
          label: AppLocalizations.of(context)!.conversation,
        ),
        BottomNavigationBarItem(
          icon:
              (_selectedIndex == 2)
                  ? Image.asset('assets/icons/file-fill.png', scale: 24)
                  : Image.asset('assets/icons/file.png', scale: 24),
          label: AppLocalizations.of(context)!.upload,
        ),
        BottomNavigationBarItem(
          icon:
              (_selectedIndex == 3)
                  ? Image.asset('assets/icons/dictionary-fill.png', scale: 24)
                  : Image.asset('assets/icons/dictionary.png', scale: 24),
          label: AppLocalizations.of(context)!.dictionary,
        ),
      ],
    );
  }
}
