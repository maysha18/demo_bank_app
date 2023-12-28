import 'package:flutter/material.dart';

final GlobalKey<ScaffoldMessengerState> snackbarKey =
    GlobalKey<ScaffoldMessengerState>();

class SnackBarUtils {
  static void showSnackBars({required String msg, int duration = 4000}) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      duration: Duration(milliseconds: duration),
      content: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 13,
          color: Colors.white,
        ),
      ),
    );
    snackbarKey.currentState!.showSnackBar(snackBar).closed.then((value) {
      snackbarKey.currentState!.clearSnackBars();
    });
  }

  static void showSnackBarInternet({
    required String msg,
    VoidCallback? onPressed,
  }) {
    var snackBar = SnackBar(
      behavior: SnackBarBehavior.floating,
      elevation: 3,
      duration: const Duration(days: 365),
      content: Text(
        msg,
        style: TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      action: SnackBarAction(
        label: 'Retry',
        textColor: Colors.red,
        onPressed: onPressed!,
      ),
    );

    snackbarKey.currentState!.showSnackBar(snackBar).closed.then((value) {
      snackbarKey.currentState!.clearSnackBars();
    });
  }
}
