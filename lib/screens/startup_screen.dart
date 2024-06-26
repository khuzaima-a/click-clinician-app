/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>MAY 29, 2023</date>
/////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

import '../data/shared_preferences.dart';
import '../shared/api_calls.dart';
import 'login_screen.dart';
import 'map_screen.dart';

class StartupScreen extends StatefulWidget {
  const StartupScreen({super.key});

  static const String routeName = '/';

  @override
  State<StartupScreen> createState() => StartupScreenState();
}

class StartupScreenState extends State<StartupScreen>
    with TickerProviderStateMixin {
  static final SPSettings settings = SPSettings();

  int animationLength = 3;
  late final AnimationController _animationController = AnimationController(
    duration: Duration(seconds: animationLength),
    vsync: this,
  )..repeat();

  late final Animation<double> _animation = CurvedAnimation(
    parent: _animationController,
    curve: Curves.fastOutSlowIn,
  );

  void _executeAfterBuild(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1));

    // ignore: use_build_context_synchronously
    if (!context.mounted) return;

    if (ApiCalls.bearerToken == '') {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const LoginScreen()));
    } else {
      Navigator.push(context,
          MaterialPageRoute(builder: (context) => const MapScreen()));
    }
  }

  @override
  void initState() {
    settings.init().then((value) {
      setState(
        () {
          // settings.setClickUser(null);
          // settings.setServiceRequests(null);
        },
      );
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _animationController.forward().whenComplete(() {
      _executeAfterBuild(context);
    });

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizeTransition(
        sizeFactor: _animation,
        axis: Axis.horizontal,
        axisAlignment: -1,
        child: const Center(
          child: Image(
              fit: BoxFit.contain,
              image: AssetImage('assets/images/click_logo.png')),
        ),
      ),
    );
  }
}
