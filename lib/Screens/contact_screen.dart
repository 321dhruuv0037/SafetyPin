import 'package:flutter/material.dart';
import 'package:test1/model/note_model.dart';
import 'package:test1/services/database_helper.dart';

class NoteScreen extends StatefulWidget {
  final Note? note;

  const NoteScreen({Key? key, this.note}) : super(key: key);

  @override
  _NoteScreenState createState() => _NoteScreenState();
}

class _NoteScreenState extends State<NoteScreen> {
  late TextEditingController titleController;
  late TextEditingController descriptionController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.note?.title ?? '');
    descriptionController =
        TextEditingController(text: widget.note?.description ?? '');
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  String? validateContactNumber(String? value) {
    if (value == null || value.isEmpty) {
      return 'Contact number cannot be empty';
    } else if (value.length < 10) {
      return 'Contact number must be at least 10 digits long';
    } else if (!RegExp(r'^[0-9()-\s]+$').hasMatch(value)) {
      return 'Contact number can only contain numbers, hyphens, parentheses, and spaces';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.note == null ? 'Add Emergency Contact' : 'Edit Contact'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(bottom: 40),
              child: Center(),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 40.0),
              child: TextFormField(
                cursorColor: Color.fromARGB(255, 225, 160, 160),
                controller: titleController,
                maxLines: 1,
                decoration: InputDecoration(
                  hintText: 'Contact Name',
                  hintStyle: const TextStyle(
                    color: Colors.grey,
                  ),
                  labelText: 'Enter contact\'s name here',
                  labelStyle: const TextStyle(
                    color: Color.fromARGB(255, 225, 160, 160),
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.white,
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Color.fromARGB(255, 225, 160, 160), // Focus color
                      width: 0.75,
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
            TextFormField(
              cursorColor: Color.fromARGB(255, 225, 160, 160),
              controller: descriptionController,
              validator: validateContactNumber,
              decoration: InputDecoration(
                hintText: 'Contact Number',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                labelText: 'Enter contact\'s number here',
                labelStyle: const TextStyle(
                  color: Color.fromARGB(255, 225, 160, 160),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Colors.white,
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(
                    color: Color.fromARGB(255, 225, 160, 160), // Focus color
                    width: 0.75,
                  ),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              keyboardType: TextInputType.number,
              onChanged: (str) {
                // Add your logic here if needed
              },
            ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: SizedBox(
                height: 45,
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  onPressed: () async {
                    final title = titleController.text;
                    final description = descriptionController.text;

                    if (title.isEmpty || description.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please fill in all fields!'),
                        ),
                      );
                      return;
                    }

                    if (description.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter a valid mobile number!'),
                        ),
                      );
                      return;
                    }

                    final Note model = Note(
                      title: title,
                      description: description,
                      id: widget.note?.id,
                    );

                    if (widget.note == null) {
                      await DatabaseHelper.addNote(model);
                    } else {
                      await DatabaseHelper.updateNote(model);
                    }

                    Navigator.pop(context);
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith(
                          (states) => Color.fromARGB(255, 225, 160, 160),
                    ),
                    foregroundColor: MaterialStateProperty.resolveWith(
                          (states) => Colors.white,
                    ),
                    shape: MaterialStateProperty.all(
                      RoundedRectangleBorder(
                        side: BorderSide(
                          color: Colors.white,
                          width: 0.75,
                        ),
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                    ),
                  ),
                  child: Text(
                    widget.note == null ? 'Save' : 'Save Changes',
                    style: const TextStyle(fontSize: 20),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
