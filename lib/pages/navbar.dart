  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:flutter/cupertino.dart';
  import 'package:flutter/material.dart';

  import 'cart_page.dart';
  import 'home_page.dart';

  class BottomNavigationPage extends StatefulWidget {
    @override
    void signUserOut(BuildContext context) {
      showDialog(
          context: context,
          builder: (BuildContext) {
            return CupertinoAlertDialog(
              title: const Text("Logout ?"),
              content: const Text("Are you sure you want to logout?"),
              actions: [
                CupertinoDialogAction(
                    child: Text("Logout"),
                    onPressed: () {
                      FirebaseAuth.instance.signOut();
                      Navigator.pop(context);
                    }),
                CupertinoDialogAction(
                    child: Text("Cancel"),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
              ],
            );
          });
    }

    _BottomNavigationPageState createState() => _BottomNavigationPageState();
  }

  class _BottomNavigationPageState extends State<BottomNavigationPage> {
    int _currentIndex = 0;
    final List<Widget> _pages = [
      HomePage(),
      CartPage(),
      // Add other pages here
    ];

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        body: PageView(
          controller: PageController(
            initialPage: _currentIndex,
          ),
          children: _pages,
          onPageChanged: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.shopping_cart),
              label: 'Cart',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.logout),
              label: 'Logout',
            ),
          ],
        ),
      );
    }
  }
