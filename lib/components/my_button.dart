import 'package:flutter/material.dart';

class MyButton extends StatelessWidget {
  final Function()? onTap;
  final String text;
  final Color backgroundColor; // New property for background color
  final Color textColor; // New property for text color
  final double borderRadius; // New property for border radius

  MyButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor = Colors.black, // Default color
    this.textColor = Colors.white, // Default color
    this.borderRadius = 8.0, // Default radius
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 25),
        decoration: BoxDecoration(
          color: backgroundColor, // Use the provided background color
          borderRadius: BorderRadius.circular(
              borderRadius), // Use the provided border radius
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              color: textColor, // Use the provided text color
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
