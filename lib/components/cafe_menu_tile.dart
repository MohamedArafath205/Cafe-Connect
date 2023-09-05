import 'package:flutter/material.dart';

class CafeMenuTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final bool isVeg;
  final void Function()? onPressed;

  CafeMenuTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.onPressed,
    required this.isVeg,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // veg / non-veg indicator
            // Align(
            //   alignment: Alignment.topRight,
            //   child: Container(
            //     width: 24,
            //     height: 24,
            //     decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       color: isVeg ? Colors.green : Colors.red,
            //     ),
            //   ),
            // ),

            Align(
              alignment: Alignment.topRight,
              child: Container(
                width: 25,
                height: 25,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  border: Border.all(
                    color: isVeg ? Colors.green : Colors.red,
                    width: 2,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isVeg ? Colors.green : Colors.red,
                    ),
                  ),
                ),
              ),
            ),

            // image
            Image.asset(
              imagePath,
              height: 100,
            ),

            // item name
            const SizedBox(
              height: 5,
            ),
            Text(itemName, style: const TextStyle(color: Colors.white)),

            // price + button
            MaterialButton(
              onPressed: onPressed,
              color: Colors.green[400],
              child: Text(
                "₹ " + itemPrice,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
