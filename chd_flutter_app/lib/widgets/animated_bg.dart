// ─────────────────────────────────────────────────────────────────────────────
// animated_bg.dart – Premium floating orb background
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:math';
import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// Full-screen animated background with drifting translucent orbs.
/// Wrap your screen content with this widget via a `Stack`.
class AnimatedBackground extends StatefulWidget {
  final Widget child;
  const AnimatedBackground({super.key, required this.child});

  @override
  State<AnimatedBackground> createState() => _AnimatedBackgroundState();
}

class _AnimatedBackgroundState extends State<AnimatedBackground>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 20),
    )..repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0F172A), // Slate 900
            Color(0xFF020617), // Deepest Slate
            Color(0xFF0B132B), // Very deep navy
          ],
        ),
      ),
      child: Stack(
        children: [
          // Animated orbs layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _ctrl,
              builder: (context, _) {
                return CustomPaint(
                  painter: _OrbPainter(_ctrl.value),
                );
              },
            ),
          ),
          // Actual screen content
          widget.child,
        ],
      ),
    );
  }
}

class _OrbPainter extends CustomPainter {
  final double progress;
  _OrbPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final orbs = [
      _Orb(0.15, 0.20, 80, const Color(0xFF00E5FF), 0.06),
      _Orb(0.75, 0.15, 100, const Color(0xFF1565C0), 0.05),
      _Orb(0.50, 0.65, 120, const Color(0xFF00B8D4), 0.04),
      _Orb(0.85, 0.75, 70, const Color(0xFF0D47A1), 0.06),
      _Orb(0.25, 0.85, 90, const Color(0xFF4FC3F7), 0.04),
    ];

    for (final orb in orbs) {
      final dx = orb.baseX * size.width +
          sin((progress + orb.phase) * 2 * pi) * 30;
      final dy = orb.baseY * size.height +
          cos((progress + orb.phase) * 2 * pi) * 25;

      canvas.drawCircle(
        Offset(dx, dy),
        orb.radius,
        Paint()
          ..color = orb.color.withValues(alpha: orb.alpha)
          ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 40),
      );
    }
  }

  @override
  bool shouldRepaint(_OrbPainter old) => old.progress != progress;
}

class _Orb {
  final double baseX, baseY, radius;
  final Color color;
  final double alpha;
  double get phase => baseX + baseY; // unique per orb

  const _Orb(this.baseX, this.baseY, this.radius, this.color, this.alpha);
}
