// ─────────────────────────────────────────────────────────────────────────────
// followup_result.dart – API response model for follow-ups
// ─────────────────────────────────────────────────────────────────────────────

class FollowupResult {
  final String id;
  final String patientId;
  final String patientName;
  final String date;
  final String? time;
  final String? notes;
  final String? riskLevel;

  const FollowupResult({
    required this.id,
    required this.patientId,
    required this.patientName,
    required this.date,
    this.time,
    this.notes,
    this.riskLevel,
  });

  factory FollowupResult.fromJson(Map<String, dynamic> json) {
    return FollowupResult(
      id: json['_id']?.toString() ?? '',
      patientId: json['patientId']?.toString() ?? '',
      patientName: json['patientName']?.toString() ?? 'Unknown',
      date: json['date']?.toString() ?? '',
      time: json['time']?.toString(),
      notes: json['notes']?.toString(),
      riskLevel: json['riskLevel']?.toString(),
    );
  }
}
