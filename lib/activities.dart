import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Activity extends StatelessWidget {
  const Activity({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Women Safety Blogs'),
        ),
        body: Center(
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('womenSafety')
                .doc('Blogs')
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              }
              if (!snapshot.hasData || snapshot.data!.data() == null) {
                return Text('No data available');
              }
              // Assuming your data structure is Map<String, dynamic>
              final Map<String, dynamic> data =
              snapshot.data!.data() as Map<String, dynamic>;
              // Display all contents from the document
              List<Widget> children = [];
              data.forEach((key, value) {
                if (key != 'Hello') { // Exclude 'Hello' field if it's present
                  children.add(
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('$key:'),
                        Text(value.toString()), // Display value as string
                      ],
                    ),
                  );
                }
              });
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: children,
              );
            },
          ),
        ),
      ),
    );
  }
}
