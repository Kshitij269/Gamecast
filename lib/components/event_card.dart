import 'package:flutter/material.dart';
import 'package:game/models/event_model.dart';

class EventCard extends StatelessWidget {
  final MatchEvent event;

  const EventCard({required this.event, Key? key}) : super(key: key);

  IconData _getEventIcon() {
    // Customize icons based on event type
    switch (event.eventType) {
      case 'Goal':
        return Icons.sports_soccer;
      case 'Yellow Card':
        return Icons.warning;
      case 'Red Card':
        return Icons.block;
      case 'Substitution':
        return Icons.swap_horiz;
      default:
        return Icons.event; // Default icon
    }
  }

  Color _getEventColor() {
    // Customize colors based on event type
    switch (event.eventType) {
      case 'Goal':
        return Colors.green;
      case 'Yellow Card':
        return Colors.yellow;
      case 'Red Card':
        return Colors.red;
      case 'Substitution':
        return Colors.blue;
      default:
        return Colors.grey; // Default color
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      elevation: 4.0, // Added elevation for a raised card effect
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: _getEventColor(),
            child: Icon(_getEventIcon(), color: Colors.white),
          ),
          title: Text(
            event.eventType,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16.0, // Adjust font size
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Time: ${event.time} min',
                style: TextStyle(fontSize: 14.0),
              ),
              SizedBox(height: 4.0),
              Text(
                'Team: ${event.team}',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14.0, // Adjust font size
                ),
              ),
              if (event.players != null && event.players!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4.0),
                  child: Text(
                    'Players: ${event.players!.join(", ")}',
                    style: TextStyle(fontSize: 14.0),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
