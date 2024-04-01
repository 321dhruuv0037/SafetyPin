import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';

class MyHospital extends StatefulWidget {
  const MyHospital({Key? key}) : super(key: key);

  @override
  State<MyHospital> createState() => _MyHospitalState();
}

class _MyHospitalState extends State<MyHospital> {
  double _progress = 0;
  Position? currentPosition;
  late InAppWebViewController inAppWebViewController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Hospitals near me'),
        actions: [
          IconButton(
            icon: Icon(Icons.map),
            onPressed: () {
              _launchGoogleMaps();
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          InAppWebView(
            initialUrlRequest: URLRequest(
              url: WebUri(
                  "https://www.google.com/maps/search/Hospitals+near+me"),
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

  Future<void> _getLocation() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      );
      setState(() {
        currentPosition = position;
      });
    } catch (e) {
      print('Error getting location: $e');
      // Handle error, for example, show a snackbar or retry logic
    }
  }

  Future<void> _launchGoogleMaps() async {
    await _getLocation();
    var url;
    if (currentPosition == null) {
      url = "https://www.google.com/maps/search/Hospitals+near+me";
    } else {
      url =
          "https://www.google.com/maps/search/Hospitals/@${currentPosition!.latitude},${currentPosition!.longitude},15z";
    }
    try {
      await launchUrl(Uri.parse(url));
    } catch (e) {
      print('Error launching Google Maps: $e');
      // Handle error, for example, show a snackbar or retry logic
    }
  }
}
