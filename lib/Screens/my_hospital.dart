import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class MyHospital extends StatefulWidget {
  const MyHospital({Key? key}) : super(key: key);

  @override
  State<MyHospital> createState() => _MyHospitalState();
}

class _MyHospitalState extends State<MyHospital> {
  double _progress = 0;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals near me'),
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri("https://www.google.com/maps/search/Hospitals+near+me"),
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
