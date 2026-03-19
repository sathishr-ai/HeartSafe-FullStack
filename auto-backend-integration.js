// ==========================================
// HeartSafe - Robust Backend Auto-Integration (V3)
// ==========================================

console.log('🚀 HeartSafe Backend Integration (V3) Starting...');

// --- Part 1: API Core ---
const API_BASE_URL = 'http://localhost:5000/api';

async function apiCall(endpoint, method = 'GET', data = null) {
    const token = localStorage.getItem('authToken');
    const options = {
        method,
        headers: { 'Content-Type': 'application/json' }
    };
    if (token) options.headers['Authorization'] = `Bearer ${token}`;
    if (data) options.body = JSON.stringify(data);

    try {
        const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
        const result = await response.json().catch(() => ({}));

        if (response.status === 401) {
            console.error('❌ Unauthenticated: Token invalid or missing. Please re-login.');
        }

        if (!response.ok) throw new Error(result.message || `Error ${response.status}`);
        return result;
    } catch (error) {
        console.error(`❌ API Error [${endpoint}]:`, error.message);
        throw error;
    }
}

// Function to map frontend data to backend schema
function mapPatientData(p) {
    return {
        age: parseInt(p.age || 0),
        gender: (p.gender || 'male').toLowerCase(),
        totalChol: parseInt(p.cholesterol || p.totalChol || 0),
        hdl: parseInt(p.hdl || 0),
        systolic: parseInt(p.systolic || 0),
        diastolic: parseInt(p.diastolic || 0),
        smoking: (p.smoking === 'Yes' || p.smoking === 'yes' || p.smoking === true) ? 'yes' : 'no',
        diabetes: (p.diabetes === 'Yes' || p.diabetes === 'yes' || p.diabetes === true) ? 'yes' : 'no',
        family: (p.family === 'Yes' || p.family === 'yes' || p.family === true) ? 'yes' : 'no',
        riskScore: p.riskPercentage || p.riskScore || 0,
        riskLevel: p.riskLevel || (p.riskPercentage >= 40 ? 'High' : p.riskPercentage >= 20 ? 'Moderate' : 'Low')
    };
}

async function syncBatchToMongoDB(predictions) {
    if (!predictions || predictions.length === 0) return;

    console.log(`🔄 MongoDB: Syncing ${predictions.length} records...`);

    const formatted = predictions.map(mapPatientData);

    try {
        const CHUNK_SIZE = 50;
        let totalSaved = 0;

        for (let i = 0; i < formatted.length; i += CHUNK_SIZE) {
            const chunk = formatted.slice(i, i + CHUNK_SIZE);
            const result = await apiCall('/predictions/batch', 'POST', { patients: chunk });
            totalSaved += (result.data?.length || 0);
        }

        console.log(`✅ MongoDB: Successfully saved ${totalSaved} records!`);
        if (typeof window.showNotification === 'function') {
            window.showNotification('success', 'Database Sync', `${totalSaved} records saved to MongoDB`);
        }
    } catch (e) {
        console.error('❌ Batch Sync Failed:', e.message);
    }
}

// --- Part 2: Robust Event Listeners ---

function initInterceptors() {
    console.log('🔧 Initializing V3 listeners...');

    // 1. Intercept Batch Results Display (Triggered after local processing)
    if (typeof window.displayBatchResults === 'function') {
        const originalDisplay = window.displayBatchResults;
        window.displayBatchResults = function (results) {
            console.log('📊 Batch processing complete - Syncing to MongoDB...');
            syncBatchToMongoDB(results);
            return originalDisplay.apply(this, arguments);
        };
    }

    // 2. Direct Button IDs (Fallback for bound listeners)

    // CSV Export
    const csvBtn = document.getElementById('exportResultsBtn');
    if (csvBtn) {
        csvBtn.addEventListener('click', async () => {
            console.log('🎯 CSV Export triggered');
            const results = (window.predictionResults || []).map(mapPatientData);
            if (results.length > 0) {
                await apiCall('/exports/csv', 'POST', { predictions: results });
                console.log('✅ CSV report tracked in MongoDB');
            }
        }, true); // Use capture phase to ensure it runs
    }

    // Single Patient Report (Main Screen)
    const genReportBtn = document.getElementById('generateReportBtn');
    if (genReportBtn) {
        genReportBtn.addEventListener('click', async () => {
            console.log('🎯 PDF Report triggered');
            if (window.currentRiskData) {
                const mapped = mapPatientData(window.currentRiskData);
                await apiCall('/exports/pdf', 'POST', {
                    predictions: [mapped],
                    patientName: 'Single Patient Assessment'
                });
                console.log('✅ PDF report tracked in MongoDB');
            }
        }, true);
    }

    // Single Patient Report (Modal)
    const saveAdvisoryBtn = document.getElementById('saveAdvisoryBtn');
    if (saveAdvisoryBtn) {
        saveAdvisoryBtn.addEventListener('click', async () => {
            console.log('🎯 Modal PDF Save triggered');
            // Try to find currently viewed patient or use currentRiskData
            const patientData = window.currentRiskData || {};
            const mapped = mapPatientData(patientData);
            await apiCall('/exports/pdf', 'POST', {
                predictions: [mapped],
                patientName: mapped.id || 'Modal Patient'
            });
            console.log('✅ Modal PDF report tracked in MongoDB');
        }, true);
    }
}

// Wait for DOM to be stable
setTimeout(() => {
    initInterceptors();
    // Verify auth
    const token = localStorage.getItem('authToken');
    if (!token) console.warn('❗ No auth token found. Reports won\'t save until you log in.');
    else console.log('🔐 Authentication ready.');
}, 3000);

console.log('✨ HeartSafe Backend Integration V3 Ready');
