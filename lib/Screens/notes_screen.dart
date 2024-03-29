import 'package:flutter/material.dart';
import 'package:test1/model/navBar.dart';
import '../home.dart';
import '../model/note_model.dart';
import '../services/database_helper.dart';
import '../Screens/note_widget.dart';
import 'contact_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({Key? key}) : super(key: key);

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  int _selectedIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      if (_selectedIndex == 0) {
        // Check if "Home" tab is selected
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Home()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      drawer: const NavBar(),
      appBar: AppBar(
        title: const Text('Emergency Contacts'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const NoteScreen()),
          );
          setState(() {});
        },
        backgroundColor: Colors.red.shade900, // Set the background
        foregroundColor: Colors.white,
        elevation: 2, // Set the elevation
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50), // Set the border radius
        ),
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder<List<Note>?>(
        future: DatabaseHelper.getAllNotes(),
        builder: (context, AsyncSnapshot<List<Note>?> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Center(child: Text(snapshot.error.toString()));
          } else if (snapshot.hasData) {
            if (snapshot.data != null) {
              return ListView.builder(
                itemBuilder: (context, index) => NoteWidget(
                  note: snapshot.data![index],
                  onTap: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NoteScreen(
                          note: snapshot.data![index],
                        ),
                      ),
                    );
                    setState(() {});
                  },
                  onLongPress: () async {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                              'Are you sure you want to delete this note?'),
                          actions: [
                            ElevatedButton(
                              onPressed: () async {
                                await DatabaseHelper.deleteNote(
                                    snapshot.data![index]);
                                Navigator.pop(context);
                                setState(() {});
                              },
                              child: Text(
                                'Yes',
                                style: TextStyle(color: Colors.red.shade900),
                              ),
                            ),
                            ElevatedButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text(
                                'No',
                                style: TextStyle(color: Colors.black),
                              ),
                            ),
                          ],
                        );
                      },
                    );
                  },
                ),
                itemCount: snapshot.data!.length,
              );
            }
            return const Center(
              child: Text('No notes yet'),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
