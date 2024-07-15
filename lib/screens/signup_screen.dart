import 'package:clickclinician/screens/login_screen.dart';
import 'package:clickclinician/widgets/snack_bar_notification.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:clickclinician/utility/style_file.dart';

import '../shared/api_calls.dart';
import '../shared/firebase.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});
  static const String routeName = "/signupScreen";

  @override
  SignupState createState() => SignupState();
}

class SignupState extends State<SignupScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final FocusNode firstNameFocusNode = FocusNode();
  Color firstNameFillColor = ColorsUI.backgroundColor;
  bool _firstNameEntered = true;

  final TextEditingController _lastNameController = TextEditingController();
  final FocusNode lastNameFocusNode = FocusNode();
  Color lastNameFillColor = ColorsUI.backgroundColor;
  bool _lastNameEntered = true;

  final TextEditingController _emailController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  Color emailFillColor = ColorsUI.backgroundColor;
  bool _emailEntered = true;

  final TextEditingController _phoneController = TextEditingController();
  final FocusNode phoneFocusNode = FocusNode();
  Color phoneFillColor = ColorsUI.backgroundColor;

  final TextEditingController _zipCodeController = TextEditingController();
  final FocusNode zipCodeFocusNode = FocusNode();
  Color zipCodeFillColor = ColorsUI.backgroundColor;

  bool _isLoading = false;
  int userType = 1;

  void _onPhoneFocusChange() {
    setState(() {
      phoneFillColor =
          phoneFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onEmailFocusChange() {
    setState(() {
      emailFillColor =
          emailFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onFirstNameFocusChange() {
    setState(() {
      firstNameFillColor =
          firstNameFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onLastNameFocusChange() {
    setState(() {
      lastNameFillColor =
          lastNameFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
    });
  }

  void _onZipCodeFocusChange() {
    setState(() {
      zipCodeFillColor =
          zipCodeFocusNode.hasFocus ? Colors.white : ColorsUI.backgroundColor;
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
              padding: const EdgeInsets.only(top: 48.0),
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
                      Text("Create Account", style: CustomStyles.headingText),
                    ],
                  ),
                  DesignWidgets.addVerticalSpace(24),
                  Text(
                    "First Name*",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        controller: _firstNameController,
                        focusNode: firstNameFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter your first name",
                          filled: true,
                          fillColor: firstNameFillColor,
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
                    "Last Name*",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        controller: _lastNameController,
                        focusNode: lastNameFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter your last name",
                          filled: true,
                          fillColor: lastNameFillColor,
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
                    "Primary Email*",
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
                    "Primary Phone",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        controller: _phoneController,
                        focusNode: phoneFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter your phone number",
                          filled: true,
                          fillColor: phoneFillColor,
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
                    "Zip Code",
                    style: CustomStyles.subHeadingText,
                  ),
                  DesignWidgets.addVerticalSpace(8),
                  Stack(
                    children: [
                      TextField(
                        controller: _zipCodeController,
                        focusNode: zipCodeFocusNode,
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          hintText: "Enter your zip code",
                          filled: true,
                          fillColor: zipCodeFillColor,
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
                  DesignWidgets.getButton(
                      disabled: true,
                      isLoading: _isLoading,
                      text: "Sign up",
                      onTap: () {
                        String email = _emailController.text;
                        String firstName = _firstNameController.text;
                        String lastName = _lastNameController.text;

                        setState(() {
                          _emailEntered = email.isNotEmpty &&
                              RegExp(r'\S+@\S+\.\S+').hasMatch(email);
                          _firstNameEntered = firstName.isNotEmpty;
                          _lastNameEntered = lastName.isNotEmpty;
                        });
                        try {
                          if (!_emailEntered ||
                              !_firstNameEntered ||
                              !_lastNameEntered) {
                            return;
                          }
                          ApiCalls.login(email, firstName, context, (loading) {
                            setState(() {
                              _isLoading = loading;
                            });
                          }).then((String result) {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                              return LoginScreen();
                            }));
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return LoginScreen();
                        }));
                      },
                      child: const Text(
                        "Already have an account?",
                        style: TextStyle(
                            color: ColorsUI.primaryColor, fontSize: 16),
                      ),
                    ),
                  ),
                  DesignWidgets.addVerticalSpace(24),
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
    emailFocusNode.addListener(_onEmailFocusChange);
    firstNameFocusNode.addListener(_onFirstNameFocusChange);
    lastNameFocusNode.addListener(_onLastNameFocusChange);
    phoneFocusNode.addListener(_onPhoneFocusChange);
    zipCodeFocusNode.addListener(_onZipCodeFocusChange);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneController.dispose();
    _zipCodeController.dispose();
    super.dispose();
  }
  /////////////////////////
}
