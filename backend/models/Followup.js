const mongoose = require('mongoose');

const followupSchema = new mongoose.Schema({
  patientId: { type: Number, required: true },
  patientName: { type: String },
  date: { type: String, required: true },
  time: { type: String, default: '10:00' },
  notes: { type: String, default: '' },
  riskLevel: { type: String, default: 'High' },
  status: { type: String, default: 'scheduled' },
  createdAt: { type: Date, default: Date.now }
});

module.exports = mongoose.model('Followup', followupSchema);
