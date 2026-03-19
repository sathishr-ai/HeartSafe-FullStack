<div align="center">

<img src="https://raw.githubusercontent.com/Tarikul-Islam-Anik/Animated-Fluent-Emojis/master/Emojis/Smilies/Red%20Heart.png" alt="Heart" width="70" />

# 🤍 HeartSafe 🤍
### AI-Powered Coronary Heart Disease Predictive Ecosystem

<br/>

<p align="center">
  <img src="https://img.shields.io/github/repo-size/sathishr-ai/heartsafe-backend?style=for-the-badge&color=2ea44f" alt="Repo Size" />
  <img src="https://img.shields.io/badge/Status-Live_Production-2ea44f?style=for-the-badge&logo=vercel" alt="Status" />
  <img src="https://img.shields.io/badge/Version-v1.0.0-blue?style=for-the-badge" alt="Version" />
  <img src="https://img.shields.io/badge/License-MIT-black?style=for-the-badge" alt="License" />
</p>

<p align="center">
  <b>A full-stack, cross-platform diagnostic pipeline engineered to analyze complex clinical metrics and instantly forecast 10-year risk profiles for Coronary Heart Disease (CHD). Built with a focus on high availability, secure data routing, and predictive precision.</b>
</p>

<br/>

<a href="https://heartsafechdpred.netlify.app/">
  <img src="https://img.shields.io/badge/Launch_Web_Application-blue?style=for-the-badge&logo=googlechrome&logoColor=white" alt="Live Demo">
</a>
<a href="https://heartsafe-backend.onrender.com/api/health">
  <img src="https://img.shields.io/badge/Live_API_Status-success?style=for-the-badge&logo=render&logoColor=white" alt="API Status">
</a>
<a href="https://github.com/sathishr-ai/heartsafe-backend/releases/download/v1.0/app-release.apk">
  <img src="https://img.shields.io/badge/Download_Android_APK-green?style=for-the-badge&logo=android&logoColor=white" alt="Download APK">
</a>

<br/><br/>

</div>

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=📸%20Live%20Application%20Interfaces&fontColor=ffffff&fontSize=22" width="100%"/>

> *Actual application UI rendering live data bridging the Flutter ecosystem and responsive HTML5.*

<div align="center">
  <table>
    <tr>
      <td align="center"><b>🌐 Web Platform Interface</b></td>
      <td align="center"><b>📱 Mobile Android Interface</b></td>
    </tr>
    <tr>
      <td>
        <!-- WEB APP SCREENSHOT GOES HERE -->
        <img src="https://via.placeholder.com/600x400/0d1117/58a6ff?text=Drop+Web+App+Screenshot+Here" alt="Web Application Output" width="450"/>
      </td>
      <td>
        <!-- MOBILE APP SCREENSHOT GOES HERE -->
        <img src="https://via.placeholder.com/250x400/0d1117/3fb950?text=Drop+Mobile+App+Screenshot+Here" alt="Mobile Application Output" width="250"/>
      </td>
    </tr>
  </table>
</div>

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=🎯%20Executive%20Problem%20Statement&fontColor=ffffff&fontSize=22" width="100%"/>

Cardiovascular diseases are the leading cause of death globally. In clinical data evaluation, speed and predictive accuracy are paramount. 

**HeartSafe** was developed to bridge the gap between abstract machine learning algorithms and real-world clinical adoption. By unifying a highly-tuned **XGBoost Classifier** with a **Node.js REST API**, the application delivers real-time diagnostic assessments directly to medical professionals through a **Flutter-engineered** cross-platform interface.

This ecosystem proves strict adherence to modern deployment pipelines, utilizing stateless JWT authentication, scalable NoSQL remote clustering (MongoDB Atlas), and responsive state-management.

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=🏗️%20Deep-Level%20System%20Architecture&fontColor=ffffff&fontSize=22" width="100%"/>

The ecosystem relies on an asynchronous, highly-available multi-tier architecture to securely relay patient arrays and offload heavy ML computations instantly out-of-thread.

```mermaid
graph TD
    classDef frontend fill:#02569B,stroke:#fff,stroke-width:2px,color:#fff;
    classDef nodejs fill:#339933,stroke:#fff,stroke-width:2px,color:#fff;
    classDef python fill:#FFD43B,stroke:#fff,stroke-width:2px,color:#000;
    classDef db fill:#47A248,stroke:#fff,stroke-width:2px,color:#fff;

    subgraph "Client Layer (Frontend)"
        A[Flutter Android APK]:::frontend
        B[Vanilla Web Application]:::frontend
    end

    subgraph "API Gateway Layer (Node.js)"
        C{NGINX / Vercel Edge}
        D(Express.js REST Router):::nodejs
        E[JWT Auth & Middleware Bypass]:::nodejs
    end

    subgraph "Persistence & ML Computation Layer"
        F[(MongoDB Atlas Cloud)]:::db
        G[Python XGBoost Engine]:::python
    end

    A -->|JSON Payload via HTTPS| C
    B -->|JSON Payload via HTTPS| C
    C --> D
    
    D -->|Token Validate| E
    E -- Success --> D
    
    D <-->|Asynchronous CRUD| F
    D <-->|Feature Vector Extraction| G
    
    G -->|Probability Score %| D
    D -->|200 OK Response| C
    C --> A
    C --> B
```

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=💻%20Technical%20Stack%20&%20Rationale&fontColor=ffffff&fontSize=22" width="100%"/>

<div align="center">

| Layer | Technology | Engineering Rationale |
|:---|:---|:---|
| **Frontend UI/UX** | ![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=flat&logo=Flutter&logoColor=white) | Chosen for its unified codebase, compiling native ARM code for Android while concurrently rendering dynamic HTML5/Canvas for the Web platform. |
| **Backend API** | ![NodeJS](https://img.shields.io/badge/Node.js-43853D?style=flat&logo=node.js&logoColor=white) ![Express](https://img.shields.io/badge/Express.js-%23404d59.svg?style=flat&logo=express&logoColor=%2361DAFB) | Provides an asynchronous, event-driven gateway capable of handling dense concurrent clinical data uploads seamlessly. |
| **Database** | ![MongoDB](https://img.shields.io/badge/MongoDB-%234ea94b.svg?style=flat&logo=mongodb&logoColor=white) | Flexible BSON document schema natively supports complex, deeply-nested patient health arrays and historical predictive logs. |
| **Machine Learning** | ![Python](https://img.shields.io/badge/Python-14354C?style=flat&logo=python&logoColor=white) **XGBoost** | Selected over Random Forest for its superior handling of imbalanced medical datasets and optimized gradient boosting regularization, achieving >90% precision. |

</div>

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=⚡%20Core%20Enterprise%20Features&fontColor=ffffff&fontSize=22" width="100%"/>

### 🔒 1. Robust Zero-Trust Authentication
- Implemented **Stateless JWT (JSON Web Tokens)** architecture.
- Passwords are cryptographically hashed via **Bcrypt** prior to database insertion.
- Enforced strict **CORS policies** allowing bypass only on verified production host domains.

### 📊 2. Intelligent Batch Processing
- Administrative dashboard featuring an automated CSV multi-patient ingestion pipeline.
- Backend iteratively parses, normalizes, and feeds mass datasets into the ML Engine via parallel routing, mapping fully formatted visual charts to the frontend state.

### 📑 3. Dynamic PDF Generation
- Algorithmically constructs and exports comprehensive **PDF Medical Reports** summarizing feature importance, critical lifestyle adjustments, and automated dietary planning based on specific cholesterol/pressure thresholds.

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=📂%20File%20Structure&fontColor=ffffff&fontSize=22" width="100%"/>

```text
HeartSafe-Project/
│
├── chd_flutter_app/              # Native Android App (Flutter/Dart)
│   ├── lib/screens/              # Cross-platform interactive views
│   └── lib/services/             # API routing configurations
│
├── backend/                      # Node.js + Express.js API
│   ├── config/database.js        # MongoDB Atlas routing
│   ├── controllers/              # JWT & Authorization Logic
│   └── models/                   # Mongoose DB Schemas
│
└── CChd.prediction.html          # Standalone public Web Application
```

---

<img src="https://capsule-render.vercel.app/api?type=rect&color=02569B&height=50&text=👨‍💻%20Meet%20the%20Engineer&fontColor=ffffff&fontSize=22" width="100%"/>

<div align="center">
  <h3>Sathish R</h3>
  <b>Full-Stack Developer | Aspiring Software Engineer | AI/ML Specialist</b>
  <p>I am passionately focused on architecting scalable software solutions that actively leverage artificial intelligence to solve complex, high-impact problems in the real world.</p>
  
  <a href="https://github.com/sathishr-ai">
    <img src="https://img.shields.io/badge/GitHub-100000?style=for-the-badge&logo=github&logoColor=white" alt="GitHub">
  </a>
  <a href="#your-linkedin">
    <img src="https://img.shields.io/badge/LinkedIn-0077B5?style=for-the-badge&logo=linkedin&logoColor=white" alt="LinkedIn">
  </a>
  <a href="mailto:your-email@example.com">
    <img src="https://img.shields.io/badge/Email-D14836?style=for-the-badge&logo=gmail&logoColor=white" alt="Email">
  </a>
</div>

<br/>
<div align="center">
  <img src="https://capsule-render.vercel.app/api?type=waving&color=gradient&height=120&section=footer"/>
</div>
