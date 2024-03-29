import 'package:flutter/material.dart';
import 'package:test1/Screens/notes_screen.dart';
import 'home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainApp(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: [
          Home(),
          NotesScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.contacts), label: 'Contacts'),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.red[900], // Active icon color
        selectedLabelStyle:
            TextStyle(color: Colors.red[900]), // Active label color
        unselectedItemColor: Colors.grey[600], // Inactive icon color
        unselectedLabelStyle:
            TextStyle(color: Colors.grey[600]), // Inactive label color
        onTap: _onItemTapped,
      ),
    );
  }
}
