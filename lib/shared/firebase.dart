/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 14, 2023</date>
/////////////////////////////////////////////////////////

import 'package:clickclinician/screens/map_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseMessenger {
  static Future<FirebaseApp> initializeFirebase() async {
    var firebaseApp = await Firebase.initializeApp();
    return firebaseApp;
  }

  static Future<NotificationSettings> requestNotificationPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      carPlay: true,
      criticalAlert: true,
      // provisional: true,
    );

    // if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    //   debugPrint('user granted permission');
    // } else if (settings.authorizationStatus ==
    //     AuthorizationStatus.provisional) {
    //   debugPrint('user granted provisional permission');
    // } else {
    //   debugPrint('user denied permission');
    // }

    return settings;
  }

  static Future<String?> registerDeviceForNotifications() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    debugPrint('inside registed device for notifications call');

    String? token;
    print('firebase notification token: $token');

    try {
      token = await messaging.getToken();
    } catch (exception) {
      return null;
    }
    print('firebase notification token: $token');

    return token;
  }

  static Future<void> setupInteractMessage(BuildContext context) async {
    //when app terminated
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      handleMessage(context, initialMessage);
    }

    //when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((event) {
      handleMessage(context, event);
    });
  }

  static void handleMessage(BuildContext context, RemoteMessage message) {
    // if (message.data['type'] == 'msj') {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MapScreen(),
      ),
    );
    // }
  }

  static Future<bool> getNotificationSettings() async {
    //when app terminated
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings notificationPermission =
        await messaging.getNotificationSettings();

    print(
        'firebase notification messaging===================================================================: ${notificationPermission.authorizationStatus}');

    return (notificationPermission.authorizationStatus ==
            AuthorizationStatus.authorized) ||
        (notificationPermission.authorizationStatus ==
            AuthorizationStatus.provisional);
  }
}
