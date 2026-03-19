// ─────────────────────────────────────────────────────────────────────────────
// home_screen.dart – Premium landing / navigation hub
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/prediction_result.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/health_gauge.dart';
import '../widgets/pulse_icon.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _username = '';
  bool _serverOnline = false;
  List<PredictionResult> _history = [];
  bool _isLoadingHistory = true;

  @override
  void initState() {
    super.initState();
    _loadUser();
    _checkServer();
    _fetchHistory();
  }

  Future<void> _fetchHistory() async {
    try {
      final history = await ApiService.instance.getHistory();
      if (mounted) {
        setState(() {
          _history = history.take(4).toList(); // Show top 4 recent
          _isLoadingHistory = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingHistory = false;
        });
      }
    }
  }

  Future<void> _loadUser() async {
    final name = await ApiService.instance.getUsername();
    if (mounted) setState(() => _username = name ?? 'User');
  }

  Future<void> _checkServer() async {
    final ok = await ApiService.instance.healthCheck();
    if (mounted) setState(() => _serverOnline = ok);
  }

  Future<void> _logout() async {
    await ApiService.instance.logout();
    if (mounted) Navigator.pushReplacementNamed(context, '/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            children: [
              // ── Top bar ──────────────────────────────────────────────
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: AppColors.heroGradient,
                      boxShadow: AppDecorations.glowShadow(AppColors.indigoDeep, blur: 12),
                    ),
                    child: CircleAvatar(
                      radius: 20,
                      backgroundColor: AppColors.bgDark,
                      child: Text(
                        _username.isNotEmpty ? _username[0].toUpperCase() : 'U',
                        style: GoogleFonts.poppins(
                          color: AppColors.cyan,
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('HeartSafe',
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w700,
                              fontSize: 18,
                              color: AppColors.textPrimary,
                            )),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: _serverOnline
                                    ? AppColors.success
                                    : AppColors.danger,
                                boxShadow: [
                                  BoxShadow(
                                    color: (_serverOnline
                                            ? AppColors.success
                                            : AppColors.danger)
                                        .withValues(alpha: 0.5),
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              _serverOnline
                                  ? 'Server Online'
                                  : 'Server Offline',
                              style: GoogleFonts.poppins(
                                fontSize: 11,
                                color: _serverOnline
                                    ? AppColors.success
                                    : const Color(0xFFEF9A9A),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Spacer(),
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.06),
                      ),
                      child: IconButton(
                        onPressed: _logout,
                        icon: const Icon(Icons.logout_rounded,
                            color: AppColors.textSecondary, size: 20),
                        tooltip: 'Logout',
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 40),

                // ── Greeting ──────────────────────────────────────────────
                Text('Hello, $_username! 👋',
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    ))
                    .animate()
                    .slideX(begin: -0.2, duration: 500.ms)
                    .fade(duration: 500.ms),

                const SizedBox(height: 8),

                Text(
                    'Assess your patient\'s coronary heart\ndisease risk in seconds.',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      height: 1.5,
                    ))
                    .animate()
                    .fade(duration: 500.ms, delay: 150.ms),

                const SizedBox(height: 36),

                // ── Hero card with Health Gauge ─────────────────────────────
                GlassCard(
                  glowColor: AppColors.indigo,
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('Latest Risk Assessment',
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: AppColors.textSecondary,
                          )),
                      const SizedBox(height: 24),
                      HealthGauge(
                        score: _history.isNotEmpty ? _history.first.riskScore.toDouble() : 0.0,
                        riskLevel: _history.isNotEmpty ? _history.first.riskLevel : 'Unknown',
                        isLoading: _isLoadingHistory,
                      ),
                      const SizedBox(height: 32),
                      SizedBox(
                        width: double.infinity,
                        child: GradientButton(
                          text: 'Run New Test',
                          icon: Icons.add_circle_outline,
                          onPressed: () => Navigator.pushNamed(context, '/predict'),
                        ),
                      )
                    ],
                  ),
                )
                    .animate()
                    .slideY(begin: 0.2, duration: 600.ms, delay: 200.ms)
                    .fade(duration: 600.ms, delay: 200.ms),

                const SizedBox(height: 20),

                // ── Info tiles ──────────────────────────────────────────────
                Row(
                  children: [
                    _InfoTile(
                        icon: Icons.speed,
                        title: 'Instant',
                        subtitle: 'Results'),
                    const SizedBox(width: 12),
                    _InfoTile(
                        icon: Icons.shield_outlined,
                        title: 'Accurate',
                        subtitle: 'Scoring'),
                    const SizedBox(width: 12),
                    _InfoTile(
                        icon: Icons.insights,
                        title: '3-Level',
                        subtitle: 'Risk Grade'),
                  ],
                )
                    .animate()
                    .fade(duration: 500.ms, delay: 400.ms)
                    .slideY(begin: 0.1, delay: 400.ms, duration: 500.ms),

                const SizedBox(height: 24),

                // ── Manage Follow-Ups ──────────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/followup'),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.indigo.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.calendar_month, color: AppColors.indigo, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Text('Manage Follow-Ups', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white54),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.1, delay: 450.ms).fade(delay: 450.ms),

                const SizedBox(height: 16),

                // ── Population Analytics ───────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.pushNamed(context, '/analytics'),
                  child: GlassCard(
                    padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.warning.withValues(alpha: 0.15),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.pie_chart_rounded, color: AppColors.warning, size: 24),
                            ),
                            const SizedBox(width: 16),
                            Text('Population Analytics', style: GoogleFonts.poppins(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        const Icon(Icons.chevron_right, color: Colors.white54),
                      ],
                    ),
                  ),
                ).animate().slideY(begin: 0.1, delay: 500.ms).fade(delay: 500.ms),

                const SizedBox(height: 36),

                // ── Recent Assessments History ─────────────────────────────
                Text('Recent Assessments',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.textPrimary,
                    )).animate().fade(delay: 500.ms),
                const SizedBox(height: 16),
                _isLoadingHistory 
                   ? const Padding(
                       padding: EdgeInsets.all(32.0),
                       child: Center(child: CircularProgressIndicator(color: AppColors.cyan)),
                     )
                   : _history.isEmpty 
                     ? Padding(
                         padding: const EdgeInsets.all(24.0),
                         child: Center(
                           child: Text(
                             'No recent assessments found.',
                             style: GoogleFonts.poppins(color: AppColors.textMuted),
                           ),
                         ),
                       )
                     : Column(
                         children: _history.map((res) => _HistoryCard(res)).toList(),
                       ).animate().fade(duration: 500.ms).slideY(begin: 0.05, duration: 500.ms),
              ],
            ),
          ),
        ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final PredictionResult result;
  const _HistoryCard(this.result);
  
  @override
  Widget build(BuildContext context) {
    Color getRiskColor(String level) {
      if (level == 'High') return AppColors.danger;
      if (level == 'Moderate') return AppColors.warning;
      return AppColors.success;
    }
    
    final color = getRiskColor(result.riskLevel);
    
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassCard(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                shape: BoxShape.circle,
                border: Border.all(color: color.withValues(alpha: 0.3)),
              ),
              child: Text(
                '${result.riskScore}%',
                style: GoogleFonts.poppins(
                  color: color,
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${result.riskLevel} Risk',
                    style: GoogleFonts.poppins(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    result.date != null 
                        ? '${result.date!.day}/${result.date!.month}/${result.date!.year}'
                        : 'Recent test',
                    style: GoogleFonts.poppins(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: AppColors.textMuted),
          ],
        ),
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile(
      {required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GlassCard(
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
        borderRadius: 18,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.cyan.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: AppColors.cyan, size: 22),
            ),
            const SizedBox(height: 10),
            Text(title,
                style: GoogleFonts.poppins(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                )),
            Text(subtitle,
                style: GoogleFonts.poppins(
                  color: AppColors.textMuted,
                  fontSize: 11,
                )),
          ],
        ),
      ),
    );
  }
}
