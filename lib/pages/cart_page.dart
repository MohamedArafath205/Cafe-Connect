import 'package:cafeconnect/pages/token_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import '../model/cart_model.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'navbar.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  final _razorpay = Razorpay();

  @override
  void initState() {
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    super.initState();
  }

  // getting user email from firebase
  Future<String> getCurrentUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.email ?? '';
    } else {
      return '';
    }
  }

  // getting the current userid from firebase
  String getCurrentUserUID() {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      return ''; // User is not signed in
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    DocumentReference orderCountRef =
        FirebaseFirestore.instance.collection('OrderCount').doc('count');
    var data = (await orderCountRef.get()).data() as Map<String, dynamic>?;
    int orderCount = data?['count'] ?? 0;
    await orderCountRef.set({'count': orderCount + 1});

    var cartModel = Provider.of<CartModel>(context, listen: false);

    Map<String, dynamic> cartItemsMap = {};

    for (var cartItem in cartModel.cartItems) {
      cartItemsMap[cartItem[0]] =
          cartItem[1]; // Use item name as key, and price as value
    }

    DocumentReference orderDocRef = FirebaseFirestore.instance
        .collection('TokenNumbers')
        .doc(orderCount.toString());

    await orderDocRef.set(
        cartItemsMap, SetOptions(merge: true)); // Merge with existing data

    String itemNames =
        cartModel.cartItems.map((cartItem) => cartItem[0]).join(', ');

    CartModel().clearCart();
    navigateToTokenPage(orderCount, itemNames);
  }

  void navigateToTokenPage(orderCount, itemNames) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TokenPage(
                  orderNumber: orderCount,
                  itemNames: itemNames,
                )));
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    print("Payment Error");
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    // Do something when an external wallet is selected
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      bottomNavigationBar: const BottomNavbar(pageindex: 1),
      body: Consumer<CartModel>(builder: (context, value, child) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Padding(
                padding: const EdgeInsets.only(top: 60),
                child: Text(
                  "My Cart",
                  style: GoogleFonts.notoSerif(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[300],
                  ),
                ),
              ),
            ),

            // list of cart items
            Expanded(
                child: ListView.builder(
                    itemCount: value.cartItems.length,
                    padding: const EdgeInsets.all(12),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[800],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: ListTile(
                            leading: Image.asset(value.cartItems[index][2],
                                height: 36),
                            title: Text(
                              value.cartItems[index][0],
                              style: TextStyle(color: Colors.grey[300]),
                            ),
                            subtitle: Text("₹ " + value.cartItems[index][1],
                                style: TextStyle(color: Colors.grey[300])),
                            trailing: IconButton(
                              icon: Icon(
                                Icons.cancel,
                                color: Colors.grey[300],
                              ),
                              onPressed: () =>
                                  Provider.of<CartModel>(context, listen: false)
                                      .removeItemFromCart(index),
                            ),
                          ),
                        ),
                      );
                    })),

            // total price
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8)),
                padding: const EdgeInsets.all(24),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(
                            "Total Price",
                            style: TextStyle(color: Colors.green[100]),
                          ),
                          const SizedBox(height: 4),
                          Text("₹ " + value.calculateTotal(),
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              )),
                        ],
                      ),

                      // Pay Now button
                      GestureDetector(
                        onTap: () {
                          var options = {
                            'key': 'rzp_test_1hIbacHpTw8wwc',
                            'amount': 100,
                            'name': 'Cafe Connect',
                            'description': 'Connect with cafe connect',
                            'timeout': 300,
                            'prefill': {
                              'contact': '9123456789',
                              'email': 'gaurav.kumar@example.com'
                            }
                          };
                          _razorpay.open(options);
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.green.shade100),
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: const Row(
                            children: [
                              Text(
                                "Pay Now",
                                style: TextStyle(color: Colors.white),
                              ),
                              Icon(
                                Icons.arrow_forward_ios,
                                size: 16,
                                color: Colors.white,
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
              ),
            ),
          ],
        );
      }),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }
}
