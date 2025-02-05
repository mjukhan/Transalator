import 'dart:async';

import 'package:flutter/material.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
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
  bool _wifi = true;
  String connectionStatus = "";
  StreamSubscription? _internetConnectionStream;

  @override
  void initState() {
    super.initState();
    checkWiFi();
  }

  @override
  void dispose() {
    _internetConnectionStream?.cancel();
    super.dispose();
  }

  void checkWiFi() {
    _internetConnectionStream =
        InternetConnectionChecker().onStatusChange.listen((status) {
      bool hasConnection = status == InternetConnectionStatus.connected;
      setState(() {
        _wifi = hasConnection;
        connectionStatus = hasConnection
            ? "Connected to Internet"
            : "No Internet. Please Check Your Internet";
      });
      if (!hasConnection) {
        snackMassage(connectionStatus);
      }
      debugPrint("_wifi : $_wifi");
      debugPrint("connection Status : $connectionStatus");
    });
  }

  void snackMassage(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        behavior: SnackBarBehavior.floating,
        backgroundColor: micColor,
        duration: Duration(seconds: 1),
      ),
    );
  }

  List<Widget> get _pages => [
        TranslatorScreen(wifi: _wifi, connectionStatus: connectionStatus),
        ConversationScreen(wifi: _wifi, connectionStatus: connectionStatus),
        FileScreen(wifi: _wifi, connectionStatus: connectionStatus),
        DictionaryScreen(wifi: _wifi, connectionStatus: connectionStatus),
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
          icon: (_selectedIndex == 0)
              ? Image.asset('assets/icons/home-fill.png', scale: 24)
              : Image.asset('assets/icons/home.png', scale: 24),
          label: AppLocalizations.of(context)?.translation ?? 'Translation',
        ),
        BottomNavigationBarItem(
          icon: (_selectedIndex == 1)
              ? Image.asset('assets/icons/chat-fill.png', scale: 24)
              : Image.asset('assets/icons/chat.png', scale: 24),
          label: AppLocalizations.of(context)?.conversation ?? 'Conversation',
        ),
        BottomNavigationBarItem(
          icon: (_selectedIndex == 2)
              ? Image.asset('assets/icons/file-fill.png', scale: 24)
              : Image.asset('assets/icons/file.png', scale: 24),
          label: AppLocalizations.of(context)?.upload ?? 'Upload',
        ),
        BottomNavigationBarItem(
          icon: (_selectedIndex == 3)
              ? Image.asset('assets/icons/dictionary-fill.png', scale: 24)
              : Image.asset('assets/icons/dictionary.png', scale: 24),
          label: AppLocalizations.of(context)?.dictionary ?? 'Dictionary',
        ),
      ],
    );
  }
}
