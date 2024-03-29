import 'package:flutter/material.dart';
import 'package:test1/model/note_model.dart';

class NoteWidget extends StatelessWidget {
  final Note note;
  final VoidCallback onTap;
  final VoidCallback onLongPress;

  const NoteWidget({
    Key? key,
    required this.note,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
      child: InkWell(
        onLongPress: onLongPress,
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 6),
          child: Card(
            elevation: 2,
            // color: Color.fromARGB(
            //     255, 255, 172, 172), // Set the background color here
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                    child: Divider(
                      thickness: 1,
                    ),
                  ),
                  Text(
                    note.description,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
