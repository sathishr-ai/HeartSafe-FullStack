const authMiddleware = require('../middleware/authMiddleware');
const Report = require('../models/Report');
const express = require('express');
const router = express.Router();

// Export as PDF
router.post('/pdf', authMiddleware, async (req, res) => {
  try {
    const { predictions, patientName } = req.body;
    const filename = `CHD_Risk_Report_${patientName || 'Patient'}_${Date.now()}.pdf`;

    // Save report metadata to MongoDB
    const report = await Report.create({
      reportType: 'PDF',
      filename,
      patientName: patientName || 'Unknown Patient',
      predictions: predictions || [],
      generatedBy: req.user?.username || 'System'
    });

    res.status(200).json({
      success: true,
      message: 'PDF report generated successfully',
      data: {
        reportId: report._id,
        filename,
        status: 'generated'
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error generating PDF: ' + error.message
    });
  }
});

// Export as CSV
router.post('/csv', authMiddleware, async (req, res) => {
  try {
    const { predictions } = req.body;

    if (!Array.isArray(predictions)) {
      return res.status(400).json({
        success: false,
        message: 'Predictions data must be an array'
      });
    }

    // Convert predictions to CSV format
    const headers = ['ID', 'Age', 'Gender', 'Total Chol', 'HDL', 'Systolic BP', 'Diastolic BP', 'Smoking', 'Diabetes', 'Family History', 'Risk Score', 'Risk Level'];
    const rows = predictions.map(p => [
      p.id,
      p.age,
      p.gender,
      p.totalChol,
      p.hdl,
      p.systolic,
      p.diastolic,
      p.smoking,
      p.diabetes,
      p.family,
      p.riskScore,
      p.riskLevel
    ]);

    const filename = `CHD_Risk_Report_${Date.now()}.csv`;

    // Save report metadata to MongoDB
    const report = await Report.create({
      reportType: 'CSV',
      filename,
      patientName: 'Batch Export',
      predictions,
      generatedBy: req.user?.username || 'System'
    });

    res.status(200).json({
      success: true,
      message: 'CSV report generated successfully',
      data: {
        reportId: report._id,
        filename,
        headers,
        rows,
        status: 'generated'
      }
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Error generating CSV: ' + error.message
    });
  }
});

module.exports = router;
