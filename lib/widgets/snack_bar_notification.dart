import 'package:flutter/material.dart';

class SnackbarColors {
  static const Color error = Colors.redAccent;
  static const Color success = Colors.green;
  // static const Color success = Color.fromARGB(255, 2, 190, 99);
  static const Color info = Colors.grey;
  static const Color test = Colors.yellowAccent;
}

void showSnackBar(BuildContext context, String text, Color backgroundColor) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      showCloseIcon: true,
      dismissDirection: DismissDirection.down,
      content: Text(text),
      backgroundColor: backgroundColor,
      duration: const Duration(seconds: 10),
    ),
  );
}
