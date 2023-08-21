import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../components/cafe_menu_tile.dart';
import '../model/cart_model.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(backgroundColor: Colors.grey[800], actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
        ]),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 48),
              // greetings
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Hello there,"),
              ),

              const SizedBox(height: 4),
              // Let's order something
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Enjoy your hassle free order experience",
                  style: GoogleFonts.notoSerif(
                    fontSize: 36,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // divider
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Divider(),
              ),
              // Menu
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Today's menu", style: TextStyle(fontSize: 16)),
              ),

              Expanded(
                child: Consumer<CartModel>(builder: (context, value, child) {
                  return GridView.builder(
                      itemCount: value.shopItems.length,
                      padding: EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2),
                      itemBuilder: (context, index) {
                        return CafeMenuTile(
                          itemName: value.shopItems[index][0],
                          itemPrice: value.shopItems[index][1],
                          imagePath: value.shopItems[index][2],
                          color: value.shopItems[index][3],
                        );
                      });
                }),
              )
            ],
          ),
        ));
  }
}
