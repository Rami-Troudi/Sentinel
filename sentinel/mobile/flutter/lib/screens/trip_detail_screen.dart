import 'package:flutter/material.dart';
import '../models/trip.dart';

class TripDetailScreen extends StatelessWidget {
  static const routeName = '/trip-detail';

  const TripDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Trip trip = ModalRoute.of(context)?.settings.arguments as Trip;
    final List<Map<String, String>> events = [
      {'time': '00:05:12', 'type': 'Freinage brusque', 'location': 'Centre-ville'},
      {'time': '00:12:34', 'type': 'Virage serré', 'location': 'Sortie de rond-point'},
      {'time': '00:20:01', 'type': 'Accélération forte', 'location': 'Entrée autoroute'},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Détail du trajet')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trajet du ${trip.date.day}/${trip.date.month}/${trip.date.year}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Durée : ${trip.duration}'),
            Text('Distance : ${trip.distance.toStringAsFixed(1)} km'),
            if (trip.riskScore != null) Text('Score du trajet : ${trip.riskScore!.toInt()}'),
            const SizedBox(height: 16),
            const Text('Événements détectés', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            ...events.map((e) => ListTile(
                  leading: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                  title: Text(e['type']!),
                  subtitle: Text('Temps : ${e['time']}, Zone : ${e['location']}'),
                )),
            const SizedBox(height: 16),
            const Text('Zone la plus risquée', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Centre-ville, autour du carrefour X (exemple – données IA backend).'),
          ],
        ),
      ),
    );
  }
}
