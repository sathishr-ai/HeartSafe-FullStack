// ─────────────────────────────────────────────────────────────────────────────
// validators.dart – Form field validators
// ─────────────────────────────────────────────────────────────────────────────

class Validators {
  static String? age(String? value) {
    if (value == null || value.isEmpty) return 'Age is required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 18 || n > 120) return 'Age must be between 18 – 120';
    return null;
  }

  static String? totalCholesterol(String? value) {
    if (value == null || value.isEmpty) return 'Total cholesterol is required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 50 || n > 600) return 'Normal range: 50 – 600 mg/dL';
    return null;
  }

  static String? hdl(String? value) {
    if (value == null || value.isEmpty) return 'HDL is required';
    final n = double.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 10 || n > 200) return 'Normal range: 10 – 200 mg/dL';
    return null;
  }

  static String? systolic(String? value) {
    if (value == null || value.isEmpty) return 'Systolic BP is required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 60 || n > 250) return 'Normal range: 60 – 250 mmHg';
    return null;
  }

  static String? diastolic(String? value) {
    if (value == null || value.isEmpty) return 'Diastolic BP is required';
    final n = int.tryParse(value);
    if (n == null) return 'Enter a valid number';
    if (n < 40 || n > 150) return 'Normal range: 40 – 150 mmHg';
    return null;
  }

  static String? required(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) return '$fieldName is required';
    return null;
  }
}
