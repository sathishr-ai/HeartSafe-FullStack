import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/prediction_result.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  List<PredictionResult> _history = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    setState(() => _isLoading = true);
    try {
      final data = await ApiService.instance.getHistory();
      if (mounted) setState(() => _history = data);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e'), backgroundColor: AppColors.danger));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    int high = _history.where((e) => e.riskLevel == 'High').length;
    int mod = _history.where((e) => e.riskLevel == 'Moderate').length;
    int low = _history.where((e) => e.riskLevel == 'Low').length;
    int total = _history.length;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Population Analytics', style: GoogleFonts.poppins(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AnimatedBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
              : _history.isEmpty
                  ? Center(child: Text('No assessments yet.', style: GoogleFonts.poppins(color: Colors.white54)))
                  : SingleChildScrollView(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text('Risk Distribution Dashboard',
                                  style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white))
                              .animate().fade().slideY(begin: -0.2),
                          const SizedBox(height: 10),
                          Text('Based on $total total assessments.', style: GoogleFonts.poppins(color: Colors.white54))
                              .animate().fade(delay: 100.ms),
                          const SizedBox(height: 40),
                          SizedBox(
                            height: 250,
                            child: PieChart(
                              PieChartData(
                                sectionsSpace: 4,
                                centerSpaceRadius: 60,
                                sections: [
                                  if (high > 0)
                                    PieChartSectionData(
                                      color: AppColors.danger,
                                      value: high.toDouble(),
                                      title: '$high',
                                      radius: 60,
                                      titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  if (mod > 0)
                                    PieChartSectionData(
                                      color: AppColors.warning,
                                      value: mod.toDouble(),
                                      title: '$mod',
                                      radius: 55,
                                      titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                  if (low > 0)
                                    PieChartSectionData(
                                      color: AppColors.success,
                                      value: low.toDouble(),
                                      title: '$low',
                                      radius: 50,
                                      titleStyle: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                ],
                              ),
                            ).animate().scale(delay: 300.ms, curve: Curves.elasticOut, duration: 800.ms),
                          ),
                          const SizedBox(height: 40),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              _Legend('High Risk', AppColors.danger),
                              _Legend('Moderate', AppColors.warning),
                              _Legend('Low Risk', AppColors.success),
                            ],
                          ).animate().fade(delay: 500.ms),
                          const SizedBox(height: 40),
                          GlassCard(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Clinical Insights', style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white)),
                                const SizedBox(height: 12),
                                if (high > total * 0.3)
                                  Text('Warning: Over 30% of assessed patients are High Risk. Ensure follow-ups are tightly scheduled.', style: GoogleFonts.poppins(color: AppColors.danger, fontSize: 13))
                                else
                                  Text('The patient population risk levels are currently within expected distributions.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13))
                              ],
                            ),
                          ).animate().slideY(begin: 0.2, delay: 600.ms).fade(delay: 600.ms),
                        ],
                      ),
                    ),
        ),
      ),
    );
  }
}

class _Legend extends StatelessWidget {
  final String label;
  final Color color;
  const _Legend(this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(width: 14, height: 14, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 8),
        Text(label, style: GoogleFonts.poppins(color: Colors.white, fontSize: 13)),
      ],
    );
  }
}
