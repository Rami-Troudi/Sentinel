import 'package:flutter/material.dart';

class ScoreDetailsScreen extends StatelessWidget {
  static const routeName = '/score-details';
  const ScoreDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Comprendre mes scores')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text('Comment sont calculés mes scores ?', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 12),
            Text('1. Données utilisées', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Le module Sentinel mesure vos accélérations, freinages et virages grâce à un capteur inertiel (IMU). Ces signaux sont analysés côté serveur.'),
            SizedBox(height: 8),
            Text('2. Safety Score', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Le Safety Score reflète votre niveau de risque global (0 à 100). Il prend en compte les freinages brusques, virages serrés et accélérations agressives.'),
            SizedBox(height: 8),
            Text('3. Eco Score', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'L\'Eco Score mesure votre éco-conduite : plus votre conduite est fluide et stable, plus votre score est élevé.'),
            SizedBox(height: 8),
            Text('4. Recommandations', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
                'Sentinel fournit des conseils personnalisés pour améliorer vos scores, comme anticiper les freinages ou éviter les accélérations brusques.'),
            SizedBox(height: 12),
            Text(
              'Remarque : les scores servent à la prévention et à la récompense, et ne modifient pas directement votre contrat sans validation de l’assureur.',
              style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}
