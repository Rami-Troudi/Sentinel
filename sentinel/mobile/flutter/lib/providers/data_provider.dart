import 'package:flutter/foundation.dart';
import '../models/trip.dart';
import '../models/score.dart';
import '../models/reward.dart';
import '../services/api_service.dart';

class DataProvider with ChangeNotifier {
  final ApiService apiService;
  DataProvider({required this.apiService});

  List<Trip> _trips = [];
  Score? _score;
  int _ecoPoints = 0;
  List<Reward> _rewards = [];

  List<Trip> get trips => _trips;
  Score? get score => _score;
  int get ecoPoints => _ecoPoints;
  List<Reward> get rewards => _rewards;

  Future<void> loadTrips(String userId) async {
    _trips = await apiService.getTrips(userId);
    notifyListeners();
  }

  Future<void> loadScores(String userId) async {
    _score = await apiService.getScores(userId);
    notifyListeners();
  }

  Future<void> loadEcoPoints(String userId) async {
    _ecoPoints = await apiService.getEcoPoints(userId);
    notifyListeners();
  }

  Future<void> loadRewards(String userId) async {
    _rewards = await apiService.getRewards(userId);
    notifyListeners();
  }
}
