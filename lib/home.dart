import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:test1/Screens/my_busstops.dart';
import 'package:test1/Screens/my_firestations.dart';
import 'package:test1/Screens/my_hospital.dart';
import 'package:test1/Screens/my_medicals.dart';
import 'package:test1/Screens/my_police.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    double buttonsize = screenHeight * 0.2;
    return Scaffold(
      appBar: AppBar(
        title: Text('SOS Button'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => _sendSOS(context),
          child: Icon(Icons.add_alert, size: buttonsize * 0.5),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red.shade900,
            foregroundColor: Colors.white,
            fixedSize: Size.square(buttonsize),
            shape: CircleBorder(),
            padding: EdgeInsets.all(24),
          ),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 237, 221, 223),
        child: SafeArea(
          child: Column(
            children: [
              SizedBox(height: 20),
              Padding(
                padding: EdgeInsets.only(left: 16),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Facilities Near You",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              ListTile(
                  title: Text('Police Stations'),
                  leading: Icon(Icons.local_police_outlined),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyPolice()));
                  }
              ),
              ListTile(
                  title: Text('Hospitals'),
                  leading: Icon(Icons.local_hospital_outlined),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyHospital()));
                  }
              ),
              ListTile(
                title: Text('Medicals'),
                leading: Icon(Icons.medication_outlined),
                onTap: () async {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => MyMedicals()));
                },
              ),
              ListTile(
                  title: Text('Bus Stops'),
                  leading: Icon(Icons.directions_bus_outlined),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyBusstops()));
                  }
              ),
              ListTile(
                  title: Text('Fire Stations'),
                  leading: Icon(Icons.fire_extinguisher_outlined),
                  onTap: () async {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => MyFirestation()));
                  }
              ),
              ElevatedButton(
                onPressed: () => _makePhoneCall("9130102407"),
                // onPressed: () => _makePhoneCall("9757023141"),
                child: Text('Make Emergency Call'),
                style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all(Colors.red.shade900)
                ),
              ),
            ],
          ),
        ),
      ),
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
        String uri = 'sms:$phoneNumber?body=${message}';
        await launch(uri);
      } else if (Platform.isIOS) {
        String uri = 'sms:$phoneNumber&body=${message}';
        await launch(uri);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Some error occurred. Please try again!'),
        ),
      );
      print("Error sending SMS: $e");
    }
  }


  _sendSOS(BuildContext context) async {
    List<String> phoneNumber = [
      "+919757023141",
      "+919082307960",
      // "+91 72496 00529"
    ];

    _launchSms(context, phoneNumber);

    var status = await Permission.location.status;
    if (status.isDenied || status.isRestricted) {
      status = await Permission.location.request();
      if (status.isDenied || status.isRestricted) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("Permission Required"),
              content: Text("Location permission is required to use this feature."),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("OK"),
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
