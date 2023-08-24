import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:badges/badges.dart' as badge;
import '../components/cafe_menu_tile.dart';
import '../model/cart_model.dart';
import 'cart_page.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final user = FirebaseAuth.instance.currentUser!;

  void signUserOut() {
    FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () =>
              Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CartPage();
          })),
          backgroundColor: Colors.black,
          child: badge.Badge(
            position: badge.BadgePosition.topEnd(top: -23, end: -20),
            badgeContent: Text(
              Provider.of<CartModel>(context).cartItems.length.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: Icon(Icons.shopping_cart),
            badgeStyle: const badge.BadgeStyle(
              badgeColor: Colors.blue,
            ),
            badgeAnimation: const badge.BadgeAnimation.fade(
              animationDuration: Duration(milliseconds: 500),
            ),
          ),
        ),
        appBar: AppBar(backgroundColor: Colors.grey[800], actions: [
          IconButton(onPressed: signUserOut, icon: Icon(Icons.logout))
        ]),
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              // Let's order something
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Text(
                  "Enjoy your hassle free order experience",
                  style: GoogleFonts.notoSerif(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              // Menu
              const SizedBox(height: 24),

              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24.0),
                child: Text("Today's menu", style: TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 24),

              Expanded(
                child: Consumer<CartModel>(builder: (context, value, child) {
                  return GridView.builder(
                      itemCount: value.shopItems.length,
                      padding: EdgeInsets.all(12),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 1 / 1.3,
                      ),
                      itemBuilder: (context, index) {
                        return CafeMenuTile(
                          itemName: value.shopItems[index][0],
                          itemPrice: value.shopItems[index][1],
                          imagePath: value.shopItems[index][2],
                          color: value.shopItems[index][3],
                          onPressed: () {
                            Provider.of<CartModel>(context, listen: false)
                                .addItemToCart(index);
                          },
                        );
                      });
                }),
              )
            ],
          ),
        ));
  }
}
