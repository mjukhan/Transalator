// import 'package:flutter/material.dart';
// import 'package:translation_app/features/File/screens/upload_screen.dart';
// import '../../features/conversation/screens/conversation_screen.dart';
// import '../../features/dictionary/screens/dictionary_screen.dart';
// import '../../features/translator/screens/translation_screen.dart';
//
// class AppRoutes {
//   static const String translator = '/translator';
//   static const String conversation = '/conversation';
//   static const String camera = '/camera';
//   static const String dictionary = '/dictionary';
//
//   static Route<dynamic> generateRoute(RouteSettings settings) {
//     switch (settings.name) {
//       case translator:
//         return MaterialPageRoute(
//             builder: (_) => TranslatorScreen(
//                   setLocale: (Locale) {},
//                 ));
//       case conversation:
//         return MaterialPageRoute(builder: (_) => ConversationScreen());
//       case camera:
//         return MaterialPageRoute(builder: (_) => FileScreen());
//       case dictionary:
//         return MaterialPageRoute(builder: (_) => DictionaryScreen());
//       default:
//         return MaterialPageRoute(
//             builder: (_) => TranslatorScreen(
//                   setLocale: (Locale) {},
//                 ));
//     }
//   }
// }
