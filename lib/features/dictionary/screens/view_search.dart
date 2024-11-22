import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/utilities/colors.dart';
import '../../../data/models/Word_model.dart';

class ViewSearch extends StatefulWidget {
  final Future<WordDefinition?>? wordDefinition;
  const ViewSearch({super.key, required this.wordDefinition});

  @override
  State<ViewSearch> createState() => _ViewSearchState();
}

class _ViewSearchState extends State<ViewSearch> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Results'),
      ),
      body: FutureBuilder(
          future: widget.wordDefinition,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(
                  child:
                      Text(AppLocalizations.of(context)!.errorFetchingMeaning));
            } else if (snapshot.hasData && snapshot.data != null) {
              final wordDefinition = snapshot.data!;
              return Column(
                children: [
                  Text(wordDefinition.word),
                ],
              );
            } else {
              return Center(
                child: Text(AppLocalizations.of(context)!.noDataFound),
              );
            }
          }),
    );
  }
}
