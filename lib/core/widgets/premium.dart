import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:translation_app/core/utilities/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class PremiumSubscriptionScreen extends StatelessWidget {
  const PremiumSubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 10),
            Image.asset(
              'assets/icons/premium.png',
              height: size.height * 0.15,
            ),
            SizedBox(height: 10),
            AutoSizeText(
              "Upgrade to Premium",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.orange,
              ),
            ),
            SizedBox(height: 8),
            AutoSizeText(
              "Remove ads and unlock all features",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Column(
              children: [
                _buildFeatureRow("Ads-free experience"),
                _buildFeatureRow("Offline Translation"),
                _buildFeatureRow("Phrase Book Access"),
                _buildFeatureRow("Voice Conversation"),
                _buildFeatureRow("Camera Translation"),
              ],
            ),
            Spacer(),
            Column(
              children: [
                AutoSizeText(
                  "3 days free trial, PKR - Rs 7,500.00/Yearly",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: AutoSizeText(
                    "Continue",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
                SizedBox(height: 10),
                AutoSizeText(
                  "Cancel Anytime",
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  onPressed: () {
                    _launchURL(
                        'https://imaginationai.net/languagetranslator/terms-and-conditions');
                  },
                  child: AutoSizeText("Terms & Privacy"),
                ),
                Text(" | "),
                TextButton(
                  onPressed: () {
                    showSubscriptionDetailDialog(context);
                  },
                  child: AutoSizeText("Subscription Details"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureRow(String feature) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text(
            feature,
            style: TextStyle(fontSize: 16),
          ),
        ],
      ),
    );
  }

  void showSubscriptionDetailDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: SizedBox(
                  height: 80,
                  width: 80,
                  child: Image.asset(
                    'assets/icons/info.png',
                  ),
                ),
              ),
              Text(
                'Subscription Details',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSubscriptionPoints([
                      'With a Language Translator VIP subscription, all ads will be removed.',
                      'Once the purchase is confirmed, the subscription will be charged through the Google Play Store.',
                      'After cancellation, the subscription will continue until the end of the current month or year billing period.',
                      'Subscriptions will automatically renew unless auto-renew is turned off at least 24 hours before the end of the current period.',
                      'You can manage your subscription or disable automatic renewal in the Google Play Store account settings.',
                      'Subscriptions canceled during the trial period will not be charged.',
                    ]),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Cancel",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        "Continue",
                        style: TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildSubscriptionPoints(List<String> points) {
    return points
        .map(
          (point) => Padding(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("• ", style: TextStyle(fontSize: 24)),
                Expanded(
                  child: Text(
                    point,
                    textAlign: TextAlign.start,
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
          ),
        )
        .toList();
  }

  Future<void> _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }
}
