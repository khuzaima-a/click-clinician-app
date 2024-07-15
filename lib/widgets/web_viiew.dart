import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  double _loadingProgress = 0; // State variable to track loading progress

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            setState(() {
              _loadingProgress = progress / 100; // Update loading progress
            });
          },
          onPageStarted: (String url) {
            setState(() {
              _loadingProgress = 0; // Reset loading progress on page start
            });
          },
          onPageFinished: (String url) {
            setState(() {
              _loadingProgress = 1; // Complete loading progress on page finish
            });
          },
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: Stack(
          children: [
            WebViewWidget(controller: _controller),
            if (_loadingProgress <
                1) // Show loading indicator if loading is not complete
              LinearProgressIndicator(
                value:
                    _loadingProgress, // Use the loading progress for the indicator value
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
              ),
          ],
        ),
      ),
    );
  }
}
