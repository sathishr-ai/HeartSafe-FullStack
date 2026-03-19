// ─────────────────────────────────────────────────────────────────────────────
// prediction_screen.dart – Premium patient input form
// ─────────────────────────────────────────────────────────────────────────────

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:csv/csv.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';

import '../models/patient_data.dart';
import '../services/api_service.dart';
import '../utils/app_theme.dart';
import '../utils/validators.dart';
import '../widgets/animated_bg.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_button.dart';
import 'result_screen.dart';
import 'batch_result_screen.dart';

class PredictionScreen extends StatefulWidget {
  const PredictionScreen({super.key});

  @override
  State<PredictionScreen> createState() => _PredictionScreenState();
}

class _PredictionScreenState extends State<PredictionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  final _ageCtrl       = TextEditingController();
  final _totalCholCtrl = TextEditingController();
  final _hdlCtrl       = TextEditingController();
  final _systolicCtrl  = TextEditingController();
  final _diastolicCtrl = TextEditingController();

  // Dropdowns
  String _gender   = 'male';
  String _smoking  = 'no';
  String _diabetes = 'no';
  String _family   = 'no';

  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _ageCtrl.dispose();
    _totalCholCtrl.dispose();
    _hdlCtrl.dispose();
    _systolicCtrl.dispose();
    _diastolicCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final patient = PatientData(
        age: int.parse(_ageCtrl.text),
        gender: _gender,
        totalChol: double.parse(_totalCholCtrl.text),
        hdl: double.parse(_hdlCtrl.text),
        systolic: int.parse(_systolicCtrl.text),
        diastolic: int.parse(_diastolicCtrl.text),
        smoking: _smoking,
        diabetes: _diabetes,
        family: _family,
      );

      final result = await ApiService.instance.predict(patient);

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ResultScreen(result: result, patient: patient),
          ),
        );
      }
    } on ApiException catch (e) {
      setState(() => _error = e.message);
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _pickAndUploadCSV() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['csv'],
      );

      if (result != null && result.files.single.path != null) {
        final file = File(result.files.single.path!);
        final csvString = await file.readAsString();
        final rows = CsvCodec().decode(csvString);

        if (rows.length < 2) {
          throw Exception('CSV file is empty or missing data rows');
        }

        final headers = rows.first.map((e) => e.toString().toLowerCase().trim()).toList();
        final List<Map<String, dynamic>> patients = [];

        for (int i = 1; i < rows.length; i++) {
          final row = rows[i];
          if (row.isEmpty || row.length < headers.length) continue;
          
          final Map<String, dynamic> patientMap = {};
          for (int j = 0; j < headers.length; j++) {
            patientMap[headers[j]] = row[j];
          }
          patients.add(patientMap);
        }

        if (mounted) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BatchResultScreen(batchData: patients),
            ),
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to read CSV: $e'),
          backgroundColor: AppColors.danger,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          scrolledUnderElevation: 0,
          leading: const BackButton(color: AppColors.textSecondary),
          title: Text(
            'Risk Assessment',
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: AppColors.textPrimary,
            ),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDark,
                  AppColors.bgDark.withValues(alpha: 0.1),
                ],
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: AppColors.cyan,
            indicatorWeight: 3,
            labelColor: AppColors.cyan,
            unselectedLabelColor: AppColors.textMuted,
            labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 13),
            unselectedLabelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w500, fontSize: 13),
            tabs: const [
              Tab(text: 'Single Assessment'),
              Tab(text: 'Batch Dataset'),
            ],
          ),
        ),
        body: AnimatedBackground(
          child: SafeArea(
            bottom: false,
            child: TabBarView(
              children: [
                _buildSinglePatientForm(),
                _buildBatchUploadTab(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSinglePatientForm() {
    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
        children: [
          // ── Section: Personal Info ─────────────────────────────────
          const _SectionHeader(
              title: 'Personal Information', icon: Icons.person),
          const SizedBox(height: 14),

          GlassCard(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                CustomTextField(
                  label: 'Age',
                  hint: 'e.g. 45',
                  icon: Icons.cake_outlined,
                  controller: _ageCtrl,
                  keyboardType: TextInputType.number,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly
                  ],
                  validator: Validators.age,
                  suffixText: 'years',
                ),
                      const SizedBox(height: 16),
                      _buildLabel('Gender'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _gender,
                        icon: Icons.wc_outlined,
                        items: const [
                          DropdownMenuItem(
                              value: 'male', child: Text('Male')),
                          DropdownMenuItem(
                              value: 'female', child: Text('Female')),
                        ],
                        onChanged: (v) => setState(() => _gender = v!),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section: Cholesterol ───────────────────────────────────
                _SectionHeader(
                    title: 'Cholesterol Levels',
                    icon: Icons.science_outlined),
                const SizedBox(height: 14),

                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      CustomTextField(
                        label: 'Total Cholesterol',
                        hint: 'e.g. 200',
                        icon: Icons.water_drop_outlined,
                        controller: _totalCholCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: Validators.totalCholesterol,
                        suffixText: 'mg/dL',
                      ),
                      const SizedBox(height: 16),
                      CustomTextField(
                        label: 'HDL Cholesterol',
                        hint: 'e.g. 50',
                        icon: Icons.water_drop,
                        controller: _hdlCtrl,
                        keyboardType: const TextInputType.numberWithOptions(
                            decimal: true),
                        validator: Validators.hdl,
                        suffixText: 'mg/dL',
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section: Blood Pressure ────────────────────────────────
                _SectionHeader(
                    title: 'Blood Pressure',
                    icon: Icons.monitor_heart_outlined),
                const SizedBox(height: 14),

                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          label: 'Systolic',
                          hint: 'e.g. 120',
                          icon: Icons.arrow_upward,
                          controller: _systolicCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: Validators.systolic,
                          suffixText: 'mmHg',
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: CustomTextField(
                          label: 'Diastolic',
                          hint: 'e.g. 80',
                          icon: Icons.arrow_downward,
                          controller: _diastolicCtrl,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly
                          ],
                          validator: Validators.diastolic,
                          suffixText: 'mmHg',
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // ── Section: Risk Factors ──────────────────────────────────
                _SectionHeader(
                    title: 'Risk Factors',
                    icon: Icons.warning_amber_outlined),
                const SizedBox(height: 14),

                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildLabel('Smoking'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _smoking,
                        icon: Icons.smoking_rooms_outlined,
                        items: const [
                          DropdownMenuItem(value: 'no', child: Text('No')),
                          DropdownMenuItem(value: 'yes', child: Text('Yes')),
                        ],
                        onChanged: (v) => setState(() => _smoking = v!),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Diabetes'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _diabetes,
                        icon: Icons.bloodtype_outlined,
                        items: const [
                          DropdownMenuItem(value: 'no', child: Text('No')),
                          DropdownMenuItem(value: 'yes', child: Text('Yes')),
                        ],
                        onChanged: (v) => setState(() => _diabetes = v!),
                      ),
                      const SizedBox(height: 16),
                      _buildLabel('Family History of CHD'),
                      const SizedBox(height: 8),
                      _buildDropdown(
                        value: _family,
                        icon: Icons.family_restroom_outlined,
                        items: const [
                          DropdownMenuItem(value: 'no', child: Text('No')),
                          DropdownMenuItem(value: 'yes', child: Text('Yes')),
                        ],
                        onChanged: (v) => setState(() => _family = v!),
                      ),
                    ],
                  ),
                ),

                if (_error != null) ...[
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.danger.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.danger.withValues(alpha: 0.35)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline,
                            color: Color(0xFFEF9A9A), size: 20),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(_error!,
                              style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: const Color(0xFFEF9A9A))),
                        ),
                      ],
                    ),
                  ).animate().shake(),
                ],

                const SizedBox(height: 30),

                  GradientButton(
                    text: _loading ? 'Analysing...' : 'Predict CHD Risk',
                    icon: Icons.analytics_outlined,
                    loading: _loading,
                    onPressed: _loading ? null : _submit,
                  ),

                  const SizedBox(height: 24),
                ],
              ),
            );
  }

  Widget _buildBatchUploadTab() {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      children: [
        GlassCard(
          padding: const EdgeInsets.all(30),
          child: Column(
            children: [
              Icon(Icons.cloud_upload_outlined,
                  size: 64, color: AppColors.cyan.withValues(alpha: 0.8)),
              const SizedBox(height: 20),
              Text(
                'Upload Patient Dataset',
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Upload a CSV file containing patient data for batch prediction and automated preventive advisory generation.',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 13,
                  color: AppColors.textSecondary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                child: GradientButton(
                  text: 'Choose CSV File',
                  icon: Icons.description_outlined,
                  onPressed: _pickAndUploadCSV,
                ),
              ),
            ],
          ),
        ).animate().slideY(begin: 0.1, duration: 400.ms).fade(),
        
        const SizedBox(height: 20),
        
        // ── Download Template Button ────────────────────────────
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            onPressed: () {}, // To be implemented
            icon: const Icon(Icons.download_rounded, color: AppColors.indigo),
            label: Text(
              'Download CSV Template',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                color: AppColors.indigo,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.indigo.withValues(alpha: 0.15),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
                side: BorderSide(
                  color: AppColors.indigo.withValues(alpha: 0.5),
                  width: 1,
                ),
              ),
            ),
          ),
        ).animate().slideY(begin: 0.1, delay: 100.ms, duration: 400.ms).fade(),
      ],
    );
  }

  Widget _buildLabel(String text) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      );

  Widget _buildDropdown({
    required String value,
    required IconData icon,
    required List<DropdownMenuItem<String>> items,
    required void Function(String?) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      items: items,
      onChanged: onChanged,
      dropdownColor: AppColors.bgCard,
      style: GoogleFonts.poppins(color: AppColors.textPrimary, fontSize: 14),
      decoration: premiumInputDecoration(
        hint: '',
        icon: icon,
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final IconData icon;
  const _SectionHeader({required this.title, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.cyan.withValues(alpha: 0.2),
                AppColors.indigo.withValues(alpha: 0.15),
              ],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            )),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.cyan.withValues(alpha: 0.3),
                  Colors.transparent,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
