import 'package:flutter/material.dart';

class MyCancelButton extends StatelessWidget {
  final Function()? onTap;
  final String text;

  const MyCancelButton({Key? key, required this.onTap, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(25),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.red), // Add border here
            borderRadius: BorderRadius.circular(9),
          ),
          child: const Center(
            child: Text(
              "Cancel Order",
              style: TextStyle(
                color: Colors.red, // Change text color to match border color
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
