import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyBusstops extends StatefulWidget {
  const MyBusstops({Key? key}) : super(key: key);

  @override
  State<MyBusstops> createState() => _MyBusstopsState();
}

class _MyBusstopsState extends State<MyBusstops> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Bus Stops near me'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://www.google.com/maps/search/Bus+Stops+near+me"),
            ),
            onWebViewCreated: (InAppWebViewController controller) {
              inAppWebViewController = controller;
            },
            onProgressChanged: (controller, progress) {
              setState(() {
                _progress = progress / 100;
              });
            },
          ),
          _progress < 1.0
              ? LinearProgressIndicator(value: _progress)
              : Container(),
        ],
      ),
    );
  }
}
