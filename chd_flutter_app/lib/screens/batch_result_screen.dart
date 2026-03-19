import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/patient_data.dart';
import '../models/prediction_result.dart';
import '../services/api_service.dart';
import '../services/advisory_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import '../widgets/advisory_cards.dart';

class BatchResultScreen extends StatefulWidget {
  final List<dynamic> batchData; // Raw list of patients to predict

  const BatchResultScreen({super.key, required this.batchData});

  @override
  State<BatchResultScreen> createState() => _BatchResultScreenState();
}

class _BatchResultScreenState extends State<BatchResultScreen> {
  bool _isLoading = true;
  String? _error;
  List<dynamic> _results = [];

  int _lowRiskCount = 0;
  int _modRiskCount = 0;
  int _highRiskCount = 0;

  @override
  void initState() {
    super.initState();
    _processBatch();
  }

  Future<void> _processBatch() async {
    try {
      final response = await ApiService.instance.batchPredict(widget.batchData);
      
      int low = 0;
      int mod = 0;
      int high = 0;

      for (var doc in response) {
        final riskLevel = doc['riskLevel'].toString().toLowerCase();
        if (riskLevel == 'low') low++;
        else if (riskLevel == 'moderate') mod++;
        else if (riskLevel == 'high') high++;
      }

      if (mounted) {
        setState(() {
          _results = response;
          _lowRiskCount = low;
          _modRiskCount = mod;
          _highRiskCount = high;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _error = e.toString();
          _isLoading = false;
        });
      }
    }
  }

  void _showAdvisorySheet(Map<String, dynamic> patientMap) {
    // Map JSON back to PatientData and PredictionResult loosely to use AdvisoryService
    final pData = PatientData(
      age: patientMap['age'] is int ? patientMap['age'] : int.tryParse(patientMap['age'].toString()) ?? 40,
      gender: patientMap['gender'] ?? 'unknown',
      totalChol: patientMap['totalChol'] is num ? patientMap['totalChol'].toDouble() : double.tryParse(patientMap['totalChol'].toString()) ?? 200,
      hdl: patientMap['hdl'] is num ? patientMap['hdl'].toDouble() : double.tryParse(patientMap['hdl'].toString()) ?? 50,
      systolic: patientMap['systolic'] is int ? patientMap['systolic'] : int.tryParse(patientMap['systolic'].toString()) ?? 120,
      diastolic: patientMap['diastolic'] is int ? patientMap['diastolic'] : int.tryParse(patientMap['diastolic'].toString()) ?? 80,
      smoking: patientMap['smoking'] ?? 'no',
      diabetes: patientMap['diabetes'] ?? 'no',
      family: patientMap['family'] ?? 'no',
    );
    
    final predRes = PredictionResult(
      riskScore: patientMap['riskScore'] is int ? patientMap['riskScore'] : int.tryParse(patientMap['riskScore'].toString()) ?? 0,
      riskLevel: patientMap['riskLevel'] ?? 'Low',
    );

    final advisory = AdvisoryService.generateAdvisory(pData, predRes);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 12, bottom: 20),
              width: 40,
              height: 5,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.cyan.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.person_outline, color: AppColors.cyan, size: 24),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              patientMap['patientName'] ?? 'Unknown Patient',
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              '${pData.age} yrs | ${pData.gender} | Score: ${predRes.riskScore}%',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: _getRiskColor(predRes.riskLevel).withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: _getRiskColor(predRes.riskLevel).withOpacity(0.3)),
                        ),
                        child: Text(
                          predRes.riskLevel,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: _getRiskColor(predRes.riskLevel),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  AdvisoryCards(advisory: advisory, riskLevel: predRes.riskLevel),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getRiskColor(String risk) {
    if (risk.toLowerCase() == 'high') return AppColors.danger;
    if (risk.toLowerCase() == 'moderate') return AppColors.warning;
    return AppColors.success;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Batch Dashboard',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 18,
            color: AppColors.textPrimary,
          ),
        ),
        leading: const BackButton(color: AppColors.textSecondary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bgDark,
                AppColors.bgDark.withOpacity(0.0),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
              : _error != null
                  ? Center(child: Text(_error!, style: const TextStyle(color: AppColors.danger)))
                  : _buildDashboard(),
        ),
      ),
    );
  }

  Widget _buildDashboard() {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Risk Distribution',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('Low', _lowRiskCount, _results.length, AppColors.success)),
                    const SizedBox(width: 12),
                    Expanded(child: _buildMetricCard('Moderate', _modRiskCount, _results.length, AppColors.warning)),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildMetricCard('High', _highRiskCount, _results.length, AppColors.danger)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 24),
                        decoration: BoxDecoration(
                          color: AppColors.indigo.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: AppColors.indigo.withOpacity(0.3)),
                        ),
                        child: Column(
                          children: [
                            Text(
                              '${_results.length}',
                              style: GoogleFonts.poppins(
                                fontSize: 32,
                                fontWeight: FontWeight.w800,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Total Patients',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                Text(
                  'Patient Roster',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final idx = index ~/ 2;
              if (index.isOdd) {
                return const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Divider(color: Colors.white10, height: 1),
                );
              }
              final doc = _results[idx];
              final riskScore = doc['riskScore'] ?? 0;
              final riskLevel = doc['riskLevel'] ?? 'Unknown';
              final color = _getRiskColor(riskLevel.toString());

              return ListTile(
                contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                title: Text(
                  doc['patientName'] ?? 'Patient ID: ${doc['_id'].toString().substring(0, 5)}',
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                    fontSize: 15,
                  ),
                ),
                subtitle: Text(
                  'Risk Score: $riskScore% • Lvl: $riskLevel',
                  style: GoogleFonts.poppins(
                    color: AppColors.textSecondary,
                    fontSize: 13,
                  ),
                ),
                trailing: TextButton.icon(
                  onPressed: () => _showAdvisorySheet(doc),
                  icon: const Icon(Icons.medical_services_outlined, size: 16),
                  label: const Text('Advisory'),
                  style: TextButton.styleFrom(
                    foregroundColor: color,
                    backgroundColor: color.withOpacity(0.15),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              );
            },
            childCount: _results.length * 2 - 1,
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 40)),
      ],
    );
  }

  Widget _buildMetricCard(String title, int count, int total, Color color) {
    final pct = total == 0 ? 0 : ((count / total) * 100).round();
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: AppDecorations.cardShadow,
      ),
      child: Column(
        children: [
          Text(
            count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            '$title Risk',
            style: GoogleFonts.poppins(
              fontSize: 13,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$pct%',
            style: GoogleFonts.poppins(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}
