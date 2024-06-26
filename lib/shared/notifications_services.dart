import 'dart:io';
import 'dart:math';

import 'package:clickclinician/screens/map_screen.dart';
import 'package:clickclinician/shared/firebase.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './firebase.dart';
import 'package:flutter/material.dart';

class NotificationServices {
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  void initLocalNotifications(
      BuildContext context, RemoteMessage message) async {
    var androidInitialization = const AndroidInitializationSettings(
        '@drawable/clicclinician_notification_logo');
    var iosInitialization = const DarwinInitializationSettings();

    var initializationSetting = InitializationSettings(
      android: androidInitialization,
      iOS: iosInitialization,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSetting,
        onDidReceiveNotificationResponse: (payload) {
      handleMessage(context, message);
    });
  }

  void firebaseInit(BuildContext context) {
    FirebaseMessaging.onMessage.listen((message) {
      debugPrint(
          'in settings page firebase: title => ${message.notification!.title.toString()}');
      debugPrint(
          'in settings page firebase: body => ${message.notification!.body.toString()}');
      debugPrint(
          'in settings page firebase: data type=> ${message.data['type']}');
      debugPrint('in settings page firebase: data id => ${message.data['id']}');

      if (Platform.isAndroid) {
        initLocalNotifications(context, message);
        showNotifications(message);
      } else {
        showNotifications(message);
      }
    });
  }

  Future<void> showNotifications(RemoteMessage message) async {
    AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'Click Clinician',
      importance: Importance.max,
    );

    AndroidNotificationDetails androidNotificationDetails =
        AndroidNotificationDetails(
      channel.id.toString(),
      channel.name.toString(),
      channelDescription: 'Your Channel Descriptions',
      importance: Importance.high,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const DarwinNotificationDetails darwinNotificationDetails =
        DarwinNotificationDetails();

    NotificationDetails notificationDetails = NotificationDetails(
      android: androidNotificationDetails,
      iOS: darwinNotificationDetails,
    );

    Future.delayed(Duration.zero, () {
      _flutterLocalNotificationsPlugin.show(
        0,
        message.notification!.title.toString(),
        message.notification!.body.toString(),
        notificationDetails,
      );
    });
  }

  // everything is already defined in firebase.dart page
  // var requestPermission = FirebaseMessenger.requestNotificationPermission();
  void requestNotificationPermisson() async {
    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: true,
        carPlay: true,
        criticalAlert: true,
        provisional: true);

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      debugPrint('user granted permission');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      debugPrint('user granted provisional permission');
    } else {
      debugPrint('user denied permission');
    }

    // return settings;
  }
  // var getDeviceToken = FirebaseMessenger.registerDeviceForNotifications();

  Future<String> getDeviceToken() async {
    debugPrint('inside get device token');
    String? token = await messaging.getToken();
    return token!;
  }

  void isTokenRefresh() async {
    messaging.onTokenRefresh.listen((event) {
      event.toString();
    });
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
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return MapScreen();
    }));
    // }
  }
}
