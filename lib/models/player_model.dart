class Player {
  final String name;
  final String position;
  final int number;

  Player({required this.name, required this.position, required this.number});

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'position': position,
      'number': number,
    };
  }

  factory Player.fromMap(Map<String, dynamic> map) {
    return Player(
      name: map['name'] ?? '',
      position: map['position'] ?? '',
      number: map['number'] ?? 0,
    );
  }
}
