const Prediction = require('../models/Prediction');

const express = require('express');
const router = express.Router();

// CHD Risk calculation logic
function calculateCHDRisk(patientData) {
  const { age, gender, totalChol, hdl, systolic, diastolic, smoking, diabetes, family } = patientData;

  let riskScore = 0;

  // Age risk factors
  if (age < 40) riskScore += 5;
  else if (age < 50) riskScore += 15;
  else if (age < 60) riskScore += 30;
  else if (age < 70) riskScore += 45;
  else riskScore += 55;

  // Gender risk
  riskScore += (gender === 'male' || gender === 'Male') ? 15 : 8;

  // Cholesterol ratio risk
  const cholRatio = totalChol / hdl;
  if (cholRatio > 6) riskScore += 35;
  else if (cholRatio > 5) riskScore += 25;
  else if (cholRatio > 4) riskScore += 15;
  else if (cholRatio > 3.5) riskScore += 10;

  // Blood pressure risk
  if (systolic >= 160 || diastolic >= 100) riskScore += 35;
  else if (systolic >= 140 || diastolic >= 90) riskScore += 25;
  else if (systolic >= 130 || diastolic >= 85) riskScore += 15;

  // Lifestyle factors
  riskScore += (smoking === 'yes' || smoking === 'Yes') ? 30 : 0;
  riskScore += (diabetes === 'yes' || diabetes === 'Yes') ? 28 : 0;
  riskScore += (family === 'yes' || family === 'Yes') ? 20 : 0;

  // Convert to probability (logistic curve)
  const probability = 1 / (1 + Math.exp(-(riskScore - 70) / 12));
  const riskPercentage = Math.round(probability * 100);

  return {
    riskScore: Math.min(100, Math.max(0, riskPercentage)),
    riskLevel: riskPercentage > 70 ? 'High' : riskPercentage > 40 ? 'Moderate' : 'Low'
  };
}

// Single patient risk prediction
router.post('/single', async (req, res) => {
  try {
    const patientData = req.body;

    if (!patientData.age || patientData.totalChol === undefined) {
      return res.status(400).json({
        success: false,
        message: 'Missing required patient data'
      });
    }

    const prediction = calculateCHDRisk(patientData);

    // Create new prediction and save it
    const newPrediction = new Prediction({
      ...patientData,
      patientName: patientData.patientName || 'Unknown Patient',
      riskScore: prediction.riskScore,
      riskLevel: prediction.riskLevel
    });

    await newPrediction.save();

    res.status(200).json({
      success: true,
      message: 'Risk prediction calculated',
      data: {
        ...patientData,
        riskScore: prediction.riskScore,
        riskLevel: prediction.riskLevel
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error calculating risk prediction: ' + error.message
    });
  }
});

// Batch prediction (SAVE TO DATABASE)
router.post('/batch', async (req, res) => {
  try {
    const { patients } = req.body;

    if (!Array.isArray(patients)) {
      console.error('❌ Batch prediction failed: patients data is not an array');
      return res.status(400).json({
        success: false,
        message: 'Patients data must be an array'
      });
    }

    console.log(`📊 Processing batch prediction for ${patients.length} patients...`);

    const savedPredictions = [];

    for (let i = 0; i < patients.length; i++) {
      const patient = patients[i];

      // Calculate risk
      const prediction = calculateCHDRisk(patient);

      // Create MongoDB document
      const newPrediction = new Prediction({
        ...patient,
        patientName: patient.patientName || `Patient ${i + 1}`,
        riskScore: prediction.riskScore,
        riskLevel: prediction.riskLevel
      });

      // SAVE TO MONGODB ⭐
      const savedDoc = await newPrediction.save();
      console.log(`  ✓ Saved prediction ${i + 1}/${patients.length} - ID: ${savedDoc._id}`);

      savedPredictions.push(savedDoc);
    }

    console.log(`✅ Batch prediction completed: ${savedPredictions.length} predictions saved to MongoDB`);

    res.status(200).json({
      success: true,
      message: `Batch predictions saved successfully (${savedPredictions.length} records)`,
      data: savedPredictions
    });

  } catch (error) {
    console.error('❌ Batch prediction error:', error.message);
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

// Get list of predictions
router.get('/list', async (req, res) => {
  try {
    const predictions = await Prediction.find();

    res.status(200).json({
      success: true,
      data: predictions
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router;