import 'package:clickclinician/utility/color_file.dart';
import 'package:clickclinician/utility/style_file.dart';
import 'package:clickclinician/utility/utils.dart';
import 'package:clickclinician/utility/widget_file.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/services.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  WebViewScreen({required this.url});

  @override
  _WebViewScreenState createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late WebViewController _controller;
  double _loadingProgress = 0; // State variable to track loading progress
  int userType = 2;
  bool _isCopied = false;

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
    return Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        backgroundColor: Colors.white,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: [
              DesignWidgets.addVerticalSpace(16),
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
              DesignWidgets.addVerticalSpace(8),
              userType == 1
                  ? Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Text(
                              "For Agencies, please contact us at",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: 14,
                                color: ColorsUI.headingColor,
                              ),
                            ),
                            DesignWidgets.addVerticalSpace(8.0),
                            const Text(
                              "contactus@clickclinician.com",
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                                color: ColorsUI.primaryColor,
                              ),
                            ),
                            DesignWidgets.addVerticalSpace(20.0),
                            GestureDetector(
                              onTap: () async {
                                await Clipboard.setData(const ClipboardData(
                                    text: 'contactus@clickclinician.com'));
                                setState(() {
                                  _isCopied = true;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60.0),
                                child: Container(
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color:
                                        ColorsUI.primaryColor.withOpacity(0.15),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Text(
                                        "contactus@clickclinician.com",
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: ColorsUI.headingColor,
                                        ),
                                      ),
                                      DesignWidgets.addHorizontalSpace(12),
                                      _isCopied
                                          ? const Icon(
                                              Icons.check,
                                              size: 16.0,
                                            )
                                          : const Icon(Icons.copy, size: 16.0),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                  : _loadingProgress < 1
                      ? Expanded(
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(),
                                DesignWidgets.addVerticalSpace(12),
                                Text(
                                  "Loading ${(_loadingProgress * 100).toInt()}%",
                                  style: CustomStyles.paragraphText,
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(
                          child: WebViewWidget(
                            controller: _controller,
                          ),
                        )
            ],
          ),
        ));
  }
}
