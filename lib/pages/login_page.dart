import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // For Firestore queries
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart'; // For Google Sign-In
import 'package:game/components/my_button.dart';
import 'package:game/components/my_textfield.dart';
import 'package:game/pages/forgotpasswordpage.dart';
import 'package:game/pages/home_page.dart';
import 'package:game/pages/registerpage.dart';
import 'package:game/pages/simple_captha.dart'; // Import your SimpleCaptcha widget

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailOrUsernameController =
      TextEditingController(); // Updated to handle both email and username
  final passwordController = TextEditingController();

  bool captchaVerified = false;

  void onCaptchaVerify(String captchaText) {
    setState(() {
      captchaVerified = true;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('CAPTCHA verified! You can now log in.')),
    );
  }

  // Sign in with Google method
  Future<void> signInWithGoogle() async {
    // Show loading indicator
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      print("Starting Google sign-in process...");

      // Trigger the Google Authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      if (googleUser == null) {
        print("Google sign-in canceled by user.");
        Navigator.pop(context); // Close the loading dialog
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print("Obtained Google Auth details.");

      // Create a new credential
      final OAuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print("Attempting to sign in with Google credential...");

      // Sign in to Firebase
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      print("Google sign-in successful.");

      Navigator.pop(context); // Close the loading dialog
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    } catch (e) {
      print("Error during Google sign-in: ${e.toString()}");
      Navigator.pop(context); // Close the loading dialog
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  // Regular sign in method (Unchanged)
  void signUserIn() async {
    if (!captchaVerified) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Please verify the CAPTCHA before logging in.')),
      );
      return;
    }

    // Show loading circle
    showDialog(
      context: context,
      builder: (context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      String email = emailOrUsernameController.text;

      // Check if input is a valid email
      bool isEmail = RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(email);

      // If it's not an email, assume it's a username and fetch the associated email
      if (!isEmail) {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('username', isEqualTo: email)
            .limit(1)
            .get();

        if (userSnapshot.docs.isEmpty) {
          throw FirebaseAuthException(
            code: 'user-not-found',
            message: 'No user found with this username.',
          );
        }

        email = userSnapshot.docs.first
            .get('email'); // Retrieve email from the query result
      }

      // Proceed with Firebase authentication using the email (from input or Firestore)
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: passwordController.text,
      );

      User? user = userCredential.user;

      if (user != null && !user.emailVerified) {
        Navigator.pop(context); // Close the loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please verify your email before logging in.'),
          ),
        );
        await user.sendEmailVerification();
      } else {
        Navigator.pop(context); // Close the loading dialog
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      }
    } on FirebaseAuthException catch (e) {
      Navigator.pop(context); // Close the loading dialog
      if (e.code == 'wrong-password') {
        wrongPasswordMessage();
      } else if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text('User not found. Please check your credentials.')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.message}')),
        );
      }
    }
  }

  void forgotPassword() async {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const ForgotPasswordPage()),
    );
  }

  void wrongPasswordMessage() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Invalid Credentials')),
    );
  }

  @override
  void dispose() {
    emailOrUsernameController.dispose();
    passwordController.dispose();
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
              const Text(
                'Welcome back',
                style: TextStyle(
                  color: Colors.white70, // Light grey text
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 25),

              // Email or Username text field
              MyTextField(
                controller: emailOrUsernameController,
                hintText: 'Email',
                obscureText: false,
                backgroundColor:
                    const Color(0xFF1E1E1E), // Dark input background
                hintColor: Colors.white54, // Hint text color
                textColor: Colors.white, // Text color
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
              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: forgotPassword,
                      child: const Text(
                        'Forgot Password?',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),

              // Simple CAPTCHA widget
              SimpleCaptcha(onVerify: onCaptchaVerify),

              const SizedBox(height: 10),

              // Sign in button
              MyButton(
                onTap: signUserIn,
                text: "Login User",
                backgroundColor: const Color(0xFFFF6600), // Button color
                textColor: Colors.white,
              ),
              const SizedBox(height: 20),

              // Google Sign-In button
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: signInWithGoogle,
                  child: const Row(children: [
                    Icon(Icons.login_rounded),
                    SizedBox(width: 10),
                    Text("Login with Google")
                  ]),
                ),
              ),
              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Not a member?',
                    style: TextStyle(color: Colors.white70), // Light grey text
                  ),
                  const SizedBox(width: 4),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      'Register now',
                      style: TextStyle(
                        color: Colors.blue, // Accent color for link
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
