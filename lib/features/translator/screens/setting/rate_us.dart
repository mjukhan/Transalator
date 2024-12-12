import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter_email_sender/flutter_email_sender.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/utilities/colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class RateUs extends StatefulWidget {
  const RateUs({super.key});

  @override
  _RateUsState createState() => _RateUsState();
}

class _RateUsState extends State<RateUs> {
  late double _rating;
  final int _ratingBarMode = 1;
  final double _initialRating = 1.0;
  IconData? _selectedIcon;

  @override
  void initState() {
    super.initState();
    _rating = _initialRating;
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      height: size.height * 0.5,
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Align(
            alignment: Alignment.topRight,
            child: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: Icon(Icons.cancel_outlined),
            ),
          ),
          _ratingStar(),
          SizedBox(
            height: 20.0,
          ),
          _heading(),
          SizedBox(height: 20.0),
          _ratingBar(_ratingBarMode),
          SizedBox(height: 20.0),
          Container(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
            margin: EdgeInsets.fromLTRB(16, 8, 16, 8),
            height: size.height * 0.1,
            width: size.width,
            child: ElevatedButton(
              onPressed: () {
                if (_rating <= 3.0) {
                  _emailRating();
                } else if (_rating > 3.0 && _rating <= 5.0) {
                  _googleRating(context);
                }
              },
              child: _buttonTitle(),
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(micColor),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _ratingStar() {
    switch (_rating) {
      case 1.0:
        return Image.asset(
          'assets/icons/star_20.png',
          scale: 8,
        );
      case 1.5:
        return Image.asset(
          'assets/icons/star_20.png',
          scale: 8,
        );
      case 2.0:
        return Image.asset(
          'assets/icons/star_40.png',
          scale: 8,
        );
      case 2.5:
        return Image.asset(
          'assets/icons/star_40.png',
          scale: 8,
        );
      case 3.0:
        return Image.asset(
          'assets/icons/star_60.png',
          scale: 8,
        );
      case 3.5:
        return Image.asset(
          'assets/icons/star_60.png',
          scale: 8,
        );
      case 4.0:
        return Image.asset(
          'assets/icons/star_80.png',
          scale: 8,
        );
      case 4.5:
        return Image.asset(
          'assets/icons/star_80.png',
          scale: 8,
        );
      case 5.0:
        return Image.asset(
          'assets/icons/star_100.png',
          scale: 8,
        );
      default:
        return Image.asset(
          'assets/icons/star.png',
          scale: 8,
        );
    }
  }

  Widget _ratingBar(int mode) {
    return RatingBar.builder(
      initialRating: _initialRating,
      minRating: 1,
      glowColor: micColor,
      glowRadius: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      unratedColor: micColor.withOpacity(0.2),
      itemCount: 5,
      itemSize: 50.0,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        _selectedIcon ?? Icons.star,
        color: micColor,
      ),
      onRatingUpdate: (rating) {
        setState(() {
          _rating = rating;
        });
      },
      updateOnDrag: true,
    );
  }

  Widget _image(String asset) {
    return Image.asset(
      asset,
      height: 30.0,
      width: 30.0,
    );
  }

  Widget _headings(String text1, String text2) => Column(
        children: [
          AutoSizeText(
            maxLines: 3,
            text1,
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 24.0,
            ),
          ),
          AutoSizeText(
            text2,
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 12.0,
            ),
          ),
        ],
      );

  Widget _heading() {
    switch (_rating) {
      case 1.0:
        return _headings('Oh, What a pity...',
            'Please let us know if you have any feedback or suggestion.');
      case 1.5 || 2.0 || 2.5 || 3.0:
        return _headings('Oh, no!', "We'd love to hear your feedback.");
      case 3.5 || 4.0:
        return _headings('Thank you!',
            "We will do our best to bring a better user experience.");
      case 4.5 || 5.0:
        return _headings('Wow, thank you so much!',
            "You satisfaction makes all of our efforts worthwhile.");
      default:
        return Container();
    }
  }

  _buttonTitle() {
    switch (_rating) {
      case 1.0 || 1.5 || 2.0 || 2.5 || 3.0:
        return Text(
          'Feedback',
          style: TextStyle(
            fontSize: 24,
            color: bgColor,
          ),
        );
      case 3.5 || 4.0 || 4.5 || 5.0:
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
                height: 40,
                width: 40,
                child: _image('assets/icons/google_play.png')),
            SizedBox(
              width: 10,
            ),
            Text(
              'Rate on Google Play',
              style: TextStyle(
                fontSize: 24,
                color: bgColor,
              ),
            ),
          ],
        );
    }
  }

  void _emailRating() {
    print("email");
    final Email email = Email(
      body: 'Thank you for using our service. Please provide your rating!',
      subject: 'Your Rating Request',
      recipients: ['smartapps1967@gmail.com'],
      isHTML: false,
    );

    try {
      FlutterEmailSender.send(email);
      print('Email sent successfully.');
    } catch (error) {
      print('Failed to send email: \$error');
    }
  }

  Future<void> _googleRating(BuildContext context) async {
    print("google");
    final String appLink =
        'https://play.google.com/store/apps/details?id=com.example.yourapp';
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
}
