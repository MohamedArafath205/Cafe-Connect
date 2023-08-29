import 'package:cloud_firestore/cloud_firestore.dart';
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
              Text(
                "Today's Order",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
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
                          return Card(
                            elevation: 2,
                            margin: EdgeInsets.symmetric(
                              vertical: 8,
                              horizontal: 16,
                            ),
                            color: Colors.grey[200],
                            child: ListTile(
                              title: Text(
                                'Token Number: ${docIDs[index]}',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: FutureBuilder<String>(
                                future: _getItemNames(docIDs[index]),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    return Text(
                                      'Items:\n${snapshot.data}',
                                      style: TextStyle(fontSize: 16),
                                    );
                                  }
                                },
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

  Future<String> _getItemNames(String docID) async {
    try {
      DocumentSnapshot<Map<String, dynamic>> docSnapshot =
          await FirebaseFirestore.instance
              .collection('TokenNumbers')
              .doc(docID)
              .get();

      if (!docSnapshot.exists) {
        return 'No data available';
      }

      Map<String, dynamic>? data = docSnapshot.data();

      if (data == null) {
        return 'N/A';
      }

      String itemDetails = '';

      data.forEach((key, value) {
        if (key != 'OrderCount') {
          itemDetails += '$key - ₹$value\n';
        }
      });

      return itemDetails.trim(); // Remove trailing newline
    } catch (e) {
      return 'N/A';
    }
  }
}
