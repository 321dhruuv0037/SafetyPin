import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';

import '../Screens/my_busstops.dart';
import '../Screens/my_firestations.dart';
import '../Screens/my_hospital.dart';
import '../Screens/my_medicals.dart';
import '../Screens/my_police.dart';
import 'package:test1/services/database_helper.dart';

class NavBar extends StatelessWidget {
  const NavBar({super.key});

  @override
  Widget build(BuildContext context) {
    // _makePhoneCall(var phoneNumber) async {
    //   try {
    //     await FlutterPhoneDirectCaller.callNumber(phoneNumber);
    //     print("Calling $phoneNumber");
    //   } catch (e) {
    //     print("Error making phone call: $e");
    //   }
    // }
    _makePhoneCall() async {
      List<String> phoneNumbers = await DatabaseHelper.getAllPhoneNumbers();
      if (phoneNumbers.isNotEmpty) {
        String firstPhoneNumber = phoneNumbers.first;
        try {
          await FlutterPhoneDirectCaller.callNumber(firstPhoneNumber);
          print("Calling $firstPhoneNumber");
        } catch (e) {
          print("Error making phone call: $e");
        }
      } else {
        print("No phone numbers available");
      }
    }

    return Drawer(
      backgroundColor: const Color.fromARGB(255, 237, 221, 223),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            const Padding(
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
            const SizedBox(height: 10),
            ListTile(
                title: const Text('Police Stations'),
                leading: const Icon(Icons.local_police_outlined),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyPolice()));
                }),
            ListTile(
                title: const Text('Hospitals'),
                leading: const Icon(Icons.local_hospital_outlined),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyHospital()));
                }),
            ListTile(
              title: const Text('Medicals'),
              leading: const Icon(Icons.medication_outlined),
              onTap: () async {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MyMedicals()));
              },
            ),
            ListTile(
                title: const Text('Bus Stops'),
                leading: const Icon(Icons.directions_bus_outlined),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyBusstops()));
                }),
            ListTile(
                title: const Text('Fire Stations'),
                leading: const Icon(Icons.fire_extinguisher_outlined),
                onTap: () async {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MyFirestation()));
                }),
            ElevatedButton(

              onPressed: () => _makePhoneCall(),
              // onPressed: () => _makePhoneCall("9130102407"),
              // onPressed: () => _makePhoneCall("9757023141"),
              child: const Text('Make Emergency Call'),
              style: ButtonStyle(
                  foregroundColor:
                      MaterialStateProperty.all(Colors.red.shade900)),
            ),
          ],
        ),
      ),
    );
  }
}
