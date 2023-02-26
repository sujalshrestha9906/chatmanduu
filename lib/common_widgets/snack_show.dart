import 'package:flutter/material.dart';

class SnackShow {
  static showSuccess(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.green.withOpacity(0.5),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        )));
  }

  static showFailure(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        duration: Duration(seconds: 1),
        backgroundColor: Colors.pink.withOpacity(0.5),
        content: Text(
          message,
          style: TextStyle(color: Colors.white),
        )));
  }
}
