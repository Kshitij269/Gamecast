import 'package:flutter/material.dart';
import 'package:game/models/event_model.dart';
import 'package:game/models/match_model.dart';

class EventForm extends StatefulWidget {
  final Function(MatchEvent) onSave;
  final Match match; // Use the Match model instead of individual teams

  const EventForm({
    required this.onSave,
    required this.match,
    Key? key,
  }) : super(key: key);

  @override
  _EventFormState createState() => _EventFormState();
}

class _EventFormState extends State<EventForm> {
  final _formKey = GlobalKey<FormState>();
  String? _eventType;
  String? _selectedTeam;
  int? _time;
  List<String>? _players; // List of player names with kit numbers
  final Map<String, int> _eventTypes = {
    'Goal': 1,
    'Foul': 0,
    'Yellow Card': 1,
    'Red Card': 1,
    'Substitution': 2,
    'Goal Kick': 0,
    'Corner': 0,
    'Throw-in': 0,
  };

  @override
  void initState() {
    super.initState();
    _selectedTeam = widget.match.homeTeam; // Default to home team
    _eventType = _eventTypes.keys.first; // Default to 'Goal'
  }

  // Add event to the match
  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final event = MatchEvent(
        eventType: _eventType!,
        time: _time!,
        team: _selectedTeam!,
        players: _players,
      );
      widget.onSave(event); // Call onSave with the event to update the match
      Navigator.pop(context); // Close the form after saving
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Add Event"),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Team Selection Dropdown
            DropdownButtonFormField<String>(
              value: _selectedTeam,
              decoration: const InputDecoration(labelText: 'Select Team'),
              items: [widget.match.homeTeam, widget.match.awayTeam].map((team) {
                return DropdownMenuItem<String>(
                  value: team,
                  child: Text(team),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedTeam = value;
                });
              },
              validator: (value) =>
                  value == null ? 'Please select a team' : null,
              onSaved: (value) => _selectedTeam = value,
            ),

            // Event Type Dropdown
            DropdownButtonFormField<String>(
              value: _eventType,
              decoration: const InputDecoration(labelText: 'Event Type'),
              items: _eventTypes.keys.map((event) {
                return DropdownMenuItem<String>(
                  value: event,
                  child: Text(event),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _eventType = value;
                  _players = null; // Reset players if event type changes
                });
              },
              validator: (value) =>
                  value == null ? 'Please select an event type' : null,
              onSaved: (value) => _eventType = value,
            ),

            // Time Input
            TextFormField(
              decoration: const InputDecoration(labelText: 'Time (in minutes)'),
              keyboardType: TextInputType.number,
              onSaved: (value) => _time = int.tryParse(value ?? ''),
              validator: (value) =>
                  value == null || value.isEmpty ? 'Please enter time' : null,
            ),

            // Dynamically show players field based on event type
            if (_eventTypes[_eventType] != 0) ...[
              // If players are involved
              for (int i = 1; i <= _eventTypes[_eventType]!; i++) ...[
                TextFormField(
                  decoration: InputDecoration(
                      labelText: 'Player $i (name, kit number)'),
                  onSaved: (value) {
                    if (_players == null) {
                      _players = [];
                    }
                    _players!.add(value?.trim() ?? '');
                  },
                  validator: (value) => value == null || value.isEmpty
                      ? 'Please enter player $i details'
                      : null,
                ),
              ],
            ],

            const SizedBox(height: 16),

            // Goal Kick, Corner, and Throw-in don't require player input
            if (_eventType == 'Goal Kick' ||
                _eventType == 'Corner' ||
                _eventType == 'Throw-in') ...[
              const SizedBox(height: 10),
              const Text('No player involved in this event type'),
            ],

            ElevatedButton(
              onPressed: _submitForm,
              child: const Text('Save Event'),
            ),
          ],
        ),
      ),
    );
  }
}
