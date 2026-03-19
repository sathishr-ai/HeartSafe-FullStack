console.log('📋 API-Integration Script Loading...');

const API_BASE_URL = 'http://localhost:5000/api';
let authToken = localStorage.getItem('authToken');

async function apiCall(endpoint, method = 'GET', data = null) {
  const options = {
    method,
    headers: { 'Content-Type': 'application/json' }
  };

  if (authToken) {
    options.headers['Authorization'] = `Bearer ${authToken}`;
  }

  if (data) {
    options.body = JSON.stringify(data);
  }

  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, options);
    const result = await response.json();

    if (!response.ok) {
      if (response.status === 401) {
        console.log("Unauthorized request detected");
      }
      throw new Error(result.message || 'API Error');
    }

    return result;
  } catch (error) {
    console.error('Error in apiCall:', error.message);
    throw error;
  }
}

async function loginAPI(username, password) {
  const result = await apiCall('/auth/login', 'POST', { username, password });
  authToken = result.token;
  localStorage.setItem('authToken', authToken);
  return result.user;
}

async function logoutAPI() {
  await apiCall('/auth/logout', 'POST');
  authToken = null;
  localStorage.removeItem('authToken');
}

async function predictSingleRiskAPI(patientData) {
  const result = await apiCall('/predictions/single', 'POST', {
    age: parseInt(patientData.age),
    gender: patientData.gender,
    totalChol: parseInt(patientData.totalChol || patientData.cholesterol),
    hdl: parseInt(patientData.hdl),
    systolic: parseInt(patientData.systolic),
    diastolic: parseInt(patientData.diastolic),
    smoking: patientData.smoking,
    diabetes: patientData.diabetes,
    family: patientData.family || patientData.familyHistory
  });
  return result.data;
}

async function predictBatchRiskAPI(patientsArray) {
  const formattedPatients = patientsArray.map(p => ({
    age: parseInt(p.age),
    gender: p.gender,
    totalChol: parseInt(p.totalChol || p.cholesterol),
    hdl: parseInt(p.hdl),
    systolic: parseInt(p.systolic),
    diastolic: parseInt(p.diastolic),
    smoking: p.smoking,
    diabetes: p.diabetes,
    family: p.family || p.familyHistory
  }));

  const result = await apiCall('/predictions/batch', 'POST', { patients: formattedPatients });
  return result.data;
}

async function exportPDFAPI(predictions, patientName) {
  const result = await apiCall('/exports/pdf', 'POST', { predictions, patientName });
  return result.data;
}

async function exportCSVAPI(predictions) {
  const result = await apiCall('/exports/csv', 'POST', { predictions });
  return result.data;
}

// Ensure all functions are globally accessible
window.apiCall = apiCall;
window.loginAPI = loginAPI;
window.logoutAPI = logoutAPI;
window.predictSingleRiskAPI = predictSingleRiskAPI;
window.predictBatchRiskAPI = predictBatchRiskAPI;
window.exportPDFAPI = exportPDFAPI;
window.exportCSVAPI = exportCSVAPI;

console.log('✅ API-Integration Script Loaded Successfully');
