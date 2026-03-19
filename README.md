<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Red%20Heart.png" alt="Red Heart" width="50" />
  <h1 align="center">HeartSafe : AI-Powered CHD Risk Assessor</h1>
  
  <p align="center">
    <strong>An end-to-end intelligent diagnostic ecosystem prioritizing early Coronary Heart Disease detection.</strong>
  </p>

  <!-- ACTION BUTTON CLUSTER -->
  <div align="center">
    <a href="https://heartsafechdpred.netlify.app/">
      <img src="https://img.shields.io/badge/Live_Demo-Access_Web_App-blue?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Live Demo">
    </a>
    <a href="https://heartsafe-backend.onrender.com/api/health">
      <img src="https://img.shields.io/badge/Live_API-Render_Backend-success?style=for-the-badge&logo=render&logoColor=white" alt="Live API">
    </a>
    <a href="#-mobile-application">
      <img src="https://img.shields.io/badge/Mobile_App-Download_APK-green?style=for-the-badge&logo=android&logoColor=white" alt="Download APK">
    </a>
  </div>
</div>

<br/>

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Travel%20and%20places/Rocket.png" width="25" /> Project Pinnacle Overview

**HeartSafe** is a full-stack, premium healthcare suite that bridges the gap between predictive AI algorithms and real-world clinical application. Driven by a highly accurate **XGBoost Model** built in Python, the cross-platform ecosystem analyzes clinical metrics (like blood pressure, BMI, glucose, and patient history) to deliver instant risk forecasting for 10-year Coronary Heart Disease (CHD) development.

<br/>

<div align="center">
  <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Microscope.png" width="25" />
  <em>Designed for both individual patient monitoring and bulk clinical dataset analysis.</em>
</div>

---

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Crossed%20Swords.png" width="25" /> The Technical Arsenal

<div align="center">
  <img src="https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white" alt="Flutter">
  <img src="https://img.shields.io/badge/Node.js-43853D?style=for-the-badge&logo=node.js&logoColor=white" alt="Node.js">
  <img src="https://img.shields.io/badge/Express.js-%23404d59.svg?style=for-the-badge&logo=express&logoColor=%2361DAFB" alt="Express.js">
  <img src="https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=for-the-badge&logo=mongodb&logoColor=white" alt="MongoDB">
  <img src="https://img.shields.io/badge/Python-14354C?style=for-the-badge&logo=python&logoColor=white" alt="Python">
  <img src="https://img.shields.io/badge/XGBoost-%23F37626.svg?style=for-the-badge&logoColor=white" alt="XGBoost">
</div>

| Layer | Architecture Component | Purpose |
|-------|-----------------------|---------|
| **Frontend** | Flutter / JS | Seamless cross-platform user experience (Web HTML5 & Android) |
| **Backend** | Node.js & Express | Handling REST APIs, JWT Authentication, and processing routing |
| **Database** | MongoDB Atlas Cloud | Scalable remote data storage for users, patients, and predictions |
| **AI Engine** | Scikit-learn / XGBoost | Predictive modeling hosted securely with high precision thresholds |

---

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Star-Struck.png" width="25" /> Premium Features

- <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Locked%20With%20Key.png" width="20" /> **Zero-Trust Security:** Encrypted JWT user routing and fully shielded cloud-database architectures (CORS Bypass Integrated).
- <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Bar%20Chart.png" width="20" /> **Batch Data Processing:** Hospital administrators can upload dense CSV files to analyze hundreds of patients simultaneously.
- <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Page%20Facing%20Up.png" width="20" /> **Dynamic PDF Reporting:** Intelligent one-click export for clinical patient reports and automated dietary advisories.

---

## <img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Objects/Wrench.png" width="25" /> Local Installation Matrix

<details>
<summary><b>🔥 Click to expand the developer deployment guide</b></summary>

<br/>

### 1. Database Configuration
* Spin up a MongoDB Atlas cluster and whitelist your IP `0.0.0.0/0`.
* Acquire your exact `mongodb+srv://` URI string and inject it into your `.env` layer.

### 2. Backend Bootup
```bash
git clone https://github.com/sathishr-ai/heartsafe-backend.git
cd heartsafe-backend
npm install
```

*Create the Environment Layer (`.env`):*
```bash
MONGO_URI=mongodb+srv://user123:<password>@cluster0...
PORT=5000
JWT_SECRET=super_secret
```

*Ignite Server:*
```bash
npm start
```

### 3. Frontend Execution (Flutter)
```bash
cd chd_flutter_app

# Render Web Build:
flutter build web

# Generate Android Release APK:
flutter build apk --release
```

</details>

<br/>

<div align="center">
  <h3>Built with passion by an Aspiring AI/ML Engineer and Full-Stack Developer</h3>
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&height=100&section=footer"/>
</div>
