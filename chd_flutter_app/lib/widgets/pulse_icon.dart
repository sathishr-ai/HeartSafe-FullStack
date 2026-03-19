// ─────────────────────────────────────────────────────────────────────────────
// pulse_icon.dart – Heartbeat-pulsing icon with glow ring
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';

import '../utils/app_theme.dart';

/// A continuously pulsing icon inside a gradient circle with a glow ring.
class PulseIcon extends StatefulWidget {
  final double size;
  final IconData icon;
  const PulseIcon({
    super.key,
    this.size = 100,
    this.icon = Icons.favorite,
  });

  @override
  State<PulseIcon> createState() => _PulseIconState();
}

class _PulseIconState extends State<PulseIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);

    _scale = Tween(begin: 1.0, end: 1.08).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _glow = Tween(begin: 0.25, end: 0.55).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _ctrl,
      builder: (context, child) {
        return Transform.scale(
          scale: _scale.value,
          child: Container(
            width: widget.size,
            height: widget.size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppColors.accentGradient,
              boxShadow: [
                BoxShadow(
                  color: AppColors.cyan.withValues(alpha: _glow.value),
                  blurRadius: 36,
                  spreadRadius: 8,
                ),
              ],
            ),
            child: Icon(
              widget.icon,
              color: Colors.white,
              size: widget.size * 0.48,
            ),
          ),
        );
      },
    );
  }
}
