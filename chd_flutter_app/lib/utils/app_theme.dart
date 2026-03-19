// ─────────────────────────────────────────────────────────────────────────────
// app_theme.dart – Centralized premium design system
// ─────────────────────────────────────────────────────────────────────────────

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Premium colour palette for HeartSafe
class AppColors {
  // ── Brand ──────────────────────────────────────────────────────────────────
  static const Color cyan        = Color(0xFF00E5FF);
  static const Color cyanLight   = Color(0xFF4FC3F7);
  static const Color cyanDeep    = Color(0xFF00B8D4);
  static const Color indigo      = Color(0xFF1565C0);
  static const Color indigoDeep  = Color(0xFF0D47A1);

  // ── Surfaces ───────────────────────────────────────────────────────────────
  static const Color bgDark      = Color(0xFF060B1E);
  static const Color bgMid       = Color(0xFF0A1128);
  static const Color bgCard      = Color(0xFF0E1A38);
  static const Color glassFill   = Color(0x1A1E3A6E);  // 10 % opacity navy
  static const Color glassBorder = Color(0x33FFFFFF);   // 20 % opacity white

  // ── Text ───────────────────────────────────────────────────────────────────
  static const Color textPrimary   = Color(0xFFF0F4FC);
  static const Color textSecondary = Color(0xFFB0C4DE);
  static const Color textMuted     = Color(0xFF5C7099);

  // ── Status ─────────────────────────────────────────────────────────────────
  static const Color success = Color(0xFF66BB6A);
  static const Color warning = Color(0xFFFFB300);
  static const Color danger  = Color(0xFFEF5350);

  // ── Gradients ──────────────────────────────────────────────────────────────
  static const LinearGradient bgGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [bgDark, bgMid, Color(0xFF081224)],
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [cyan, indigo],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF00B4D8), Color(0xFF1565C0), Color(0xFF0D47A1)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1565C0), Color(0xFF0D47A1), Color(0xFF0A2F6E)],
  );
}

/// Reusable box-decoration helpers
class AppDecorations {
  static final List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Colors.black.withValues(alpha: 0.3),
      blurRadius: 20,
      offset: const Offset(0, 8),
    ),
  ];

  /// Frosted glassmorphism container
  static BoxDecoration glass({
    double borderRadius = 20,
    Color? glowColor,
    double borderOpacity = 0.15,
  }) {
    return BoxDecoration(
      color: AppColors.glassFill,
      borderRadius: BorderRadius.circular(borderRadius),
      border: Border.all(
        color: Colors.white.withValues(alpha: borderOpacity),
        width: 1.2,
      ),
      boxShadow: [
        if (glowColor != null)
          BoxShadow(
            color: glowColor.withValues(alpha: 0.18),
            blurRadius: 24,
            spreadRadius: 2,
          ),
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.3),
          blurRadius: 20,
          offset: const Offset(0, 8),
        ),
      ],
    );
  }

  /// Glow shadow for elevated elements
  static List<BoxShadow> glowShadow(Color color, {double blur = 20}) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.35),
        blurRadius: blur,
        spreadRadius: 2,
      ),
    ];
  }
}

/// Reusable `InputDecoration` for premium text fields
InputDecoration premiumInputDecoration({
  required String hint,
  required IconData icon,
  String? suffixText,
}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13),
    suffixText: suffixText,
    suffixStyle: GoogleFonts.poppins(
      color: AppColors.textSecondary.withValues(alpha: 0.6),
      fontSize: 12,
    ),
    prefixIcon: Icon(icon, color: AppColors.cyan, size: 20),
    filled: true,
    fillColor: AppColors.bgCard.withValues(alpha: 0.7),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide.none,
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(
        color: Colors.white.withValues(alpha: 0.08),
        width: 1.2,
      ),
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.cyan, width: 1.8),
    ),
    errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.2),
    ),
    focusedErrorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: const BorderSide(color: AppColors.danger, width: 1.8),
    ),
    errorStyle: GoogleFonts.poppins(fontSize: 11, color: const Color(0xFFEF9A9A)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
  );
}

/// A frosted-blur wrapper used inside glass cards
class FrostedBlur extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double sigmaX;
  final double sigmaY;
  const FrostedBlur({
    super.key,
    required this.child,
    this.borderRadius = 20,
    this.sigmaX = 12,
    this.sigmaY = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: sigmaX, sigmaY: sigmaY),
        child: child,
      ),
    );
  }
}
