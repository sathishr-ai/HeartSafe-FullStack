import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../utils/app_theme.dart';

class AdvisoryCards extends StatelessWidget {
  final Map<String, dynamic> advisory;
  final String riskLevel;

  const AdvisoryCards({
    super.key,
    required this.advisory,
    required this.riskLevel,
  });

  @override
  Widget build(BuildContext context) {
    final titleColor = _getTitleColor(riskLevel);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Detailed Preventive Advisory',
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: titleColor,
              ),
            ),
            Icon(Icons.health_and_safety, color: titleColor),
          ],
        ),
        const SizedBox(height: 16),
        _buildAdvisorySection(
          title: 'Immediate Actions Required',
          icon: Icons.warning_amber_rounded,
          items: List<String>.from(advisory['immediate_actions'] ?? []),
          borderColor: AppColors.cyan,
          bgColor: AppColors.bgCard,
          isHighPriority: riskLevel.toLowerCase().contains('high'),
        ),
        const SizedBox(height: 12),
        _buildAdvisorySection(
          title: 'Lifestyle Intervention Plan',
          icon: Icons.favorite_border,
          items: List<String>.from(advisory['lifestyle'] ?? []),
          borderColor: AppColors.cyan,
          bgColor: AppColors.bgCard,
          isHighPriority: riskLevel.toLowerCase().contains('high') ||
              riskLevel.toLowerCase().contains('moderate'),
        ),
        const SizedBox(height: 12),
        _buildAdvisorySection(
          title: 'Medication Recommendations',
          icon: Icons.medication_outlined,
          items: List<String>.from(advisory['medications'] ?? []),
          borderColor: AppColors.cyan,
          bgColor: AppColors.bgCard,
          isHighPriority: riskLevel.toLowerCase().contains('high') ||
              riskLevel.toLowerCase().contains('moderate'),
        ),
        const SizedBox(height: 12),
        _buildAdvisorySection(
          title: 'Monitoring & Follow-up',
          icon: Icons.calendar_month_outlined,
          items: List<String>.from(advisory['monitoring'] ?? []),
          borderColor: AppColors.cyan,
          bgColor: AppColors.bgCard,
          isHighPriority: true,
        ),
      ],
    );
  }

  Color _getTitleColor(String risk) {
    if (risk.toLowerCase().contains('high')) return AppColors.danger;
    if (risk.toLowerCase().contains('moderate')) return AppColors.warning;
    return AppColors.success;
  }

  Widget _buildAdvisorySection({
    required String title,
    required IconData icon,
    required List<String> items,
    required Color borderColor,
    required Color bgColor,
    bool isHighPriority = false,
  }) {
    if (items.isEmpty) return const SizedBox.shrink();

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: borderColor.withValues(alpha: 0.3)),
        boxShadow: AppDecorations.cardShadow,
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: borderColor, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              if (isHighPriority)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'HIGH PRIORITY',
                    style: GoogleFonts.poppins(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          ...items.map((item) {
            final parts = item.split(': ');
            final header = parts.length > 1 ? parts[0] + ': ' : '';
            final body = parts.length > 1 ? parts.sublist(1).join(': ') : item;

            return Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(top: 6, right: 8),
                    child: Icon(Icons.circle,
                        size: 6, color: AppColors.textSecondary),
                  ),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.poppins(
                            fontSize: 13,
                            color: AppColors.textSecondary,
                            height: 1.4),
                        children: [
                          if (header.isNotEmpty)
                            TextSpan(
                                text: header,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.textPrimary)),
                          TextSpan(text: body),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}
