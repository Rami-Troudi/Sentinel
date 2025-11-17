import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/trip.dart';

class TripsScreen extends StatefulWidget {
  static const routeName = '/trips';
  const TripsScreen({super.key});

  @override
  _TripsScreenState createState() => _TripsScreenState();
}

class _TripsScreenState extends State<TripsScreen> {
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (user != null) {
      dataProvider.loadTrips(user.id).then((_) {
        setState(() => _loading = false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final trips = Provider.of<DataProvider>(context).trips;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: trips.isEmpty
          ? const Center(child: Text('Aucun trajet pour le moment.'))
          : ListView.builder(
              itemCount: trips.length,
              itemBuilder: (ctx, index) {
                final Trip trip = trips[index];
                final date = trip.date.toLocal();
                final riskLabel = (trip.riskScore != null && trip.riskScore! > 80) ? 'Risque' : 'OK';
                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(
                      '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}',
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Durée : ${trip.duration}'),
                        Text('Distance : ${trip.distance.toStringAsFixed(1)} km'),
                        if (trip.riskScore != null)
                          Text('Score du trajet : ${trip.riskScore!.toInt()} – $riskLabel'),
                      ],
                    ),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        '/trip-detail',
                        arguments: trip,
                      );
                    },
                  ),
                );
              },
            ),
    );
  }
}
