import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../providers/data_provider.dart';
import '../models/score.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glass_card.dart';


class ScoresScreen extends StatefulWidget {
  static const routeName = '/scores';
  const ScoresScreen({super.key});

  @override
  _ScoresScreenState createState() => _ScoresScreenState();
}
class _AnimatedScoreCircle extends StatelessWidget {
  final String label;
  final int value;

  const _AnimatedScoreCircle({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: value.toDouble()),
      duration: const Duration(milliseconds: 800),
      curve: Curves.easeOutCubic,
      builder: (context, current, child) {
        final progress = (current / 100).clamp(0.0, 1.0);
        return Column(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 8,
                    backgroundColor: Colors.white.withOpacity(0.05),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      label == 'Safety'
                          ? const Color(0xFF22C55E)
                          : const Color(0xFFFACC15),
                    ),
                  ),
                  Text(
                    '${current.toInt()}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '$label Score',
              style: const TextStyle(fontSize: 14, color: Colors.grey),
            ),
          ],
        );
      },
    );
  }
}

class _ScoresScreenState extends State<ScoresScreen> {
  bool _loading = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final dataProvider = Provider.of<DataProvider>(context, listen: false);
    if (user != null) {
      dataProvider.loadScores(user.id).then((_) {
        setState(() => _loading = false);
      });
    }
  }

@override
Widget build(BuildContext context) {
  final Score? score = Provider.of<DataProvider>(context).score;
  if (_loading) {
    return const Scaffold(
      body: Center(child: CircularProgressIndicator()),
    );
  }
  if (score == null) {
    return const Scaffold(
      body: Center(child: Text('Aucun score disponible.')),
    );
  }

  return Scaffold(
    extendBodyBehindAppBar: true,
    appBar: AppBar(
      title: const Text('Mes scores'),
      backgroundColor: Colors.transparent,
    ),
    body: GradientBackground(
      child: Padding(
        padding: const EdgeInsets.only(top: kToolbarHeight + 16),
        child: ListView(
          children: [
            GlassCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _AnimatedScoreCircle(label: 'Safety', value: score.safety),
                  _AnimatedScoreCircle(label: 'Eco', value: score.eco),
                ],
              ),
            ).animate().fadeIn(duration: 400.ms).slideY(begin: 0.1),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () =>
                      Navigator.of(context).pushNamed('/score-details'),
                  child: const Text('Comprendre mes scores'),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Évolution (semaine / mois)',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 8),

            ...score.history.map(
              (item) => GlassCard(
                margin:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${item.date.day}/${item.date.month}/${item.date.year}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Safety: ${item.safety}'),
                        Text('Eco: ${item.eco}'),
                      ],
                    ),
                  ],
                ),
              ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.1),
            ),

            const SizedBox(height: 12),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Text('Conseils personnalisés',
                  style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            const SizedBox(height: 4),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('• Réduis les freinages brusques en ville.'),
                  Text('• Évite les accélérations fortes à l’entrée d’autoroute.'),
                  Text('• Maintiens une vitesse plus stable sur voie rapide.'),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    ),
  );
}

}
