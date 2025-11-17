class ScoreHistoryItem {
  final DateTime date;
  final int safety;
  final int eco;

  ScoreHistoryItem({
    required this.date,
    required this.safety,
    required this.eco,
  });
}

class Score {
  final int safety;
  final int eco;
  final List<ScoreHistoryItem> history;

  Score({
    required this.safety,
    required this.eco,
    required this.history,
  });
}
