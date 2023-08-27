import 'package:flutter/material.dart';

class CartModel extends ChangeNotifier {
  // list the items for sale
  final List _shopItems = [
    // [itemName, itemPrice, imagePath, color]
    ["Veg Parotta", "40.00", "lib/images/veg-noodle.png", Colors.green],
    ["Veg Noodle", "60.00", "lib/images/veg-noodle.png", Colors.green],
    ["Veg Fried rice", "60.00", "lib/images/veg-noodle.png", Colors.green],
    ["Briyani", "100.00", "lib/images/veg-noodle.png", Colors.red],
  ];

  List _cartItems = [];

  get cartItems => _cartItems;

  get shopItems => _shopItems;

  // adding Items to the cart
  void addItemToCart(int index) {
    _cartItems.add(_shopItems[index]);
    notifyListeners();
  }

  // removing Items to the cart
  void removeItemFromCart(int index) {
    _cartItems.removeAt(index);
    notifyListeners();
  }

  // removing the whole cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  // Calculating the total price
  String calculateTotal() {
    double totalPrice = 0;
    for (int i = 0; i < _cartItems.length; i++) {
      totalPrice += double.parse(_cartItems[i][1]);
    }
    return totalPrice.toStringAsFixed(2);
  }
}
