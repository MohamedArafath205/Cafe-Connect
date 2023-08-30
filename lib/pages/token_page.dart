import 'package:cafeconnect/components/cancel_button.dart';
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
            MyCancelButton(onTap: () {}, text: "Cancel Order"),
            const SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
}
