class Trip {
  final String id;
  final DateTime date;
  final String duration;    // e.g. "00:25:00"
  final double distance;    // in km
  final double? riskScore;  // optional

  Trip({
    required this.id,
    required this.date,
    required this.duration,
    required this.distance,
    this.riskScore,
  });
}
