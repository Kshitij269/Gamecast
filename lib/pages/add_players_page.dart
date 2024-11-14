import 'package:flutter/material.dart';
import 'package:game/models/player_model.dart';

class AddPlayersPage extends StatefulWidget {
  final String teamName;
  final List<Player> players;

  const AddPlayersPage({super.key, required this.teamName, required this.players});

  @override
  _AddPlayersPageState createState() => _AddPlayersPageState();
}

class _AddPlayersPageState extends State<AddPlayersPage> {
  List<TextEditingController> nameControllers = [];
  List<TextEditingController> numberControllers = [];

  @override
  void initState() {
    super.initState();
    // Initialize controllers for up to 16 players
    for (int i = 0; i < 16; i++) {
      nameControllers.add(TextEditingController());
      numberControllers.add(TextEditingController());
    }

    // Load existing players' data into controllers
    for (int i = 0; i < widget.players.length; i++) {
      nameControllers[i].text = widget.players[i].name;
      numberControllers[i].text = widget.players[i].number.toString();
    }
  }

  @override
  void dispose() {
    // Dispose controllers
    for (var controller in nameControllers) {
      controller.dispose();
    }
    for (var controller in numberControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _savePlayers() {
    List<Player> updatedPlayers = [];

    for (int i = 0; i < 16; i++) {
      final name = nameControllers[i].text;
      final numberText = numberControllers[i].text;
      if (name.isNotEmpty && numberText.isNotEmpty) {
        final number = int.tryParse(numberText) ?? 0;
        updatedPlayers.add(Player(name: name, number: number, position: 'Position $i'));
      }
    }

    Navigator.pop(context, updatedPlayers);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${widget.teamName} Players')),
      body: ListView.builder(
        itemCount: 16,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Text('Player ${index + 1}'),
            title: TextField(
              controller: nameControllers[index],
              decoration: InputDecoration(labelText: 'Name'),
            ),
            subtitle: TextField(
              controller: numberControllers[index],
              decoration: InputDecoration(labelText: 'Jersey Number'),
              keyboardType: TextInputType.number,
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _savePlayers,
        child: const Icon(Icons.save),
      ),
    );
  }
}
