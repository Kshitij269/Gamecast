import 'dart:math';
import 'package:flutter/material.dart';
import 'package:game/components/my_textfield.dart';

class SimpleCaptcha extends StatefulWidget {
  final Function(String) onVerify;

  const SimpleCaptcha({super.key, required this.onVerify});

  @override
  _SimpleCaptchaState createState() => _SimpleCaptchaState();
}

class _SimpleCaptchaState extends State<SimpleCaptcha> {
  String captchaText = '';
  final TextEditingController _captchaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    generateCaptcha();
  }

  void generateCaptcha() {
    final random = Random();
    const letters =
        'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
    captchaText =
        List.generate(6, (index) => letters[random.nextInt(letters.length)])
            .join('');
    setState(() {});
  }

  void verifyCaptcha() {
    if (_captchaController.text == captchaText) {
      widget.onVerify(captchaText); // Call the onVerify function
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('CAPTCHA verification failed. Please try again.')),
      );
      generateCaptcha(); // Regenerate CAPTCHA if verification fails
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Updated CAPTCHA display area
        Container(
          margin: const EdgeInsets.only(left: 25.0, right: 10),
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E), // Background color
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                captchaText,
                style: const TextStyle(
                  fontSize: 24, // Increased font size
                  fontWeight: FontWeight.bold,
                  color: Colors.white, // Light text color for contrast
                ),
              ),
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: generateCaptcha,
                color: Colors.blue,
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        MyTextField(
          controller: _captchaController,
          hintText: 'Captcha',
          obscureText: false,
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: verifyCaptcha,
            style: ElevatedButton.styleFrom(
              textStyle:
                  const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 25),
            ),
            child: const Text('Verify'),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _captchaController.dispose();
    super.dispose();
  }
}
