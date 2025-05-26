import 'package:flutter/material.dart';

extension ScaffoldMessengerStateExtension on ScaffoldMessengerState {
  void showErrorSnackBar({required String message}) {
    final colorScheme = Theme.of(context).colorScheme;
    showSnackBar(
      SnackBar(
        content: Text(message, style: TextStyle(color: colorScheme.onError)),
        backgroundColor: colorScheme.error,
      ),
    );
  }
}
