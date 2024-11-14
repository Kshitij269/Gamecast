class MatchEvent {
  final String eventType;  // For example: 'Goal', 'Yellow Card', etc.
  final int time;  // Time of the event in minutes.
  final String team;  // The team that the event is associated with.
  final List<String>? players;  // List of players involved in the event, nullable.

  MatchEvent({
    required this.eventType,
    required this.time,
    required this.team,
    this.players,
  });

  // Convert from Firestore Map to MatchEvent
  factory MatchEvent.fromMap(Map<String, dynamic> map) {
    return MatchEvent(
      eventType: map['eventType'] as String,
      time: map['time'] as int,
      team: map['team'] as String,
      players: map['players'] != null
          ? List<String>.from(map['players'])
          : null,
    );
  }

  // Convert to Firestore Map
  Map<String, dynamic> toMap() {
    return {
      'eventType': eventType,
      'time': time,
      'team': team,
      'players': players,
    };
  }
}
