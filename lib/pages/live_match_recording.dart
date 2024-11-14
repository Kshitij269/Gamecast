import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:game/components/event_card.dart';
import 'package:game/components/event_form.dart';
import 'package:game/models/event_model.dart';
import 'package:game/models/match_model.dart';
import 'package:game/components/base_scaffold.dart';
import 'package:game/models/player_model.dart';
import 'package:game/models/team_model.dart';
import 'add_players_page.dart';

class LiveMatchRecordingPage extends StatefulWidget {
  const LiveMatchRecordingPage({super.key});

  @override
  _LiveMatchRecordingPageState createState() => _LiveMatchRecordingPageState();
}

class _LiveMatchRecordingPageState extends State<LiveMatchRecordingPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final _formKey = GlobalKey<FormState>();
  String? _homeTeam;
  String? _awayTeam;
  DateTime? _matchDateTime;
  bool _isRecording = false;
  String? _matchId;

  List<Player> _homeTeamPlayers = [];
  List<Player> _awayTeamPlayers = [];

  Future<void> _startNewMatch() async {
  if (_homeTeam == null || _awayTeam == null) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Teams must be selected")),
    );
    return;
  }

  final homeTeam = Team(
    teamName: _homeTeam!,
    players: _homeTeamPlayers,
  );

  final awayTeam = Team(
    teamName: _awayTeam!,
    players: _awayTeamPlayers,
  );

  final matchDoc = await _firestore.collection('matches').add({
    'home': homeTeam.toMap(),
    'away': awayTeam.toMap(),
    'matchDateTime': _matchDateTime?.toIso8601String(),
    'events': [],  // empty list for events initially
  });

  _matchId = matchDoc.id;
}

  Future<void> _addEvent(MatchEvent event) async {
    if (_matchId != null) {
      await _firestore.collection('matches').doc(_matchId).update({
        'events': FieldValue.arrayUnion([event.toMap()]),
      }).catchError((e) {
        // Handle error if event update fails
        print("Error adding event: $e");
      });
    }
  }

  void _showAddEventDialog() {
    final match = Match(
      id: _matchId!,
      homeTeam: _homeTeam!,
      awayTeam: _awayTeam!,
      matchDateTime: _matchDateTime!,
      events: [],
    );

    showDialog(
      context: context,
      builder: (context) => EventForm(
        match: match,
        onSave: _addEvent,
      ),
    );
  }

  void _startRecording() async {
    if (_formKey.currentState!.validate() &&
        _homeTeamPlayers.length >= 10 &&
        _awayTeamPlayers.length >= 10) {
      _formKey.currentState!.save();
      await _startNewMatch();
      setState(() {
        _isRecording = true;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Each team must have at least 10 players")),
      );
    }
  }

  Future<void> _selectDate() async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: _matchDateTime ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (selectedDate != null && selectedDate != _matchDateTime) {
      setState(() {
        _matchDateTime = selectedDate;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? selectedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_matchDateTime ?? DateTime.now()),
    );

    if (selectedTime != null) {
      final DateTime newDateTime = DateTime(
        _matchDateTime?.year ?? DateTime.now().year,
        _matchDateTime?.month ?? DateTime.now().month,
        _matchDateTime?.day ?? DateTime.now().day,
        selectedTime.hour,
        selectedTime.minute,
      );

      setState(() {
        _matchDateTime = newDateTime;
      });
    }
  }

  Future<void> _addPlayersPage(List<Player> teamPlayers, String teamType) async {
    final updatedPlayers = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddPlayersPage(
          teamName: teamType,
          players: List<Player>.from(teamPlayers),
        ),
      ),
    ) as List<Player>?;

    if (updatedPlayers != null) {
      setState(() {
        if (teamType == "Home") {
          _homeTeamPlayers = updatedPlayers;
        } else {
          _awayTeamPlayers = updatedPlayers;
        }
      });
    }
  }

  Widget _buildInitialSetupForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(labelText: 'Home Team Name'),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter the home team name'
                : null,
            onSaved: (value) => _homeTeam = value,
          ),
          TextFormField(
            decoration: const InputDecoration(labelText: 'Away Team Name'),
            validator: (value) => value == null || value.isEmpty
                ? 'Please enter the away team name'
                : null,
            onSaved: (value) => _awayTeam = value,
          ),
          Row(
            children: [
              Text(_matchDateTime == null
                  ? 'Select Date and Time'
                  : '${_matchDateTime!.toLocal()}'),
              IconButton(
                icon: const Icon(Icons.calendar_today),
                onPressed: _selectDate,
              ),
              IconButton(
                icon: const Icon(Icons.access_time),
                onPressed: _selectTime,
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _addPlayersPage(_homeTeamPlayers, "Home"),
            child: const Text("Add Home Team Players"),
          ),
          ElevatedButton(
            onPressed: () => _addPlayersPage(_awayTeamPlayers, "Away"),
            child: const Text("Add Away Team Players"),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _startRecording,
            child: const Text("Start Recording"),
          ),
        ],
      ),
    );
  }

  Widget _buildEventList() {
    return StreamBuilder<DocumentSnapshot>(  
      stream: _firestore.collection('matches').doc(_matchId).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return const Center(child: Text("Error loading events"));
        }

        if (!snapshot.hasData || snapshot.data!.data() == null) {
          return const Center(child: Text("No events recorded yet."));
        }

        final matchData = snapshot.data!.data() as Map<String, dynamic>;
        final events = (matchData['events'] as List<dynamic>?)
                ?.map((e) => MatchEvent.fromMap(e as Map<String, dynamic>))
                .toList() ?? [];

        return Expanded(
          child: events.isEmpty
              ? const Center(child: Text("No events recorded yet."))
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    final event = events[index];
                    return EventCard(event: event);
                  },
                ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return BaseScaffold(
      title: "Live Match Recording",
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _isRecording ? _buildEventList() : _buildInitialSetupForm(),
      ),
      floatingActionButton: _isRecording
          ? FloatingActionButton(
              onPressed: _showAddEventDialog,
              child: const Icon(Icons.add),
            )
          : null,
    );
  }
}
