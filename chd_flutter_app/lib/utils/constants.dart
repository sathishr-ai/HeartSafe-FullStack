// ─────────────────────────────────────────────────────────────────────────────
// constants.dart – App-wide constants
// ─────────────────────────────────────────────────────────────────────────────

class AppConstants {
  // ── API ─────────────────────────────────────────────────────────────────────
  /// Android emulator → 10.0.2.2 maps to host's localhost.
  /// Physical device  → change to your machine's LAN IP, e.g.:
  ///   static const String baseUrl = 'http://192.168.1.100:5000';
  static const String baseUrl = 'https://heartsafe-backend.onrender.com';

  static const String loginEndpoint    = '/api/auth/login';
  static const String registerEndpoint = '/api/auth/register';
  static const String predictEndpoint  = '/api/predictions/single';
  static const String batchPredictEndpoint = '/api/predictions/batch';
  static const String historyEndpoint  = '/api/predictions/list';
  static const String exportPdfEndpoint = '/api/exports/pdf';
  static const String followupListEndpoint = '/api/followup/list';
  static const String followupScheduleEndpoint = '/api/followup/schedule';
  static const String healthEndpoint   = '/api/health';

  static const Duration requestTimeout = Duration(seconds: 15);

  // ── SharedPreferences keys ───────────────────────────────────────────────────
  static const String prefToken    = 'auth_token';
  static const String prefUsername = 'username';
  static const String prefRole     = 'role';

  // ── App Info ─────────────────────────────────────────────────────────────────
  static const String appName    = 'HeartSafe';
  static const String appTagline = 'CHD Risk Prediction System';
  static const String appVersion = 'v1.0.0';
}
