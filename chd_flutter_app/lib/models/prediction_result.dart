// ─────────────────────────────────────────────────────────────────────────────
// prediction_result.dart – API response model
// ─────────────────────────────────────────────────────────────────────────────

class PredictionResult {
  final int riskScore;
  final String riskLevel; // 'Low' | 'Moderate' | 'High'
  final DateTime? date;

  const PredictionResult({
    required this.riskScore,
    required this.riskLevel,
    this.date,
  });

  factory PredictionResult.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>;
    return PredictionResult(
      riskScore: (data['riskScore'] as num).toInt(),
      riskLevel: data['riskLevel'] as String,
    );
  }

  factory PredictionResult.fromHistoryJson(Map<String, dynamic> json) {
    return PredictionResult(
      riskScore: (json['riskScore'] as num).toInt(),
      riskLevel: json['riskLevel'] as String,
      date: json['createdAt'] != null ? DateTime.tryParse(json['createdAt'] as String) : null,
    );
  }

  /// Friendly percentage label
  String get riskPercentage => '$riskScore%';
}
