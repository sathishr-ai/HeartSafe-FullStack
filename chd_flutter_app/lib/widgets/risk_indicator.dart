// ─────────────────────────────────────────────────────────────────────────────
// risk_indicator.dart – Premium animated circular risk gauge with gradient arc
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_theme.dart';

class RiskIndicator extends StatelessWidget {
  final int riskScore;
  final String riskLevel;

  const RiskIndicator({
    super.key,
    required this.riskScore,
    required this.riskLevel,
  });

  Color get _color {
    switch (riskLevel) {
      case 'High':
        return AppColors.danger;
      case 'Moderate':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  Color get _colorEnd {
    switch (riskLevel) {
      case 'High':
        return const Color(0xFFFF1744);
      case 'Moderate':
        return const Color(0xFFFF8F00);
      default:
        return const Color(0xFF00E676);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 200,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Ambient glow ring
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: _color.withValues(alpha: 0.12),
                  blurRadius: 40,
                  spreadRadius: 10,
                ),
              ],
            ),
          ),
          // Animated Gauge & Text
          TweenAnimationBuilder<double>(
            tween: Tween<double>(begin: 0, end: riskScore / 100),
            duration: const Duration(milliseconds: 1800),
            curve: Curves.easeOutCubic,
            builder: (context, val, child) {
              return Stack(
                alignment: Alignment.center,
                children: [
                  CustomPaint(
                    size: const Size(200, 200),
                    painter: _GaugePainter(
                      value: val,
                      color: _color,
                      colorEnd: _colorEnd,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(val * 100).toInt()}%',
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w800,
                          fontSize: 38,
                          color: _color,
                          shadows: [
                            Shadow(
                              color: _color.withValues(alpha: 0.4),
                              blurRadius: 16,
                            ),
                          ],
                        ),
                      ),
                      Text(
                        'Risk Score',
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
        ],
      ),
    ).animate().scale(
          begin: const Offset(0.6, 0.6),
          end: const Offset(1, 1),
          duration: 700.ms,
          curve: Curves.elasticOut,
        );
  }
}

class _GaugePainter extends CustomPainter {
  final double value;
  final Color color;
  final Color colorEnd;
  _GaugePainter({
    required this.value,
    required this.color,
    required this.colorEnd,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 14;
    const startAngle = pi * 0.75;
    const sweepFull = pi * 1.5;

    // Track
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweepFull,
      false,
      Paint()
        ..color = Colors.white.withValues(alpha: 0.06)
        ..strokeWidth = 16
        ..style = PaintingStyle.stroke
        ..strokeCap = StrokeCap.round,
    );

    // Tick marks
    for (int i = 0; i <= 10; i++) {
      final angle = startAngle + (sweepFull * i / 10);
      final tickStart = Offset(
        center.dx + (radius + 8) * cos(angle),
        center.dy + (radius + 8) * sin(angle),
      );
      final tickEnd = Offset(
        center.dx + (radius + 14) * cos(angle),
        center.dy + (radius + 14) * sin(angle),
      );
      canvas.drawLine(
        tickStart,
        tickEnd,
        Paint()
          ..color = Colors.white.withValues(alpha: 0.12)
          ..strokeWidth = 1.5
          ..strokeCap = StrokeCap.round,
      );
    }

    // Gradient value arc
    if (value > 0) {
      final rect = Rect.fromCircle(center: center, radius: radius);
      final gradient = ui.Gradient.sweep(
        center,
        [color, colorEnd],
        [0.0, 1.0],
        TileMode.clamp,
        startAngle,
        startAngle + sweepFull * value,
      );

      canvas.drawArc(
        rect,
        startAngle,
        sweepFull * value,
        false,
        Paint()
          ..shader = gradient
          ..strokeWidth = 16
          ..style = PaintingStyle.stroke
          ..strokeCap = StrokeCap.round,
      );
    }
  }

  @override
  bool shouldRepaint(_GaugePainter old) =>
      old.value != value || old.color != color;
}
