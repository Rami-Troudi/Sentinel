import '../models/trip.dart';
import '../models/score.dart';
import '../models/reward.dart';

class ApiService {
  // Simulate API calls with mock data

  Future<List<Trip>> getTrips(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return [
      Trip(
        id: '1',
        date: DateTime.now().subtract(const Duration(days: 1)),
        duration: '00:25:00',
        distance: 12.5,
        riskScore: 78,
      ),
      Trip(
        id: '2',
        date: DateTime.now().subtract(const Duration(days: 2)),
        duration: '00:15:30',
        distance: 6.2,
        riskScore: 85,
      ),
      Trip(
        id: '3',
        date: DateTime.now().subtract(const Duration(days: 4)),
        duration: '00:40:00',
        distance: 25.0,
        riskScore: 65,
      ),
    ];
  }

  Future<Score> getScores(String userId) async {
    await Future.delayed(const Duration(seconds: 1));
    return Score(
      safety: 82,
      eco: 88,
      history: [
        ScoreHistoryItem(date: DateTime.now().subtract(const Duration(days: 7)), safety: 80, eco: 85),
        ScoreHistoryItem(date: DateTime.now().subtract(const Duration(days: 14)), safety: 84, eco: 87),
        ScoreHistoryItem(date: DateTime.now().subtract(const Duration(days: 21)), safety: 82, eco: 88),
      ],
    );
  }

  Future<int> getEcoPoints(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return 2450;
  }

  Future<List<Reward>> getRewards(String userId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return [
      Reward(
        id: 'reward1',
        name: 'Bon d\'essence 20 TND',
        points: 2000,
        description: 'Utilisable dans toutes les stations-services partenaires.',
      ),
      Reward(
        id: 'reward2',
        name: 'Révision gratuite',
        points: 3500,
        description: 'Entretien gratuit chez un garage partenaire.',
      ),
      Reward(
        id: 'reward3',
        name: 'Réduction 5% sur la prime',
        points: 5000,
        description: 'Réduction sur la prochaine échéance de votre contrat.',
      ),
    ];
  }
}
