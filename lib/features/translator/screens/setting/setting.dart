import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:translation_app/features/translator/screens/setting/language.dart';
import 'package:translation_app/features/translator/screens/setting/premium.dart';
import 'package:translation_app/features/translator/screens/setting/privacy_policy.dart';
import 'package:translation_app/features/translator/screens/setting/save_translation_instance.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Setting extends StatefulWidget {
  final List<String> savedTranslation;

  const Setting({
    super.key,
    required this.savedTranslation,
  });

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with SingleTickerProviderStateMixin {
  final String appLink =
      'https://play.google.com/store/apps/details?id=com.example.yourapp';
  final List<Map<String, String>> general = [];
  final List<Map<String, String>> other = [];

  void _initializeGeneralList(BuildContext context) {
    general.clear();
    other.clear();
    general.addAll(
      [
        {
          'icon': 'assets/icons/premium.png',
          'title': AppLocalizations.of(context)!.premium,
          'subtitle': AppLocalizations.of(context)!.upgradeToPro,
        },
        {
          'icon': 'assets/icons/language.png',
          'title': AppLocalizations.of(context)!.appLanguage,
          'subtitle': AppLocalizations.of(context)!.changeAppLanguage,
        },
        {
          'icon': 'assets/icons/manage.png',
          'title': AppLocalizations.of(context)!.manageSubscriptions,
          'subtitle': AppLocalizations.of(context)!.checkBilling,
        },
        {
          'icon': 'assets/icons/star.png',
          'title': AppLocalizations.of(context)!.favorite,
          'subtitle': AppLocalizations.of(context)!.viewAllFavorites,
        }
      ],
    );
    other.addAll([
      {
        'icon': 'assets/icons/share.png',
        'title': AppLocalizations.of(context)!.shareApp,
        'subtitle': AppLocalizations.of(context)!.shareWithFriends,
      },
      {
        'icon': 'assets/icons/rate.png',
        'title': AppLocalizations.of(context)!.rateUs,
        'subtitle': AppLocalizations.of(context)!.shareFeedback,
      },
      {
        'icon': 'assets/icons/privacy.png',
        'title': AppLocalizations.of(context)!.privacyPolicy,
        'subtitle': AppLocalizations.of(context)!.readPrivacyPolicy,
      },
    ]);
  }

  // Function to handle navigation to the next page
  void _navigateToPage(String title) {
    final localizations = AppLocalizations.of(context)!;

    // Print the saved translation for debugging
    print(widget.savedTranslation);

    // Use a switch statement based on localized strings
    if (title == localizations.appLanguage) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AppLanguage(),
        ),
      );
    } else if (title == localizations.premium) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PremiumSubscriptionScreen(),
        ),
      );
    } else if (title == localizations.privacyPolicy) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PrivacyPolicy(),
        ),
      );
    } else if (title == localizations.favorite) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SavedTranslationsPage(
            savedTranslations: widget.savedTranslation,
          ),
        ),
      );
    } else if (title == localizations.shareApp) {
      _shareApp();
    } else if (title == localizations.rateUs) {
      _rateApp(context);
    }
    // Add more cases for other list items if necessary
  }

  void _shareApp() {
    Share.share('${AppLocalizations.of(context)!.shareWithFriends} $appLink');
  }

  Future<void> _rateApp(BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(appLink))) {
      await launchUrl(Uri.parse(appLink), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context)!.couldNotOpenAppStore),
        ),
      );
    }
  }

  void showPosterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(0),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Poster image
              Image.asset(
                'assets/icons/premium.png',
                fit: BoxFit.cover,
              ),
              // Continue and Cancel buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  TextButton(
                    onPressed: () {
                      // Handle continue action
                      Navigator.of(context).pop();
                    },
                    child: Text("Continue"),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("Cancel"),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;
    _initializeGeneralList(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        title: Text(localizations.setting),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: 340,
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
                      localizations.general,
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
                      physics: NeverScrollableScrollPhysics(),
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
                          onTap: () {
                            _navigateToPage(general[index]['title']!);
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
            Container(
              height: 270,
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
                      localizations.other,
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
                      physics: NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        return ListTile(
                          leading: Image.asset(
                            other[index]['icon']!,
                            scale: 24,
                          ),
                          title: Text(
                            other[index]['title']!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            other[index]['subtitle']!,
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                            color: Colors.grey,
                          ),
                          onTap: () {
                            _navigateToPage(other[index]['title']!);
                          },
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
