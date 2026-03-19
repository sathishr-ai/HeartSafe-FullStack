import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/followup_result.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../widgets/animated_bg.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';

class FollowupScreen extends StatefulWidget {
  const FollowupScreen({super.key});

  @override
  State<FollowupScreen> createState() => _FollowupScreenState();
}

class _FollowupScreenState extends State<FollowupScreen> {
  List<FollowupResult> _followups = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchFollowups();
  }

  Future<void> _fetchFollowups() async {
    setState(() => _isLoading = true);
    try {
      final list = await ApiService.instance.getFollowups();
      if (mounted) setState(() => _followups = list);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading follow-ups: $e'), backgroundColor: AppColors.danger),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showAddDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const _AddFollowupSheet(),
    ).then((added) {
      if (added == true) _fetchFollowups();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text('Follow-Ups', style: GoogleFonts.poppins(fontWeight: FontWeight.w600, color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: AppColors.cyan,
        child: const Icon(Icons.add, color: Colors.white),
      ).animate().scale(delay: 600.ms, curve: Curves.elasticOut),
      body: AnimatedBackground(
        child: SafeArea(
          child: _isLoading
              ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
              : _followups.isEmpty
                  ? Center(
                      child: Text('No follow-ups scheduled yet.',
                          style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 16)),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
                      itemCount: _followups.length,
                      itemBuilder: (context, index) {
                        final fu = _followups[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: Dismissible(
                            key: Key(fu.id),
                            direction: DismissDirection.endToStart,
                            background: Container(
                              alignment: Alignment.centerRight,
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              decoration: BoxDecoration(
                                color: AppColors.danger,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: const Icon(Icons.delete, color: Colors.white),
                            ),
                            confirmDismiss: (direction) async {
                              return await showDialog(
                                context: context,
                                builder: (ctx) => AlertDialog(
                                  backgroundColor: AppColors.bgCard,
                                  title: Text('Delete Follow-up', style: GoogleFonts.poppins(color: Colors.white)),
                                  content: Text('Are you sure you want to delete this record?', style: GoogleFonts.poppins(color: AppColors.textSecondary)),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, false),
                                      child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white)),
                                    ),
                                    TextButton(
                                      onPressed: () => Navigator.pop(ctx, true),
                                      child: Text('Delete', style: GoogleFonts.poppins(color: AppColors.danger)),
                                    ),
                                  ],
                                ),
                              );
                            },
                            onDismissed: (direction) async {
                              try {
                                await ApiService.instance.deleteFollowup(fu.id);
                                setState(() {
                                  _followups.removeAt(index);
                                });
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Follow-up deleted successfully'), backgroundColor: AppColors.success),
                                  );
                                }
                              } catch (e) {
                                _fetchFollowups(); // Reload if failed
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger),
                                  );
                                }
                              }
                            },
                            child: GlassCard(
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        fu.patientName.isNotEmpty ? fu.patientName : 'Patient ${fu.patientId.isNotEmpty ? fu.patientId.substring(0, minTextOrEnd(fu.patientId, 5)) : "Unknown"}',
                                        style: GoogleFonts.poppins(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.white),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: _getRiskColor(fu.riskLevel).withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        child: Text(
                                          fu.riskLevel ?? 'Unknown',
                                          style: GoogleFonts.poppins(color: _getRiskColor(fu.riskLevel), fontSize: 12, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 12),
                                  Row(
                                    children: [
                                      const Icon(Icons.calendar_today, size: 14, color: AppColors.cyan),
                                      const SizedBox(width: 8),
                                      Text(fu.date, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
                                      const SizedBox(width: 16),
                                      if (fu.time != null) ...[
                                        const Icon(Icons.access_time, size: 14, color: AppColors.cyan),
                                        const SizedBox(width: 8),
                                        Text(fu.time!, style: GoogleFonts.poppins(color: AppColors.textSecondary, fontSize: 13)),
                                      ]
                                    ],
                                  ),
                                  if (fu.notes != null && fu.notes!.isNotEmpty) ...[
                                    const SizedBox(height: 12),
                                    Text(fu.notes!, style: GoogleFonts.poppins(color: AppColors.textMuted, fontSize: 13)),
                                  ]
                                ],
                              ),
                            ),
                          ),
                        ),
                      ).animate().fade(delay: (100 * index).ms).slideY(begin: 0.1);
                    },
                  ),
        ),
      ),
    );
  }

  Color _getRiskColor(String? level) {
    if (level == null) return AppColors.textSecondary;
    if (level.toLowerCase().contains('high')) return AppColors.danger;
    if (level.toLowerCase().contains('moderate')) return AppColors.warning;
    return AppColors.success;
  }
  
  int minTextOrEnd(String text, int length) => text.length < length ? text.length : length;
}

// ── Add Followup Bottom Sheet ────────────────────────────────────────────────

class _AddFollowupSheet extends StatefulWidget {
  const _AddFollowupSheet();

  @override
  State<_AddFollowupSheet> createState() => _AddFollowupSheetState();
}

class _AddFollowupSheetState extends State<_AddFollowupSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _dateCtrl = TextEditingController();
  final _timeCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();
  String _riskLevel = 'Low';
  bool _submitting = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _submitting = true);
    try {
      await ApiService.instance.scheduleFollowup({
        'patientId': DateTime.now().millisecondsSinceEpoch.toString(), // Mock ID for demo
        'patientName': _nameCtrl.text.trim(),
        'date': _dateCtrl.text.trim(),
        'time': _timeCtrl.text.trim(),
        'notes': _notesCtrl.text.trim(),
        'riskLevel': _riskLevel,
      });
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString()), backgroundColor: AppColors.danger));
        setState(() => _submitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 24, right: 24, top: 24,
      ),
      decoration: const BoxDecoration(
        color: AppColors.bgDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Schedule Follow-Up', style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
              const SizedBox(height: 20),
              TextFormField(
                controller: _nameCtrl,
                style: const TextStyle(color: Colors.white),
                decoration: _inputDecoration('Patient Name', Icons.person),
                validator: (val) => val == null || val.isEmpty ? 'Required' : null,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _dateCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('YYYY-MM-DD', Icons.calendar_today),
                      validator: (val) => val == null || val.isEmpty ? 'Required' : null,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _timeCtrl,
                      style: const TextStyle(color: Colors.white),
                      decoration: _inputDecoration('HH:MM', Icons.access_time),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: _riskLevel,
                dropdownColor: AppColors.bgDark,
                style: GoogleFonts.poppins(color: Colors.white),
                decoration: _inputDecoration('Risk Level', Icons.warning_amber),
                items: ['Low', 'Moderate', 'High']
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (val) => setState(() => _riskLevel = val!),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesCtrl,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: _inputDecoration('Notes (Optional)', Icons.note),
              ),
              const SizedBox(height: 24),
              _submitting
                  ? const Center(child: CircularProgressIndicator(color: AppColors.cyan))
                  : GradientButton(text: 'Schedule Now', onPressed: _submit),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: AppColors.textMuted),
      prefixIcon: Icon(icon, color: AppColors.textMuted),
      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.white24)),
      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.cyan)),
      filled: true,
      fillColor: Colors.white10,
    );
  }
}
