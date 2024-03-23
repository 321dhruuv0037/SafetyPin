import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyFirestation extends StatefulWidget {
  const MyFirestation({Key? key}) : super(key: key);

  @override
  State<MyFirestation> createState() => _MyFirestationState();
}

class _MyFirestationState extends State<MyFirestation> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fire Station near me'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://www.google.com/maps/search/Fire+Stations+near+me"),
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
