/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 24, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/signup_screen.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import 'package:clickclinician/widgets/web_viiew.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/utils.dart';

import '../data/shared_preferences.dart';
import '../shared/api_calls.dart';
import '../shared/firebase.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static const String routeName = "/loginScreen";

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<LoginScreen> {
  final SPSettings _settings = SPSettings();
  final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLoading = false;
  bool hidePassword = true;
  int userType = 2;
  final FocusNode passwordFocusNode = FocusNode();
  Color passwordFillColor = ColorsUI.backgroundColor;
  Color passwordIconColor = ColorsUI.lightHeading;
  final FocusNode emailFocusNode = FocusNode();
  Color emailFillColor = ColorsUI.backgroundColor;
  String testUserId = 'shubham@clinician.com';
  String testUserPass = 'apprely1';
  bool _emailEntered = true;
  bool _passEntered = true;

  void _onPasswordFocusChange() {
    setState(() {
      passwordFillColor =
          passwordFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
      passwordIconColor = passwordFocusNode.hasFocus
          ? ColorsUI.primaryColor
          : ColorsUI.lightHeading;
    });
  }

  void _onEmailFocusChange() {
    setState(() {
      emailFillColor =
          emailFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  @override
  Widget build(BuildContext context) {
    ApiCalls.init();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 80.0),
              child: Center(
                child: SizedBox(
                    width: 160,
                    height: 120,
                    child: Image.asset('assets/images/click_logo.png')),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("Welcome back!", style: CustomStyles.headingText),
                    ],
                  ),
                  DesignWidgets.addVerticalSpace(24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: Container(
                      height: 48,
                      width: displayWidth(context) - 96,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: ColorsUI.primaryColor,
                          style: BorderStyle.solid,
                          width: 1,
                        ),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.all(2),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              if (userType == 1) {
                                setState(
                                  () {
                                    userType = 2;
                                  },
                                );
                              }
                            },
                            child: Container(
                              width: (displayWidth(context) - 108) * 0.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: userType == 2
                                    ? ColorsUI.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Clinician",
                                      style: userType == 2
                                          ? CustomStyles.paragraphWhite
                                          : CustomStyles.paragraphPrimary),
                                ],
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              if (userType == 2) {
                                setState(() {
                                  userType = 1;
                                });
                              }
                            },
                            child: Container(
                              width: (displayWidth(context) - 108) * 0.5,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: userType == 1
                                    ? ColorsUI.primaryColor
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                "Agency",
                                style: userType == 1
                                    ? CustomStyles.paragraphWhite
                                    : CustomStyles.paragraphPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  DesignWidgets.addVerticalSpace(24),
                  Text(
                    "Email Address",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        controller: _emailController,
                        focusNode: emailFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter email",
                          filled: true,
                          fillColor: emailFillColor,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 100, 8),
                          hintStyle: CustomStyles.paragraphSubText,
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: ColorsUI.primaryColor, width: 2.0),
                          ),
                        ),
                      ),
                    ],
                  ),
                  DesignWidgets.addVerticalSpace(24),
                  Text(
                    "Password",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        enableSuggestions: false,
                        obscureText: hidePassword,
                        controller: _passwordController,
                        focusNode: passwordFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter password",
                          filled: true,
                          fillColor: passwordFillColor,
                          contentPadding:
                              const EdgeInsets.fromLTRB(16, 0, 100, 8),
                          hintStyle: CustomStyles.paragraphSubText,
                          alignLabelWithHint: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: const BorderSide(
                                color: ColorsUI.primaryColor, width: 2.0),
                          ),
                        ),
                      ),
                      Positioned(
                        right: 16,
                        top: 4,
                        bottom: 4,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              hidePassword = !hidePassword;
                            });
                          },
                          child: Icon(
                            hidePassword
                                ? Icons.lock_outline_rounded
                                : Icons.lock_open_rounded,
                            color: passwordIconColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  DesignWidgets.addVerticalSpace(24),
                  DesignWidgets.getButton(
                      isLoading: _isLoading,
                      text: "Login",
                      onTap: () {
                        String email = _emailController.text;
                        String password = _passwordController.text;

                        setState(() {
                          _emailEntered = email.isNotEmpty &&
                              RegExp(r'\S+@\S+\.\S+').hasMatch(email);
                          _passEntered = password.isNotEmpty;
                        });
                        try {
                          if (!_emailEntered || !_passEntered) {
                            return;
                          }
                          ApiCalls.login(email, password, context, (loading) {
                            setState(() {
                              _isLoading = loading;
                            });
                          }).then((String result) {
                            _settings.setPassword(_passwordController.text);
                          });
                        } catch (e) {
                          debugPrint('error while logging in: $e');
                        }
                        ;
                      }),
                  DesignWidgets.addVerticalSpace(16),
                  Center(
                    child: GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignupScreen()));
                      },
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  WebViewScreen(url: 'https://secure.clickclinician.com/onboarding'),
                            ),
                          );
                        },
                        child: const Text(
                          "Create an account",
                          style: TextStyle(
                              color: ColorsUI.primaryColor, fontSize: 16),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  /////////////////////////
  // Overrides
  @override
  void initState() {
    super.initState();
    _isLoading = false;
    passwordFocusNode.addListener(_onPasswordFocusChange);
    emailFocusNode.addListener(_onEmailFocusChange);

    _emailController.text = _settings.getUserName() ?? '';
    _passwordController.text = _settings.getPassword() ?? '';

    var token = _settings.getDeviceToken();
    var registeredDevice = _settings.getRegisteredDevice();
    _getCurrentPosition(context).then((_) => {
          // if (token == null || token == '')
          //   {
          //     FirebaseMessenger.requestNotificationPermission(),
          //     FirebaseMessenger.registerDeviceForNotifications().then((value) {
          //       if (token != null && token != '' && registeredDevice == false) {
          //         _settings.setDeviceToken(value!);
          //         ApiCalls.deviceToken = value;
          //       }
          //     })
          //   }
        });

    if (token == null || token == '') {
      FirebaseMessenger.requestNotificationPermission();
      FirebaseMessenger.registerDeviceForNotifications().then((value) {
        if (token != null && token != '' && registeredDevice == false) {
          _settings.setDeviceToken(value!);
          ApiCalls.deviceToken = value;
        }
      });
    }
  }

  Future<bool> _handlePermission() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await _geolocatorPlatform.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await _geolocatorPlatform.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await _geolocatorPlatform.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  Future<Position> _getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handlePermission();

    if (!hasPermission) {
      debugPrint('permission denied');
      showSnackBar(context, 'Location permission denied', SnackbarColors.error);
    }

    return await _geolocatorPlatform.getCurrentPosition(
        locationSettings:
            const LocationSettings(accuracy: LocationAccuracy.medium));
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
  /////////////////////////
}
