import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list the items for sale
  final List _shopItems = [
    // [itemName, itemPrice, imagePath, color]
    ["Veg Parotta", "₹ 40.00", "lib/images/veg-noodle.png", Colors.green],
    ["Veg Noodle", "₹ 60.00", "lib/images/veg-noodle.png", Colors.green],
    ["Veg Fried rice", "₹ 60.00", "lib/images/veg-noodle.png", Colors.green],
    ["Briyani", "₹ 100.00", "lib/images/veg-noodle.png", Colors.red],
  ];

  get shopItems => _shopItems;
}
