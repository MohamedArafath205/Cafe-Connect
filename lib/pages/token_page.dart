import 'package:cafeconnect/components/cancel_button.dart';
import 'package:cafeconnect/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TokenPage extends StatefulWidget {
  final int orderNumber;
  final String itemNames;
  TokenPage({required this.orderNumber, required this.itemNames});

  @override
  State<TokenPage> createState() => TokenPageState();
}

class TokenPageState extends State<TokenPage> {
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
            Text(
              "Order Recieved Successfully!",
              style: TextStyle(),
            ),

            // order number
            const SizedBox(height: 150),
            Text(
              "Token number: ${widget.orderNumber}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ), // displays current order number

            // Your order
            const SizedBox(height: 25),
            Text(
              "Your Items: ${widget.itemNames}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),

            Spacer(),

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
                          content: Text(
                              "If you cancel your order, your money will be refunded after 5-7 working days only. Are you sure you want to cancel this order?"),
                          actions: [
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("Order Cancelled!"),
                                    backgroundColor: Colors.red[500],
                                  ),
                                );
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
                              child: Text("Ok"),
                            ),
                            MaterialButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: Text("Cancel"),
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
