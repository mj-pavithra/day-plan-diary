import 'package:flutter/material.dart';

class SnackbarUtils {
  static final GlobalKey<ScaffoldMessengerState> messengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void showSnackbar(String message, {Color backgroundColor = Colors.black}) {
    final snackbar = SnackBar(
      content: Text(message),
      backgroundColor: backgroundColor,
      behavior: SnackBarBehavior.floating,
    );
    messengerKey.currentState?.showSnackBar(snackbar);
    print(message);
  }
}
