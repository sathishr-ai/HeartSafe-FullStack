import '../models/patient_data.dart';
import '../models/prediction_result.dart';

class AdvisoryService {
  /// Generates the 4-quadrant detailed medical advisory based on the patient's
  /// raw biometrics and their computed CHD risk score.
  static Map<String, dynamic> generateAdvisory(
      PatientData patient, PredictionResult result) {
    
    final bool isHigh = result.riskLevel.toLowerCase() == 'high';
    final bool isModerate = result.riskLevel.toLowerCase() == 'moderate';
    
    List<String> immediateActions = [];
    List<String> lifestyle = [];
    List<String> medications = [];
    List<String> monitoring = [];

    // --- 1. Immediate Actions ---
    if (isHigh) {
      immediateActions.add('CARDIOLOGY REFERRAL: Schedule within 1-2 weeks for comprehensive evaluation.');
      if (patient.systolic >= 160 || patient.diastolic >= 100) {
        immediateActions.add('BLOOD PRESSURE: Immediate intervention required. BP is dangerously high (${patient.systolic}/${patient.diastolic}).');
      }
      if (patient.totalChol > 240) {
        immediateActions.add('LIPID MANAGEMENT: Start high-intensity statin therapy (target LDL < 70 mg/dL).');
      }
    } else if (isModerate && (patient.systolic >= 140 || patient.diastolic >= 90)) {
      immediateActions.add('MEDICAL REVIEW: Schedule appointment within 1 month to review hypertension.');
    }

    // --- 2. Lifestyle Intervention Plan ---
    if (patient.smoking.toLowerCase() == 'yes') {
      lifestyle.add('SMOKING CESSATION: Absolute priority. Join a cessation program; consider nicotine replacement.');
    }
    lifestyle.add('DIET: Adopt Mediterranean or DASH diet; reduce sodium to <1,500mg/day.');
    lifestyle.add('EXERCISE: 30-60 minutes of moderate aerobic activity daily (min 150 mins/week).');
    
    if (isHigh || isModerate) {
      lifestyle.add('WEIGHT: Target BMI < 25; maintain strict waist circumference goals.');
      lifestyle.add('STRESS: Daily mindfulness practice; evaluate for sleep apnea.');
    }

    // --- 3. Medication Recommendations ---
    if (patient.totalChol >= 240 || isHigh) {
      medications.add('STATIN THERAPY: Evaluate for moderate to high-intensity statins (e.g., Atorvastatin).');
    }
    if (patient.systolic >= 140 || patient.diastolic >= 90) {
      medications.add('ANTIHYPERTENSIVE: Consider ACE inhibitor, ARB, or calcium channel blocker base therapy.');
    }
    if (patient.diabetes.toLowerCase() == 'yes') {
      medications.add('GLYCEMIC CONTROL: Optimize metformin or SGLT2 inhibitors; strict HbA1c monitoring.');
    }
    if (isHigh) {
      medications.add('ANTIPLATELET: Consider Aspirin 75-100mg daily if bleeding risk is low.');
    }
    
    if (medications.isEmpty) {
      medications.add('MAINTENANCE: No new aggressive pharmaceutical interventions strictly required at this baseline.');
    }

    // --- 4. Monitoring & Follow-up ---
    if (isHigh) {
      monitoring.add('WEEKLY: Home BP monitoring. Record all readings.');
      monitoring.add('1 MONTH: Follow-up on medication tolerance and BP goals.');
      monitoring.add('3 MONTHS: Full lipid profile, renal function, and liver enzymes.');
      monitoring.add('EMERGENCY: Report chest pain, shortness of breath, or palpitations immediately.');
    } else if (isModerate) {
      monitoring.add('MONTHLY: Home BP monitoring and weight checks.');
      monitoring.add('6 MONTHS: Cardiology follow-up and repeat lipid panel.');
      monitoring.add('ANNUALLY: Comprehensive cardiovascular reassessment.');
    } else {
      monitoring.add('ANNUALLY: Routine health check-up, lipid profile, and fasting glucose.');
      monitoring.add('ONGOING: Maintain healthy habits and self-monitor for any new symptoms.');
    }

    return {
      'immediate_actions': immediateActions,
      'lifestyle': lifestyle,
      'medications': medications,
      'monitoring': monitoring,
    };
  }
}
