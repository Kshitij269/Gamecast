import 'package:flutter/material.dart';
import 'package:game/components/base_scaffold.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void navigateToMatches(BuildContext context) {
    Navigator.pushNamed(context, '/matches');
  }

  void startLiveMatchRecording(BuildContext context) {
    Navigator.pushNamed(
        context, '/liveMatchRecording'); // Adjust the route name as needed
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Home",
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => navigateToMatches(context),
              child: const Text("View Matches"),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => startLiveMatchRecording(context),
              child: const Text("Start Live Match Recording"),
            ),
          ],
        ),
      ),
    );
  }
}
