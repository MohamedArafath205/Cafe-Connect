import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'cart_page.dart';
import 'home_page.dart';

class BottomNavbar extends StatelessWidget {
  final int pageindex;
  const BottomNavbar({super.key, required this.pageindex});
  void signUserOut(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext) {
          return CupertinoAlertDialog(
            title: const Text("Logout ?"),
            content: const Text("Are you sure you want to logout?"),
            actions: [
              CupertinoDialogAction(
                  child: const Text(
                    "Logout",
                    style: TextStyle(color: Colors.red),
                  ),
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    Navigator.pop(context);
                  }),
              CupertinoDialogAction(
                  child: const Text("Cancel"),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return GNav(
      backgroundColor: Colors.black,
      color: Colors.white,
      activeColor: Colors.white,
      tabBackgroundColor: Colors.grey.shade800,
      padding: EdgeInsets.all(16),
      gap: 8,
      selectedIndex: pageindex,
      onTabChange: (index) {
        if (index == 2) {
          signUserOut(context);
        } else if (index == 1) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return CartPage();
          }));
        } else if (index == 0) {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return HomePage();
          }));
        }
      },
      tabs: const [
        GButton(
          icon: Icons.home,
          text: 'Home',
        ),
        GButton(
          icon: Icons.shopping_cart,
          text: 'Cart',
        ),
        GButton(
          icon: Icons.logout,
          text: 'Logout',
        ),
      ],
    );
  }
}
