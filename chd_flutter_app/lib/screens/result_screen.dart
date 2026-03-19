// ─────────────────────────────────────────────────────────────────────────────
// result_screen.dart – Premium risk result display
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/patient_data.dart';
import '../models/prediction_result.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/risk_indicator.dart';
import '../services/advisory_service.dart';
import '../widgets/advisory_cards.dart';

class ResultScreen extends StatelessWidget {
  final PredictionResult result;
  final PatientData patient;

  const ResultScreen({
    super.key,
    required this.result,
    required this.patient,
  });

  // ── Theming per risk level ───────────────────────────────────────────────
  Color get _primaryColor {
    switch (result.riskLevel) {
      case 'High':     return AppColors.danger;
      case 'Moderate': return AppColors.warning;
      default:         return AppColors.success;
    }
  }

  IconData get _icon {
    switch (result.riskLevel) {
      case 'High':     return Icons.warning_rounded;
      case 'Moderate': return Icons.info_rounded;
      default:         return Icons.check_circle_rounded;
    }
  }

  String get _headline {
    switch (result.riskLevel) {
      case 'High':     return 'High Risk Detected';
      case 'Moderate': return 'Moderate Risk';
      default:         return 'Low Risk';
    }
  }

  String get _description {
    switch (result.riskLevel) {
      case 'High':
        return 'Immediate medical consultation is strongly recommended. '
            'Multiple high-risk factors have been identified. Please consult a cardiologist.';
      case 'Moderate':
        return 'Some risk factors are present. Lifestyle modifications and '
            'regular check-ups are advised to prevent progression.';
      default:
        return 'Risk factors appear to be within acceptable range. '
            'Maintain a healthy diet and regular exercise to keep risk low.';
    }
  }

  List<String> get _recommendations {
    switch (result.riskLevel) {
      case 'High':
        return [
          '🏥 Seek immediate medical evaluation',
          '💊 Review and optimise medications',
          '🚭 Quit smoking if applicable',
          '🥗 Follow a heart-healthy diet',
          '📉 Strict cholesterol & BP management',
        ];
      case 'Moderate':
        return [
          '🩺 Schedule a cardiology consultation',
          '🏃 Increase physical activity',
          '🥦 Adopt a low-fat, low-sodium diet',
          '📊 Monitor BP & cholesterol regularly',
          '🚭 Reduce or eliminate smoking',
        ];
      default:
        return [
          '✅ Continue healthy lifestyle habits',
          '🏃 Exercise at least 30 min/day',
          '🥗 Maintain a balanced diet',
          '📅 Annual health check-ups',
          '😴 Ensure 7-8 hours of sleep',
        ];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text('Prediction Result',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textPrimary,
            )),
        leading: const BackButton(color: AppColors.textSecondary),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.bgDark,
                AppColors.bgDark.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            children: [
              // ── Risk Level Banner ────────────────────────────────────────
              GlassCard(
                glowColor: _primaryColor,
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                child: Column(
                  children: [
                    Icon(_icon, color: _primaryColor, size: 54)
                        .animate()
                        .scale(
                          begin: const Offset(0, 0),
                          delay: 100.ms,
                          duration: 600.ms,
                          curve: Curves.elasticOut,
                        ),
                    const SizedBox(height: 14),
                    Text(
                      _headline,
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w800,
                        fontSize: 28,
                        color: _primaryColor,
                        letterSpacing: 0.5,
                      ),
                    ).animate().fade(delay: 250.ms, duration: 400.ms),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 6),
                      decoration: BoxDecoration(
                        color: _primaryColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                            color: _primaryColor.withValues(alpha: 0.35),
                            width: 1),
                      ),
                      child: Text(
                        '${result.riskLevel} Risk Category',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _primaryColor,
                        ),
                      ),
                    ),
                    const SizedBox(height: 28),
                    RiskIndicator(
                        riskScore: result.riskScore,
                        riskLevel: result.riskLevel),
                    const SizedBox(height: 20),
                    Text(
                      _description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.textSecondary,
                        height: 1.6,
                      ),
                    ).animate().fade(delay: 500.ms, duration: 500.ms),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // ── Patient Summary ──────────────────────────────────────────
              GlassCard(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(7),
                          decoration: BoxDecoration(
                            color: AppColors.cyan.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.person_outline,
                              color: AppColors.cyan, size: 18),
                        ),
                        const SizedBox(width: 10),
                        Text('Patient Summary',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 15,
                              color: AppColors.textPrimary,
                            )),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Divider(
                        color: Colors.white.withValues(alpha: 0.08),
                        height: 1),
                    const SizedBox(height: 14),
                    _Row('Age', '${patient.age} years'),
                    _Row('Gender', patient.gender),
                    _Row('Total Cholesterol', '${patient.totalChol} mg/dL'),
                    _Row('HDL Cholesterol', '${patient.hdl} mg/dL'),
                    _Row('Blood Pressure',
                        '${patient.systolic}/${patient.diastolic} mmHg'),
                    _Row('Smoking', patient.smoking),
                    _Row('Diabetes', patient.diabetes),
                    _Row('Family History', patient.family),
                  ],
                ),
              )
                  .animate()
                  .slideY(begin: 0.1, delay: 300.ms, duration: 500.ms)
                  .fade(delay: 300.ms),

              const SizedBox(height: 16),

              // ── Detailed Preventive Advisory ─────────────────────────────
              AdvisoryCards(
                riskLevel: result.riskLevel,
                advisory: AdvisoryService.generateAdvisory(patient, result),
              ).animate()
                  .slideY(begin: 0.1, delay: 450.ms, duration: 500.ms)
                  .fade(delay: 450.ms),

              const SizedBox(height: 24),

              // ── Download PDF Report ──────────────────────────────────────
              SizedBox(
                width: double.infinity,
                height: 52,
                child: GradientButton(
                  text: 'Download PDF Report',
                  icon: Icons.picture_as_pdf_outlined,
                  onPressed: () async {
                    try {
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) => const Center(child: CircularProgressIndicator()),
                      );
                      
                      final patientPayload = {
                        ...patient.toJson(),
                        'riskScore': result.riskScore,
                        'riskLevel': result.riskLevel,
                      };
                      
                      final msg = await ApiService.instance.generatePdf(patientPayload, 'Assessed Patient');
                      
                      if (context.mounted) {
                        Navigator.pop(context); // Close loading dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(msg),
                            backgroundColor: AppColors.success,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context); // Close loading dialog
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(e.toString()),
                            backgroundColor: AppColors.danger,
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      }
                    }
                  },
                ),
              ).animate().fade(delay: 550.ms, duration: 400.ms),

              const SizedBox(height: 16),

              // ── Action buttons ───────────────────────────────────────────
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 52,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: AppColors.cyan.withValues(alpha: 0.6),
                          width: 1.5,
                        ),
                        color: AppColors.cyan.withValues(alpha: 0.08),
                      ),
                      child: Material(
                        color: Colors.transparent,
                        borderRadius: BorderRadius.circular(14),
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(14),
                          splashColor: AppColors.cyan.withValues(alpha: 0.2),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.refresh,
                                  size: 18,
                                  color: AppColors.cyan),
                              const SizedBox(width: 8),
                              Text('New Prediction',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.cyan,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: SizedBox(
                      height: 52,
                      child: GradientButton(
                        text: 'Home',
                        icon: Icons.home_outlined,
                        height: 52,
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context, '/home', (_) => false),
                      ),
                    ),
                  ),
                ],
              ).animate().fade(delay: 600.ms, duration: 400.ms),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.poppins(
                  fontSize: 13, color: AppColors.textMuted)),
          Text(value,
              style: GoogleFonts.poppins(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              )),
        ],
      ),
    );
  }
}
