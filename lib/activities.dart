import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity extends StatefulWidget {
  const Activity({Key? key}) : super(key: key);

  @override
  _ActivityState createState() => _ActivityState();
}

class _ActivityState extends State<Activity> {
  late Stream<DocumentSnapshot> _stream;

  @override
  void initState() {
    super.initState();
    _stream = FirebaseFirestore.instance
        .collection('womenSafety')
        .doc('Blogs')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.pinkAccent,
        hintColor: Colors.pinkAccent,
        textTheme: TextTheme(
          headline6: TextStyle(color: Colors.pinkAccent, fontSize: 20),
          bodyText1: TextStyle(color: Colors.black, fontSize: 16),
        ),
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Activities'),
          backgroundColor: Colors.pinkAccent, // Setting app bar color
        ),
        body: Center(
          child: StreamBuilder(
            stream: _stream,
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text(
                  'Error: ${snapshot.error}',
                  style: TextStyle(color: Colors.red),
                );
              }
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Text(
                  'No data available',
                  style: TextStyle(color: Colors.black),
                );
              }
              final Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
              return ListView.builder(
                itemCount: data.length,
                itemBuilder: (context, index) {
                  var key = data.keys.toList()[index];
                  var value = data[key];
                  if (key != 'Hello') {
                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => BlogActivity(
                              title: key,
                              content: value.toString(),
                            ),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(
                          key,
                          style: TextStyle(
                            color: Colors.pinkAccent,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              );
            },
          ),
        ),
      ),
    );
  }
}

class BlogActivity extends StatelessWidget {
  final String title;
  final String content;

  const BlogActivity({required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.pinkAccent, // Setting app bar color
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Text(
          content,
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}
