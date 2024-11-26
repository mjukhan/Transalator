import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ViewFavoriteTranslation extends StatefulWidget {
  final String text1;
  final String text2;
  const ViewFavoriteTranslation({
    super.key,
    required this.text1,
    required this.text2,
  });

  @override
  State<ViewFavoriteTranslation> createState() =>
      _ViewFavoriteTranslationState();
}

class _ViewFavoriteTranslationState extends State<ViewFavoriteTranslation> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Column(children: [Text(widget.text1), Text(widget.text2)]),
        ),
      ),
    );
  }
}
