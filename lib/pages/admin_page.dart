import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  static const String routeName = '/admin';

  @override
  _AdminPageState createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  List<String> docIDs = [];
  List<bool> ordersDelivered = [];

  @override
  void initState() {
    super.initState();
    // Initialize the data and set up a listener for changes
    _setupDataListener();
  }

  // Function to set up a listener for changes in the database
  void _setupDataListener() {
    FirebaseFirestore.instance
        .collection('TokenNumbers')
        .snapshots()
        .listen((snapshot) {
      // Clear the lists before updating
      docIDs.clear();
      ordersDelivered.clear();

      for (QueryDocumentSnapshot<Map<String, dynamic>> document
          in snapshot.docs) {
        docIDs.add(document.reference.id);
        ordersDelivered.add(document.data()['delivered'] ?? false);
      }

      // Trigger a rebuild of the widget to reflect the updated data
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Admin Page'),
        backgroundColor: Colors.blueAccent,
      ),
      backgroundColor: Colors.black.withOpacity(0.9),
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
                child: ListView.builder(
                  itemCount: docIDs.length,
                  itemBuilder: (context, index) {
                    if (ordersDelivered[index]) {
                      return Container(); // Hide delivered orders
                    } else {
                      return Card(
                        elevation: 2,
                        margin: EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        color: Colors.grey[800],
                        child: ListTile(
                          title: Text(
                            'Token Number: ${docIDs[index]}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Column(
                            children: [
                              FutureBuilder<String>(
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
                              ElevatedButton(
                                onPressed: () {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        'Order ${docIDs[index]} delivered',
                                      ),
                                      backgroundColor: Colors.green[500],
                                    ),
                                  );

                                  setState(() {
                                    ordersDelivered[index] = true;
                                  });
                                },
                                child: Text("Delivered"),
                              ),
                            ],
                          ),
                        ),
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
