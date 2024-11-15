import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.upgradeToPremium,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange,
                ),
              ),
            ),
            SizedBox(height: 8),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                AppLocalizations.of(context)!.removeAdsUnlockFeatures,
                style: TextStyle(fontSize: 12, color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildFeatureRow(
                    AppLocalizations.of(context)!.adsFreeExperience),
                _buildFeatureRow(
                    AppLocalizations.of(context)!.voiceConversation),
                _buildFeatureRow(
                    AppLocalizations.of(context)!.cameraTranslation),
              ],
            ),
            Spacer(),
            Column(
              children: [
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    AppLocalizations.of(context)!.threeDaysFreeTrial,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      padding:
                          EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppLocalizations.of(context)!.continueButton,
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: AutoSizeText(
                    AppLocalizations.of(context)!.cancelAnytime,
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      _launchURL(
                          'https://imaginationai.net/languagetranslator/terms-and-conditions');
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppLocalizations.of(context)!.termsPrivacy,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  width: 150,
                  child: TextButton(
                    onPressed: () {
                      showSubscriptionDetailDialog(context);
                    },
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        AppLocalizations.of(context)!.subscriptionDetails,
                        textAlign: TextAlign.center,
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                  ),
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
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              feature,
              style: TextStyle(fontSize: 16),
            ),
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
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  AppLocalizations.of(context)!.subscriptionDetails,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildSubscriptionPoints([
                      AppLocalizations.of(context)!.subscriptionDetail1,
                      AppLocalizations.of(context)!.subscriptionDetail2,
                      AppLocalizations.of(context)!.subscriptionDetail3,
                      AppLocalizations.of(context)!.subscriptionDetail4,
                      AppLocalizations.of(context)!.subscriptionDetail5,
                      AppLocalizations.of(context)!.subscriptionDetail6,
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
                        AppLocalizations.of(context)!.cancelButton,
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        AppLocalizations.of(context)!.continueButton,
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
