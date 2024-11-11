import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  final List<Map<String, String>> general = [
    {
      'icon': 'assets/icons/premium.png',
      'title': 'Premium',
      'subtitle': 'Upgrade to Pro',
    },
    {
      'icon': 'assets/icons/language.png',
      'title': 'App Language',
      'subtitle': 'Change your app language',
    },
    {
      'icon': 'assets/icons/manage.png',
      'title': 'Manage Subscriptions',
      'subtitle': 'Check your purchase & billing',
    },
    {
      'icon': 'assets/icons/star.png',
      'title': 'Favorite',
      'subtitle': 'View all translations Favorites',
    },
    {
      'icon': 'assets/icons/history.png',
      'title': 'History',
      'subtitle': 'View all translation history',
    },
  ];
  final List<Map<String, String>> other = [
    {
      'icon': 'assets/icons/share.png',
      'title': 'Share App',
      'subtitle': 'Share with friends',
    },
    {
      'icon': 'assets/icons/rate.png',
      'title': 'Rate Us',
      'subtitle': 'Share your suggestion, feedback',
    },
    {
      'icon': 'assets/icons/privacy.png',
      'title': 'Privacy Policy',
      'subtitle': 'Read the apps privacy policy',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text('Setting'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 450,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                    child: Text(
                      'General',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: general.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.asset(
                            general[index]['icon']!,
                            scale: 24,
                          ),
                          title: Text(
                            general[index]['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            general[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 300,
              margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 0, 8),
                    child: Text(
                      'Other',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: other.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.asset(
                            general[index]['icon']!,
                            scale: 24,
                          ),
                          title: Text(
                            general[index]['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            general[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
