/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:flutter/material.dart';

import '../shared/api_calls.dart';
import '../widgets/nav_drawer.dart';
import '../widgets/shared.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  static const String routeName = '/Chat';

  @override
  State<StatefulWidget> createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ApiCalls.getAllServiceRequests('', context).then(
      (value) => {},
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      drawer: const NavDrawer(),
      body: Container(),
    );
  }
}
