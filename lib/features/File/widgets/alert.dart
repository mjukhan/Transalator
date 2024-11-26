import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

showAlert({
  required BuildContext bContext,
  required String title,
  required String content,
}) {
  return showDialog(
    context: bContext,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text(title ?? "", style: TextStyle(color: Colors.white)),
        content: Text(content ?? ""),
        actions: [
          TextButton(
            onPressed: () => {Navigator.pop(context)},
            child: Text(AppLocalizations.of(context)!.ok),
          ),
        ],
      );
    },
  );
}
