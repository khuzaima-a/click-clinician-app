import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

double displayHeight(BuildContext context) {
  return MediaQuery.of(context).size.height;
}

double displayWidth(BuildContext context) {
  return MediaQuery.of(context).size.width;
}

bool isValidEmail(String email) {
  RegExp emailRegex = RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
  return emailRegex.hasMatch(email);
}

Future<dynamic> checkInternetConnectivity() async {
  var result = await Connectivity().checkConnectivity();
  bool checkInternet = false;
  if (result == ConnectivityResult.none) {
    checkInternet = false;
  } else if (result == ConnectivityResult.mobile) {
    checkInternet = true;
  } else if (result == ConnectivityResult.wifi) {
    checkInternet = true;
  }
  return checkInternet;
}
