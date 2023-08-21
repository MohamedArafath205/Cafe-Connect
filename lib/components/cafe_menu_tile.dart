import 'package:flutter/material.dart';

class CafeMenuTile extends StatelessWidget {
  final String itemName;
  final String itemPrice;
  final String imagePath;
  final color;

  const CafeMenuTile({
    super.key,
    required this.itemName,
    required this.itemPrice,
    required this.imagePath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Container(
        decoration: BoxDecoration(
          color: color[100],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            // image
            Image.asset(
              imagePath,
              height: 100,
            ),

            // item name
            Text(itemName),

            // price + button
          ],
        ),
      ),
    );
  }
}
