import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_theme.dart';

class HealthGauge extends StatelessWidget {
  final double score; // 0.0 to 100.0
  final String riskLevel;
  final bool isLoading;

  const HealthGauge({
    super.key,
    required this.score,
    required this.riskLevel,
    this.isLoading = false,
  });

  /// Get the appropriate color based on CHD Risk Score (lower is better usually, but here higher score = higher risk for demo logic mapping)
  Color _getRiskColor() {
    if (riskLevel.toLowerCase().contains('low')) return AppColors.success;
    if (riskLevel.toLowerCase().contains('moderate')) return AppColors.warning;
    return AppColors.danger;
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: SizedBox(
          width: 140,
          height: 140,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.cyan.withValues(alpha: 0.3)),
            strokeWidth: 8,
          ),
        ),
      );
    }

    final double normalizedScore = (score / 100).clamp(0.0, 1.0);
    final targetColor = _getRiskColor();

    return Stack(
      alignment: Alignment.center,
      children: [
        // Background track track
        SizedBox(
          width: 150,
          height: 150,
          child: TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: normalizedScore),
            duration: const Duration(milliseconds: 1800),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 12,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      AppColors.bgCard.withValues(alpha: 0.8),
                    ),
                  ),
                  CircularProgressIndicator(
                    value: value,
                    strokeWidth: 12,
                    strokeCap: StrokeCap.round,
                    valueColor: AlwaysStoppedAnimation<Color>(targetColor),
                  ),
                  // Outer Glow for Premium Feel
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: targetColor.withValues(alpha: 0.2 * value),
                          blurRadius: 30,
                          spreadRadius: 2,
                        )
                      ]
                    ),
                  )
                ],
              );
            },
          ),
        ),
        // Center Text
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              '${score.toStringAsFixed(1)}%',
              style: GoogleFonts.poppins(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: Colors.white,
                shadows: AppDecorations.glowShadow(targetColor, blur: 10),
              ),
            ),
            Text(
              riskLevel,
              style: GoogleFonts.poppins(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: targetColor,
              ),
            ),
          ],
        ).animate().fadeIn(delay: 500.ms).scale(curve: Curves.easeOutBack),
      ],
    );
  }
}
