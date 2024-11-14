import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:game/components/main_drawer.dart';

class BaseScaffold extends StatelessWidget {
  final Widget child;
  final String title;
  final Widget? floatingActionButton;

  const BaseScaffold({
    required this.child,
    this.title = "game",
    this.floatingActionButton,
  });

  void logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, '/auth');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      endDrawer: MainDrawer(
          onLogout: () =>
              logout(context)), // Use endDrawer for right-side drawer
      body: child,
      floatingActionButton: floatingActionButton,
    );
  }
}
