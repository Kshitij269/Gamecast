import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/components/base_scaffold.dart';
import 'package:game/models/match_model.dart';
import 'package:game/components/match_card.dart';
import 'package:game/pages/match_event_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Match>> _fetchMatches() async {
    try {
      final snapshot = await _firestore.collection('matches').get();
      return snapshot.docs
          .map((doc) =>
              Match.fromMap(doc.data() as Map<String, dynamic>, id: doc.id))
          .toList();
    } catch (e) {
      print("Error fetching matches: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Matches",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FutureBuilder<List<Match>>(
          future: _fetchMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error loading matches"));
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(child: Text("No matches available"));
            }

            final matches = snapshot.data!;

            return ListView.builder(
              itemCount: matches.length,
              itemBuilder: (context, index) {
                final match = matches[index];

                return MatchCard(
                  match: match,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            MatchEventsPage(matchId: match.id),
                      ),
                    );
                  },
                );
              },
            );
          },
        ),
      ),
    );
  }
}
