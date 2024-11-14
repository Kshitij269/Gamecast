import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:game/components/my_button.dart';
import 'package:game/components/my_textfield.dart';
import 'package:game/pages/login_page.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final usernameController = TextEditingController();
  final nameController = TextEditingController();

  void registerUser() async {
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Verification email sent. Please verify your email before logging in.'),
          ),
        );
      }

      await FirebaseFirestore.instance.collection('users').doc(user!.uid).set({
        'email': emailController.text,
        'username': usernameController.text,
        'name': nameController.text,
        'uid': user.uid,
      });

      Navigator.pop(context);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context);
      if (e.code == 'weak-password') {
        weakPassword();
      } else if (e.code == 'email-already-in-use') {
        emailInUse();
      }
    } catch (e) {
      print(e);
    }
  }

  void weakPassword() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Weak Password! Please enter a stronger one.')),
    );
  }

  void emailInUse() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('This Email is already in use')),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    usernameController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212), // Dark background
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Game-Cast',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 3,
                  color: Colors.white, // Light text color
                  fontSize: 36,
                ),
              ),
              const SizedBox(height: 30),
              const Icon(
                Icons.sports_cricket,
                size: 120,
                color: Color(0xFFFF6600), // Accent color for icon
              ),
              const SizedBox(height: 50),
              Text(
                'Create New User',
                style: TextStyle(
                  color: Colors.white70, // Light grey text
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),
              MyTextField(
                controller: usernameController,
                hintText: 'Username',
                obscureText: false,
                backgroundColor:
                    const Color(0xFF1E1E1E), // Dark input background
                hintColor: Colors.white54, // Hint text color
                textColor: Colors.white, // Text color
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: nameController,
                hintText: 'Full Name',
                obscureText: false,
                backgroundColor: const Color(0xFF1E1E1E),
                hintColor: Colors.white54,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: emailController,
                hintText: 'Email',
                obscureText: false,
                backgroundColor: const Color(0xFF1E1E1E),
                hintColor: Colors.white54,
                textColor: Colors.white,
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: passwordController,
                hintText: 'Password',
                obscureText: true,
                backgroundColor: const Color(0xFF1E1E1E),
                hintColor: Colors.white54,
                textColor: Colors.white,
              ),
              const SizedBox(height: 25),
              MyButton(
                onTap: registerUser,
                text: "Register User",
                backgroundColor: const Color(0xFFFF6600), // Button color
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already a member?',
                    style: TextStyle(color: Colors.white70), // Light grey text
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: const Text(
                      'Login now',
                      style: TextStyle(
                        color: Color(0xFF6256CA), // Accent color for link
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
