const express = require('express');
const router = express.Router();
const Followup = require('../models/Followup');


// ✅ CREATE FOLLOWUP
router.post('/schedule', async (req, res) => {
  try {

    const { patientId, patientName, date, time, notes, riskLevel } = req.body;  // ✅ ADD patientId

    if (!patientId || !date) {   // ✅ Check patientId instead
      return res.status(400).json({
        success: false,
        message: 'Patient ID and followup date are required'
      });
    }

    const followup = new Followup({
      patientId,     // ✅ ADD THIS
      patientName,
      date,
      time,
      notes,
      riskLevel
    });

    const savedFollowup = await followup.save();

    res.status(201).json({
      success: true,
      message: 'Followup scheduled successfully',
      data: savedFollowup
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});


// ✅ GET ALL FOLLOWUPS
router.get('/list', async (req, res) => {
  try {
    const followups = await Followup.find();

    res.status(200).json({
      success: true,
      data: followups
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});


// ✅ UPDATE FOLLOWUP
router.put('/:id', async (req, res) => {
  try {
    const updatedFollowup = await Followup.findByIdAndUpdate(
      req.params.id,
      req.body,
      { new: true }
    );

    if (!updatedFollowup) {
      return res.status(404).json({
        success: false,
        message: 'Followup not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Followup updated successfully',
      data: updatedFollowup
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});


// ✅ DELETE FOLLOWUP
router.delete('/:id', async (req, res) => {
  try {
    const deletedFollowup = await Followup.findByIdAndDelete(req.params.id);

    if (!deletedFollowup) {
      return res.status(404).json({
        success: false,
        message: 'Followup not found'
      });
    }

    res.status(200).json({
      success: true,
      message: 'Followup deleted successfully',
      data: deletedFollowup
    });

  } catch (error) {
    res.status(500).json({
      success: false,
      message: error.message
    });
  }
});

module.exports = router;
