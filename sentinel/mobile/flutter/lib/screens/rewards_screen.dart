import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/reward.dart';

class RewardsScreen extends StatefulWidget {
  static const routeName = '/rewards';
  const RewardsScreen({super.key});

  @override
  _RewardsScreenState createState() => _RewardsScreenState();
}

class _RewardsScreenState extends State<RewardsScreen> {
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (user != null) {
      dataProvider.loadEcoPoints(user.id).then((_) {
        dataProvider.loadRewards(user.id).then((_) {
          setState(() => _loading = false);
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ecoPoints = Provider.of<DataProvider>(context).ecoPoints;
    final rewards = Provider.of<DataProvider>(context).rewards;
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: ListView(
          children: [
            const Text('Mes eco-points', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text('$ecoPoints points', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            const Text('Exemple : +10 points pour une semaine sans trajet à risque.', style: TextStyle(fontSize: 12, color: Colors.grey)),
            const SizedBox(height: 16),
            const Text('Récompenses disponibles', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            ...rewards.map((Reward reward) => Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.card_giftcard),
                    title: Text(reward.name),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Coût : ${reward.points} points'),
                        Text(reward.description),
                        const Text('Validation par votre compagnie d\'assurance nécessaire.',
                            style: TextStyle(fontSize: 12, color: Colors.grey)),
                      ],
                    ),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}
