import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyPolice extends StatefulWidget {
  const MyPolice({Key? key}) : super(key: key);

  @override
  State<MyPolice> createState() => _MyPoliceState();
}

class _MyPoliceState extends State<MyPolice> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Police Station near me'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://www.google.com/maps/search/Police+Station+near+me"),
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
