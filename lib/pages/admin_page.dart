import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> docIDs = [];

  Future<void> fetchingData() async {
    docIDs.clear(); // Clear the list before fetching new data
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await FirebaseFirestore.instance.collection('TokenNumbers').get();

    for (QueryDocumentSnapshot<Map<String, dynamic>> document
        in snapshot.docs) {
      docIDs.add(document.reference.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.grey[300],
      body: Center(
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text("Today's Order"),
              Expanded(
                child: FutureBuilder<void>(
                  future: fetchingData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return ListView.builder(
                        itemCount: docIDs.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {},
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 16),
                              color: Colors.grey[200],
                              child: ListTile(
                                title: Text('Order Number: ${docIDs[index]}'),
                                trailing: Icon(Icons.arrow_forward),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
