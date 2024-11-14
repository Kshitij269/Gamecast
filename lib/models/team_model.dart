import 'player_model.dart';

class Team {
  final String teamName;
  final List<Player> players;

  Team({required this.teamName, required this.players});

  Map<String, dynamic> toMap() {
    return {
      'teamName': teamName,
      'players': players.map((player) => player.toMap()).toList(),
    };
  }

  factory Team.fromMap(Map<String, dynamic> map) {
    return Team(
      teamName: map['teamName'] ?? '',
      players: (map['players'] as List<dynamic>)
          .map((playerMap) => Player.fromMap(playerMap as Map<String, dynamic>))
          .toList(),
    );
  }
}
