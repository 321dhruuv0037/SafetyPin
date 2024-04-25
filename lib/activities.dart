import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:test1/model/navBar.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        hintColor: Colors.pinkAccent,
        textTheme: const TextTheme(
          titleLarge: TextStyle(color: Colors.pinkAccent, fontSize: 20),
          bodyLarge: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      home: Activity(),
    );
  }
}

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late List<File> _pdfFiles = [];

  @override
  void initState() {
    super.initState();
    _loadPDFFiles();
  }

  Future<void> _loadPDFFiles() async {
    final String pdfPath = 'assets/First_Aid_Instructions.pdf';
    final ByteData data = await rootBundle.load(pdfPath);
    final Uint8List bytes = data.buffer.asUint8List();

    final tempDir = Directory.systemTemp;
    final tempFile = File('${tempDir.path}/First_Aid_Instructions.pdf');
    await tempFile.writeAsBytes(bytes);

    setState(() {
      _pdfFiles = [tempFile];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Articles'),
        centerTitle: true,
      ),
      // Including the NavBar widget here
      drawer: NavBar(),
      body: Center(
        child: _pdfFiles.isEmpty
            ? CircularProgressIndicator()
            : ListView.builder(
                itemCount: _pdfFiles.length,
                itemBuilder: (context, index) {
                  File file = _pdfFiles[index];
                  String fileName = file.path.split('/').last;
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PDFViewer(
                            title: fileName.replaceAll('.pdf', ''),
                            file: file,
                          ),
                        ),
                      );
                    },
                    child: ListTile(
                      title: Text(
                        fileName.replaceAll('.pdf', ''),
                        style: TextStyle(
                          color: Colors.red.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      tileColor: Colors.pink[50], // Set tile background color
                      contentPadding: EdgeInsets.all( 16.0),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.red.shade900,
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }
}

class PDFViewer extends StatelessWidget {
  final String title;
  final File file;

  const PDFViewer({required this.title, required this.file});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pink[50],
      ),
      body: PDFView(
        filePath: file.path,
      ),
    );
  }
}
