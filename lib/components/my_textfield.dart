import 'package:flutter/material.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final Color backgroundColor;
  final Color hintColor;
  final Color textColor;

  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
    this.backgroundColor = const Color(0xFF1E1E1E), // Default dark background
    this.hintColor = Colors.white54, // Default hint color
    this.textColor = Colors.white, // Default text color
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25.0),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: TextStyle(color: textColor), // Set the text color
        decoration: InputDecoration(
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.grey.shade400), // Border color for enabled state
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
                color: Colors.white), // Border color for focused state
          ),
          fillColor: backgroundColor, // Background color
          filled: true,
          hintText: hintText,
          hintStyle: TextStyle(color: hintColor), // Hint text color
        ),
      ),
    );
  }
}
