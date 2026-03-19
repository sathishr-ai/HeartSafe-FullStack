// ─────────────────────────────────────────────────────────────────────────────
// login_screen.dart – Premium glassmorphism login UI
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import '../widgets/pulse_icon.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _loading = false;
  bool _obscure = true;
  bool _isSignUp = false; // Toggle between Login and Sign Up
  String _selectedRole = 'nurse';
  String? _error;

  @override
  void dispose() {
    _usernameCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ApiService.instance.login(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ApiService.instance.register(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
        _selectedRole,
      );
      // Auto-login after successful registration
      await ApiService.instance.login(
        _usernameCtrl.text.trim(),
        _passwordCtrl.text,
      );
      if (mounted) Navigator.pushReplacementNamed(context, '/home');
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: AppColors.bgDark,
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF1E293B), // Lighter Slate
              Color(0xFF0F172A), // Dark Slate
              Color(0xFF020617), // Deepest Slate
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  // ── Pulsing Logo ─────────────────────────────────────────
                  const PulseIcon(size: 96)
                      .animate()
                      .scale(
                        begin: const Offset(0, 0),
                        duration: 600.ms,
                        curve: Curves.elasticOut,
                      )
                      .fade(duration: 400.ms),

                  const SizedBox(height: 24),

                  Text('HeartSafe',
                      style: GoogleFonts.poppins(
                        fontSize: 34,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                        letterSpacing: 1.5,
                      ))
                      .animate()
                      .slideY(begin: 0.3, duration: 500.ms, delay: 200.ms)
                      .fade(duration: 500.ms, delay: 200.ms),

                  const SizedBox(height: 4),
                  Text('CHD Risk Prediction System',
                      style: GoogleFonts.poppins(
                        fontSize: 13,
                        color: AppColors.cyan,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 0.8,
                      ))
                      .animate()
                      .fade(duration: 500.ms, delay: 350.ms),

                  const SizedBox(height: 44),

                  // ── Glass Card ────────────────────────────────────────────
                  GlassCard(
                    glowColor: AppColors.indigo,
                    padding: const EdgeInsets.all(28),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(_isSignUp ? 'Join HeartSafe' : 'Welcome back',
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                                color: AppColors.textPrimary,
                              )),
                          const SizedBox(height: 4),
                          Text(_isSignUp ? 'Create an account to continue' : 'Sign in to continue',
                              style: GoogleFonts.poppins(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              )),
                          const SizedBox(height: 28),

                          // Username
                          _buildLabel('Username'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _usernameCtrl,
                            style: GoogleFonts.poppins(
                                color: AppColors.textPrimary),
                            validator: (v) =>
                                (v?.isEmpty ?? true) ? 'Required' : null,
                            decoration: premiumInputDecoration(
                              hint: 'e.g. Sathish',
                              icon: Icons.person_outline,
                            ),
                          ),
                          const SizedBox(height: 18),

                          // Password
                          _buildLabel('Password'),
                          const SizedBox(height: 8),
                          TextFormField(
                            controller: _passwordCtrl,
                            obscureText: _obscure,
                            style: GoogleFonts.poppins(
                                color: AppColors.textPrimary),
                            validator: (v) =>
                                (v?.isEmpty ?? true) ? 'Required' : null,
                            decoration: premiumInputDecoration(
                              hint: '••••••••',
                              icon: Icons.lock_outline,
                            ).copyWith(
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscure
                                      ? Icons.visibility_off_outlined
                                      : Icons.visibility_outlined,
                                  color: AppColors.textMuted,
                                  size: 20,
                                ),
                                onPressed: () =>
                                    setState(() => _obscure = !_obscure),
                              ),
                            ),
                          ),

                          if (_error != null) ...[
                            const SizedBox(height: 16),
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.danger.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: AppColors.danger
                                        .withValues(alpha: 0.35)),
                              ),
                              child: Row(
                                children: [
                                  const Icon(Icons.error_outline,
                                      color: Color(0xFFEF9A9A), size: 18),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: Text(
                                      _error!,
                                      style: GoogleFonts.poppins(
                                        fontSize: 12,
                                        color: const Color(0xFFEF9A9A),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],

                          const SizedBox(height: 28),

                          // Role selection (only shown during Sign Up)
                          if (_isSignUp) ...[
                            _buildLabel('Role'),
                            const SizedBox(height: 8),
                            DropdownButtonFormField<String>(
                              value: _selectedRole,
                              dropdownColor: const Color(0xFF1E293B), // Dark slate
                              style: GoogleFonts.poppins(color: AppColors.textPrimary),
                              decoration: premiumInputDecoration(
                                hint: 'Select a role',
                                icon: Icons.badge_outlined,
                              ),
                              items: const [
                                DropdownMenuItem(value: 'doctor', child: Text('Doctor')),
                                DropdownMenuItem(value: 'nurse', child: Text('Nurse')),
                                DropdownMenuItem(value: 'admin', child: Text('Administrator')),
                              ],
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedRole = newValue!;
                                });
                              },
                            ),
                            const SizedBox(height: 18),
                          ],

                          // Sign in / Sign Up button
                          GradientButton(
                            text: _isSignUp ? 'Create Account' : 'Sign In',
                            icon: _isSignUp ? Icons.person_add_outlined : Icons.login_rounded,
                            loading: _loading,
                            onPressed: _loading ? null : (_isSignUp ? _register : _login),
                          ),

                          const SizedBox(height: 24),
                          
                          // Toggle Login / Sign Up
                          Center(
                            child: TextButton(
                              onPressed: () {
                                setState(() {
                                  _isSignUp = !_isSignUp;
                                  _error = null;
                                  _formKey.currentState?.reset();
                                  _usernameCtrl.clear();
                                  _passwordCtrl.clear();
                                });
                              },
                              style: TextButton.styleFrom(
                                foregroundColor: AppColors.cyan,
                              ),
                              child: Text(
                                _isSignUp 
                                    ? 'Already have an account? Sign In' 
                                    : 'Don\'t have an account? Create one',
                                style: GoogleFonts.poppins(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                      .animate()
                      .slideY(
                          begin: 0.2,
                          duration: 600.ms,
                          delay: 300.ms)
                      .fade(duration: 600.ms, delay: 300.ms),

                  const SizedBox(height: 36),
                  Text('HeartSafe v1.0.0',
                      style: GoogleFonts.poppins(
                          fontSize: 11, color: AppColors.textMuted)),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Text(
        text,
        style: GoogleFonts.poppins(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
      );
}
