import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MainDrawer extends StatelessWidget {
  final Function onLogout;

  const MainDrawer({required this.onLogout});

  void _navigate(BuildContext context, String route) {
    Navigator.pop(context); // Close the drawer
    Navigator.pushNamed(context, route);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: Theme.of(context).primaryColor,
            ),
            child: const Text(
              'game',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () => _navigate(context, '/home'),
          ),
          ListTile(
            leading: const Icon(Icons.sports_soccer),
            title: const Text('Matches'),
            onTap: () => _navigate(context, '/matches'),
          ),
          ListTile(
            leading: const Icon(Icons.event),
            title: const Text('Live Match Recording'),
            onTap: () => _navigate(context, '/liveMatchRecording'),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Logout'),
            onTap: () {
              onLogout();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}
