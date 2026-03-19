const mongoose = require('mongoose');

const reportSchema = new mongoose.Schema({
    reportType: {
        type: String,
        enum: ['PDF', 'CSV'],
        required: true
    },
    filename: {
        type: String,
        required: true
    },
    patientName: {
        type: String,
        default: 'Unknown Patient'
    },
    predictions: {
        type: Array,
        default: []
    },
    generatedBy: {
        type: String,
        default: 'System'
    },
    createdAt: {
        type: Date,
        default: Date.now
    }
});

module.exports = mongoose.model('Report', reportSchema);
