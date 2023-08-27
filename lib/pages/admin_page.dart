import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatefulWidget {
  AdminPage({super.key});

  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  void FetchingData() async {
    var result =
        await FirebaseFirestore.instance.collection('TokenNumbers').get();
    for (var doc in result.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
    }
  }

  @override
  void initState() {
    super.initState();
    FetchingData();
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
            ],
          ),
        ),
      ),
    );
  }
}
