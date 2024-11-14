import 'package:flutter/material.dart';
import 'package:game/models/event_model.dart'; // Import your event model
import 'package:game/components/event_card.dart'; // Assuming you have an EventCard widget

class EventList extends StatelessWidget {
  final List<MatchEvent> events;

  const EventList({
    super.key,
    required this.events,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return EventCard(
            event: event); // Use the EventCard to display individual events
      },
    );
  }
}
