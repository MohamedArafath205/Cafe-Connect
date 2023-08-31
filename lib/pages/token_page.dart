import 'package:cafeconnect/components/cancel_button.dart';
import 'package:cafeconnect/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenPage extends StatefulWidget {
  final int orderNumber;
  final String itemNames;
  const TokenPage({required this.orderNumber, required this.itemNames});

  @override
  State<TokenPage> createState() => TokenPageState();
}

class TokenPageState extends State<TokenPage> {
  void reduceOrderCount() async {
    DocumentReference orderCountRef =
        FirebaseFirestore.instance.collection('OrderCount').doc('count');

    // Get the current order count
    var data = (await orderCountRef.get()).data() as Map<String, dynamic>?;
    int orderCount = data?['count'] ?? 0;

    if (orderCount > 0) {
      orderCount--;
      await orderCountRef.set({'count': orderCount});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // successfull gif
            const SizedBox(height: 100),
            Image.asset('lib/images/successfull.gif', height: 150),
            const SizedBox(height: 15),

            // order recieved text
            const Text(
              "Order Recieved Successfully!",
              style: TextStyle(),
            ),

            // order number
            const SizedBox(height: 150),
            Text(
              "Token number: ${widget.orderNumber}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ), // displays current order number

            // Your order
            const SizedBox(height: 25),
            Text(
              "Your Items: ${widget.itemNames}",
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            const Spacer(),

            // cancel button
            MyCancelButton(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return CupertinoAlertDialog(
                          title: Text(
                            "Warning",
                            style: TextStyle(color: Colors.red[500]),
                          ),
                          content: const Text(
                              "If you cancel your order, your money will be refunded after 5-7 working days only. Are you sure you want to cancel this order?"),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: const Text("Order Cancelled!"),
                                    backgroundColor: Colors.red[500],
                                  ),
                                );

                                reduceOrderCount();

                                FirebaseFirestore.instance
                                    .collection("TokenNumbers")
                                    .doc(widget.orderNumber.toString())
                                    .delete()
                                    .then(
                                      (doc) => print("Document deleted"),
                                      onError: (e) =>
                                          print("Error updating document $e"),
                                    );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => HomePage()));
                              },
                              child: const Text("Ok"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("Cancel"),
                            ),
                          ],
                        );
                      });
                },
                text: "Cancel Order"),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
