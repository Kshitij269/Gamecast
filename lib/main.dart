import 'package:flutter/material.dart';
import 'package:game/firebase_options.dart';
import 'package:game/pages/live_match_recording.dart';
import 'package:game/pages/matches_page.dart';
import 'pages/auth_page.dart';
import 'pages/home_page.dart'; // Ensure you import the HomePage
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/auth', // Set the initial route
      routes: {
        '/home': (context) => const HomePage(), // Route for HomePage
        '/auth': (context) => const AuthPage(), // Route for AuthPage
        '/matches': (context) => const MatchesPage(), // Route for MatchesPage
        '/liveMatchRecording': (context) =>
            const LiveMatchRecordingPage(), // Route for MatchesPage
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (context) => const AuthPage()); // Fallback route
      },
    );
  }
}
