import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PrivacyPolicy extends StatefulWidget {
  const PrivacyPolicy({super.key});

  @override
  State<PrivacyPolicy> createState() => _PrivacyPolicyState();
}

class _PrivacyPolicyState extends State<PrivacyPolicy> {
  final List<String> texts = [
    'Google Play Services',
    'AdMob',
    'Firebase Analytics',
    'Firebase Crashlytics',
    'Facebook'
  ];

  final List<String> urls = [
    'https://policies.google.com/privacy',
    'https://support.google.com/admob/answer/6128543?hl=en',
    'https://firebase.google.com/policies/analytics',
    'https://firebase.google.com/support/privacy/',
    'https://www.facebook.com/about/privacy/update/printable'
  ];

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  // Function to handle email link tap
  Future<void> _launchEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'apps@imaginationai.net',
      query: 'subject=Privacy Policy Inquiry', // Optional: Add default subject
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        scrolledUnderElevation: 0,
        title: Text(AppLocalizations.of(context)!.privacyPolicyTitle),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
        margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.privacyPolicyIntro,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.informationCollectionAndUse,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!
                      .informationCollectionAndUseDetails,
                ),
              ),
              Padding(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(texts.length, (index) {
                    return GestureDetector(
                      onTap: () => _launchURL(urls[index]),
                      child: Text(
                        texts[index],
                        style: TextStyle(
                          color: Colors.blue,
                        ),
                      ),
                    );
                  }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.logData,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.logDataDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.cookies,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.cookiesDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.serviceProviders,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.serviceProvidersDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.security,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(AppLocalizations.of(context)!.securityDetails),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.linksToOtherSites,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.linksToOtherSitesDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.childrenPrivacy,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.childrenPrivacyDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.changesToPrivacyPolicy,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Text(
                  AppLocalizations.of(context)!.changesToPrivacyPolicyDetails,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Text(
                  AppLocalizations.of(context)!.contactUs,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: Center(
                  child: Text.rich(
                    TextSpan(
                      text: AppLocalizations.of(context)!.contactUsDetails,
                      style: TextStyle(color: Colors.black),
                      children: [
                        TextSpan(
                          text:
                              'apps@imaginationai.net\n', // Bold and clickable email
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue, // Link color
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _launchEmail,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
