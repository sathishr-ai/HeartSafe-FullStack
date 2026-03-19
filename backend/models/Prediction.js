const mongoose = require('mongoose');

const predictionSchema = new mongoose.Schema({
  age: Number,
  gender: String,
  totalChol: Number,
  hdl: Number,
  systolic: Number,
  diastolic: Number,
  smoking: String,
  diabetes: String,
  family: String,
  riskScore: Number,
  riskLevel: String,
  createdAt: {
    type: Date,
    default: Date.now
  }
});

module.exports = mongoose.model('Prediction', predictionSchema);
