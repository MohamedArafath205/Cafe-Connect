import 'package:cafeconnect/components/cancel_button.dart';
import 'package:cafeconnect/pages/home_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TokenPage extends StatefulWidget {
  final int orderNumber;
  final String itemNames;
  const TokenPage(
      {super.key, required this.orderNumber, required this.itemNames});

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

  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 1));

    // Play the confetti effect automatically when the page is entered.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _confettiController.play();
    });
  }

  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // successfull gif
            const SizedBox(height: 100),
            Align(
              alignment: Alignment.center,
              child: ConfettiWidget(
                confettiController: _confettiController,
                blastDirectionality: BlastDirectionality.explosive,
                colors: const [
                  Colors.green,
                  Colors.blue,
                  Colors.pink,
                  Colors.orange,
                  Colors.purple
                ], // manually specify the colors to be used
                createParticlePath: drawStar, // define a custom shape/path.
              ),
            ),
            const Icon(
              Icons.check_circle_rounded,
              color: Colors.green,
              size: 150,
            ),
            const SizedBox(height: 15),

            // order recieved text
            const Text(
              "Order Placed Successfully!",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
              ),
            ),

            // order number
            const SizedBox(height: 150),
            Text(
              "Token number: ${widget.orderNumber}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ), // displays current order number

            // Your order
            const SizedBox(height: 25),
            Text(
              "Your Items: ${widget.itemNames}",
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
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
                              child: const Text(
                                "Ok",
                                style: TextStyle(color: Colors.red),
                              ),
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
