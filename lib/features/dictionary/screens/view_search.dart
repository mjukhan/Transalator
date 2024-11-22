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
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: Text('Search Results'),
        backgroundColor: bgColor,
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: FutureBuilder<WordDefinition?>(
        future: widget.wordDefinition,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text(AppLocalizations.of(context)!.errorFetchingMeaning),
            );
          } else if (snapshot.hasData && snapshot.data != null) {
            final wordDefinition = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: wordDefinition.meanings.length,
              itemBuilder: (context, nounIndex) {
                final meaning = wordDefinition.meanings[nounIndex];
                return Container(
                  margin: const EdgeInsets.only(bottom: 16.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: borderColor,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Part of Speech and Word
                        Row(
                          children: [
                            Text(
                              meaning.partOfSpeech,
                              style: TextStyle(
                                color: wordPOSColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              ": ${wordDefinition.word}",
                              style: TextStyle(
                                color: wordPOSColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const Divider(),
                        // Definitions List
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: meaning.definitions.length,
                          itemBuilder: (context, defIndex) {
                            return Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 4.0),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('${(defIndex + 1).toString()}. '),
                                  Expanded(
                                    child: Text(
                                      meaning.definitions[defIndex].definition,
                                      style: const TextStyle(fontSize: 14),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          } else {
            return Center(
              child: Text(AppLocalizations.of(context)!.noDataFound),
            );
          }
        },
      ),
    );
  }
}
