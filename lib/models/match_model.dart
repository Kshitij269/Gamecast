import 'package:game/models/event_model.dart';

class Match {
  final String id;
  final String homeTeam;
  final String awayTeam;
  final DateTime matchDateTime;
  final List<MatchEvent> events;

  Match({
    required this.id,
    required this.homeTeam,
    required this.awayTeam,
    required this.matchDateTime,
    required this.events,
  });

  // Parsing from Firestore document
  factory Match.fromMap(Map<String, dynamic> data, {required String id}) {
    return Match(
      id: id,
      homeTeam: data['home'] ?? 'Unknown Home Team',
      awayTeam: data['away'] ?? 'Unknown Away Team',
      matchDateTime: DateTime.parse(data['matchDateTime']),
      events: (data['events'] as List?)
              ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  // Convert to map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'home': homeTeam,
      'away': awayTeam,
      'matchDateTime': matchDateTime.toIso8601String(),
      'events': events.map((e) => e.toMap()).toList(),
    };
  }
}
