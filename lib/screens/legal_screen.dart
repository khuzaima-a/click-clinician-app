/////////////////////////////////////////////////////////
// <copyright company="Click Clinician">
// Copyright (c) 2023 All Rights Reserved
// </copyright>
// <author>Jeremy Snyder</author>
// <date>JUNE 13, 2023</date>
/////////////////////////////////////////////////////////

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
// Import for iOS features.
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

import '../widgets/nav_drawer.dart';
import '../widgets/shared.dart';

class LegalScreen extends StatefulWidget
{
  const LegalScreen({super.key});

  static const String routeName = '/Legal';

  @override
  State<StatefulWidget> createState() => LegalScreenState();
}

class LegalScreenState extends State<LegalScreen>
{
  late final WebViewController _controller;

  @override
  void initState() {
    super.initState();

    late final PlatformWebViewControllerCreationParams params;
    if (WebViewPlatform.instance is WebKitWebViewPlatform) {
      params = WebKitWebViewControllerCreationParams(
        allowsInlineMediaPlayback: true,
        mediaTypesRequiringUserAction: const <PlaybackMediaTypes>{},
      );
    } else {
      params = const PlatformWebViewControllerCreationParams();
    }

    final WebViewController controller =
        WebViewController.fromPlatformCreationParams(params);

    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
         onNavigationRequest: (NavigationRequest request) {
            if (!request.url.startsWith('https://clickclinician.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..addJavaScriptChannel(
        'Toaster',
        onMessageReceived: (JavaScriptMessage message) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(message.message)),
          );
        },
      )
      ..loadRequest(Uri.parse('https://clickclinician.com/privacy-policy/'));

    _controller = controller;
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: getAppBar(),
      drawer: const NavDrawer(),
      body: Padding(
        padding: const EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0, bottom: 15.0),
        child: WebViewWidget(
          controller: _controller,
        ),
      ),
    );
  }
}
