import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewScreen extends StatefulWidget {
  final String urlWebView;

  const WebViewScreen({Key? key, required this.urlWebView}) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState(urlWebView);
}

class _WebViewScreenState extends State<WebViewScreen> {
  final String urlWebView;
  late bool isLoading = true;

  _WebViewScreenState(this.urlWebView);

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          WebView(
            javascriptMode: JavascriptMode.unrestricted,
            initialUrl: urlWebView,
            onPageFinished: (finish) {
              setState(() {
                isLoading = false;
              });
            },
          ),
          isLoading
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Stack()
        ],
      ),
    );
  }
}
