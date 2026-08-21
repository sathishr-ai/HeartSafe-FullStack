const fs = require('fs');

const data = fs.readFileSync('framingham.csv', 'utf8');
const lines = data.split(/\r?\n|\r/);

const headers = lines[0].split(',');
// male,age,education,currentSmoker,cigsPerDay,BPMeds,prevalentStroke,prevalentHyp,diabetes,totChol,sysBP,diaBP,BMI,heartRate,glucose,TenYearCHD

const outHeaders = ['age', 'gender', 'cholesterol', 'hdl', 'systolic', 'diastolic', 'smoking', 'diabetes', 'family'];

let cleanedCount = 0;
const outLines = [outHeaders.join(',')];

for (let i = 1; i < lines.length; i++) {
    if (!lines[i].trim()) continue;
    const values = lines[i].split(',');

    // Check for NA
    if (values.includes('NA')) continue;

    const male = values[0];
    const age = values[1];
    const currentSmoker = values[3];
    const diabetes = values[8];
    const totChol = values[9];
    const sysBP = values[10];
    const diaBP = values[11];

    const gender = male === '1' ? 'Male' : 'Female';
    const smoking = currentSmoker === '1' ? 'Yes' : 'No';
    const diabetesStr = diabetes === '1' ? 'Yes' : 'No';

    // Impute missing required columns for the HeartSafe app
    const hdl = 50; // typical average HDL
    const family = 'No'; // unknown from framingham, impute No

    outLines.push([age, gender, totChol, hdl, sysBP, diaBP, smoking, diabetesStr, family].join(','));
    cleanedCount++;
}

fs.writeFileSync('cleaned_dataset.csv', outLines.join('\n'));
console.log(`Successfully cleaned dataset! Dropped NA rows. Saved ${cleanedCount} valid rows to cleaned_dataset.csv`);
