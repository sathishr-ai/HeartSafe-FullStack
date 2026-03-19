// ─────────────────────────────────────────────────────────────────────────────
// patient_data.dart – Request model
// ─────────────────────────────────────────────────────────────────────────────

class PatientData {
  final int age;
  final String gender;       // 'male' | 'female'
  final double totalChol;
  final double hdl;
  final int systolic;
  final int diastolic;
  final String smoking;      // 'yes' | 'no'
  final String diabetes;     // 'yes' | 'no'
  final String family;       // 'yes' | 'no'

  const PatientData({
    required this.age,
    required this.gender,
    required this.totalChol,
    required this.hdl,
    required this.systolic,
    required this.diastolic,
    required this.smoking,
    required this.diabetes,
    required this.family,
  });

  Map<String, dynamic> toJson() => {
        'age': age,
        'gender': gender,
        'totalChol': totalChol,
        'hdl': hdl,
        'systolic': systolic,
        'diastolic': diastolic,
        'smoking': smoking,
        'diabetes': diabetes,
        'family': family,
      };
}
