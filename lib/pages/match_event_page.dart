import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/components/base_scaffold.dart';
import 'package:game/models/event_model.dart';
import 'package:game/components/event_list.dart';

class MatchEventsPage extends StatelessWidget {
  final String matchId;

  const MatchEventsPage({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Match Events",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection('matches')
              .doc(matchId)
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return const Center(child: Text("Error loading events"));
            }

            if (!snapshot.hasData || !snapshot.data!.exists) {
              return const Center(child: Text("No events recorded yet."));
            }

            final matchData = snapshot.data!.data() as Map<String, dynamic>;
            final eventsData = matchData['events'] as List<dynamic>?;

            if (eventsData == null || eventsData.isEmpty) {
              return const Center(child: Text("No events available for this match."));
            }

            final events = eventsData
                .map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
                .toList();

            return EventList(events: events);
          },
        ),
      ),
    );
  }
}
