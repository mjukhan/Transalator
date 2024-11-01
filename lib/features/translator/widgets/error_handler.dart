import 'package:flutter/material.dart';

class ErrorHandler {
  static void handleTranslationError(BuildContext context, Object error) {
    final String errorMessage;

    if (error is NetworkException) {
      errorMessage = "Network Error: Please check your internet connection.";
    } else if (error is LanguageNotSupportedException) {
      errorMessage = "The selected language is not supported.";
    } else {
      errorMessage = "An unexpected error occurred.";
    }

    // Display a SnackBar with the error message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorMessage)),
    );
  }
}

class NetworkException implements Exception {
  final String message;
  NetworkException(this.message);
}

class LanguageNotSupportedException implements Exception {
  final String message;
  LanguageNotSupportedException(this.message);
}
