// ─────────────────────────────────────────────────────────────────────────────
// api_service.dart – All HTTP calls to the HeartSafe backend
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../models/patient_data.dart';
import '../models/prediction_result.dart';
import '../models/followup_result.dart';
import '../utils/constants.dart';

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  const ApiException(this.message, {this.statusCode});

  @override
  String toString() => message;
}

class ApiService {
  // ── Singleton ──────────────────────────────────────────────────────────────
  ApiService._();
  static final ApiService instance = ApiService._();

  String? _token;

  // ── Helpers ────────────────────────────────────────────────────────────────
  Uri _uri(String path) => Uri.parse('${AppConstants.baseUrl}$path');

  Map<String, String> get _headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (_token != null && _token!.isNotEmpty) 'Authorization': 'Bearer $_token',
      };

  Future<Map<String, dynamic>> _parseResponse(http.Response resp) async {
    Map<String, dynamic> body;
    try {
      body = jsonDecode(resp.body) as Map<String, dynamic>;
    } catch (_) {
      throw const ApiException('Invalid response from server');
    }
    if (resp.statusCode >= 200 && resp.statusCode < 300) return body;
    final msg = body['message'] as String? ?? 'Request failed';
    throw ApiException(msg, statusCode: resp.statusCode);
  }

  // ── Auth ───────────────────────────────────────────────────────────────────
  Future<Map<String, dynamic>> login(String username, String password) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.loginEndpoint),
            headers: _headers,
            body: jsonEncode({'username': username, 'password': password}),
          )
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);

      // Persist session
      final prefs = await SharedPreferences.getInstance();
      _token = data['token'] ?? '';
      await prefs.setString(AppConstants.prefToken, _token!);
      await prefs.setString(
          AppConstants.prefUsername, data['user']?['username'] ?? username);
      await prefs.setString(
          AppConstants.prefRole, data['user']?['role'] ?? '');

      return data;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          'Cannot reach server. Make sure the backend is running.\n$e');
    }
  }

  Future<Map<String, dynamic>> register(
      String username, String password, String role) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.registerEndpoint),
            headers: _headers,
            body: jsonEncode(
                {'username': username, 'password': password, 'role': role}),
          )
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      return data;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Cannot reach server for registration.\n$e');
    }
  }

  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AppConstants.prefToken);
    await prefs.remove(AppConstants.prefUsername);
    await prefs.remove(AppConstants.prefRole);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString(AppConstants.prefToken);
    return (_token ?? '').isNotEmpty;
  }

  Future<String?> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AppConstants.prefUsername);
  }

  // ── Prediction ─────────────────────────────────────────────────────────────
  Future<PredictionResult> predict(PatientData patient) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.predictEndpoint),
            headers: _headers,
            body: jsonEncode(patient.toJson()),
          )
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      return PredictionResult.fromJson(data);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException(
          'Prediction request failed. Check your connection.\n$e');
    }
  }

  Future<List<dynamic>> batchPredict(List<dynamic> patients) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.batchPredictEndpoint),
            headers: _headers,
            body: jsonEncode({'patients': patients}),
          )
          .timeout(AppConstants.requestTimeout * 2); // Batch takes longer

      final data = await _parseResponse(resp);
      return data['data'] as List<dynamic>;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Batch prediction failed: \n$e');
    }
  }

  // ── History ────────────────────────────────────────────────────────────────
  Future<List<PredictionResult>> getHistory() async {
    try {
      final resp = await http
          .get(_uri(AppConstants.historyEndpoint), headers: _headers)
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      final list = data['data'] as List? ?? [];
      
      // Sort newest first
      final results = list
          .map((e) => PredictionResult.fromHistoryJson(e as Map<String, dynamic>))
          .toList();
      results.sort((a, b) => (b.date ?? DateTime.now()).compareTo(a.date ?? DateTime.now()));
      
      return results;
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch prediction history.\n$e');
    }
  }

  // ── Exports ────────────────────────────────────────────────────────────────
  Future<String> generatePdf(Map<String, dynamic> predictionData, String patientName) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.exportPdfEndpoint),
            headers: _headers,
            body: jsonEncode({
              'predictions': [predictionData],
              'patientName': patientName,
            }),
          )
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      return data['message'] ?? 'PDF Report generated successfully';
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to generate PDF Report.\n$e');
    }
  }

  // ── Follow-Ups ─────────────────────────────────────────────────────────────
  Future<List<FollowupResult>> getFollowups() async {
    try {
      final resp = await http
          .get(_uri(AppConstants.followupListEndpoint), headers: _headers)
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      final list = data['data'] as List? ?? [];
      
      return list
          .map((e) => FollowupResult.fromJson(e as Map<String, dynamic>))
          .toList()
          ..sort((a, b) => b.date.compareTo(a.date));
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to fetch follow-ups.\n$e');
    }
  }

  Future<FollowupResult> scheduleFollowup(Map<String, dynamic> payload) async {
    try {
      final resp = await http
          .post(
            _uri(AppConstants.followupScheduleEndpoint),
            headers: _headers,
            body: jsonEncode(payload),
          )
          .timeout(AppConstants.requestTimeout);

      final data = await _parseResponse(resp);
      return FollowupResult.fromJson(data['data'] as Map<String, dynamic>);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to schedule follow-up.\n$e');
    }
  }

  Future<void> deleteFollowup(String id) async {
    try {
      final resp = await http
          .delete(
            _uri('/api/followup/$id'),
            headers: _headers,
          )
          .timeout(AppConstants.requestTimeout);
          
      await _parseResponse(resp);
    } on ApiException {
      rethrow;
    } catch (e) {
      throw ApiException('Failed to delete follow-up.\n$e');
    }
  }

  // ── Health check ───────────────────────────────────────────────────────────
  Future<bool> healthCheck() async {
    try {
      final resp = await http
          .get(_uri(AppConstants.healthEndpoint), headers: _headers)
          .timeout(const Duration(seconds: 5));
      return resp.statusCode == 200;
    } catch (_) {
      return false;
    }
  }
}
