import 'package:flutter/material.dart';

class SnackbarUtils {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(String message, {Color backgroundColor = Colors.black}) {
    final messengerState = messengerKey.currentState;
    
    // Close any currently open snackbar
    messengerState?.removeCurrentSnackBar();

    // Show the new snackbar
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    );
    messengerState?.showSnackBar(snackbar);
  }
}
