import 'package:flutter/material.dart';
import 'package:game/models/match_model.dart'; // Import your Match model

class MatchCard extends StatelessWidget {
  final Match match;
  final VoidCallback onTap;

  const MatchCard({
    super.key,
    required this.match,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4.0,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16.0),
        title: Text('${match.homeTeam} vs ${match.awayTeam}'),
        subtitle: Text('Match Date: ${match.matchDateTime}'),
        onTap: onTap,
      ),
    );
  }
}
