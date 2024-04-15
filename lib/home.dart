import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sensors/sensors.dart'; // Import sensors package for shake to SOS feature
import 'package:test1/model/navBar.dart';
import 'package:test1/screens/notes_screen.dart'; // Adjusted import path
import 'package:test1/services/database_helper.dart';
import 'package:url_launcher/url_launcher.dart';

class Home extends StatefulWidget {
    // Add this line

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    // Start listening to sensor events
    accelerometerEvents.listen((AccelerometerEvent event) {
      // Check for shaking motion (you can adjust the threshold as needed)
      if (event.x.abs() > 12 || event.y.abs() > 12 || event.z.abs() > 12) {
        // Shake detected, trigger SOS action here
        _sendSOS(context);
      }
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 1) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const NotesScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonsize = screenHeight * 0.2;
    return Scaffold(
      appBar: AppBar(
        title: const Text('SOS Button'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _sendSOS(context),
          child: Icon(Icons.add_alert, size: buttonsize * 0.5),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            foregroundColor: Colors.white,
            fixedSize: Size.square(buttonsize),
            shape: const CircleBorder(),
            padding: const EdgeInsets.all(24),
          ),
        ),
      ),
      drawer: const NavBar(),
    );
  }

  _makePhoneCall(var phoneNumber) async {
    try {
      await FlutterPhoneDirectCaller.callNumber(phoneNumber);
      print("Calling $phoneNumber");
    } catch (e) {
      print("Error making phone call: $e");
    }
  }

  _getMapsLink() async {
    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      double latitude = position.latitude;
      double longitude = position.longitude;
      Uri mapsLink =
      Uri.parse("https://www.google.com/maps?q=$latitude,$longitude");

      return mapsLink;
    } catch (e) {
      print("Error obtaining location: $e");
      // Handle location retrieval error
    }
  }

  _launchSms(BuildContext context, List<String> phoneNumbers) async {
    try {
      Uri mapsLink = await _getMapsLink();
      String phoneNumber = "";
      String message = "SOS! I need help! My location is: $mapsLink";
      String number;
      for (number in phoneNumbers) {
        phoneNumber += number + ",";
      }
      if (Platform.isAndroid) {
        Uri uri = Uri.parse('sms:$phoneNumber?body=${message}');
        await launchUrl(uri);
      } else if (Platform.isIOS) {
        Uri uri = Uri.parse('sms:$phoneNumber&body=${message}');
        await launchUrl(uri);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Some error occurred. Please try again!'),
        ),
      );
      print("Error sending SMS: $e");
    }
  }

  _sendSOS(BuildContext context) async {
    List<String> phoneNumber = [];
    // List<String> phoneNumber = [
    //   "+919757023141",
    //   "+919082307960",
    //   "+919130102407",
    //   // "+91 72496 00529"
    // ];

    phoneNumber = await DatabaseHelper.getAllPhoneNumbers();
    print(phoneNumber);
    _launchSms(context, phoneNumber);

    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
      if (status.isDenied || status.isRestricted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text("Permission Required"),
              content: const Text(
                  "Location permission is required to use this feature."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("OK"),
                ),
              ],
            );
          },
        );
        return;
      }
    }

    try {
      Uri message = await _getMapsLink();
      print(message);
    } catch (e) {
      print("Error obtaining location: $e");
    }
  }
}
