import 'package:flutter/material.dart';
import '../models/itinerary.dart';

class ItineraryDetailPage extends StatelessWidget {
    final ItineraryStatic itinerary;

    const ItineraryDetailPage({super.key, required this.itinerary});

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(title: Text(itinerary.title)),
            body: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children : [
                        Text("Destination: ${itinerary.destination}", style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        Text("Days: ${itinerary.days}", style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 8),
                        Text("By ${itinerary.userName}", style: Theme.of(context).textTheme.bodyMedium),
                        const SizedBox(height: 16),
                        const Text("Itinerary Contents...", style: TextStyle(color: Colors.grey)),
                    ]
                )
            )
        );
    }
}