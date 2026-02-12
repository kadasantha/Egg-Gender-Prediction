# Architecture Documentation

## System Architecture Overview

The Egg Gender Prediction System follows a client-server architecture with three main layers:

1. **Presentation Layer** - Flutter mobile application
2. **Application Layer** - Flask REST API server
3. **Data Layer** - JSON file storage + ML models

---

## High-Level Architecture

```
┌────────────────────────────────────────────────────────────┐
│                     PRESENTATION LAYER                      │
│                                                             │
│  ┌───────────────────────────────────────────────────┐    │
│  │         Flutter Mobile Application                │    │
│  │  ┌──────────┐  ┌──────────┐  ┌──────────────┐   │    │
│  │  │ Auth UI  │  │Detection │  │   History    │   │    │
│  │  │ (Login/  │  │   UI     │  │   & Stats    │   │    │
│  │  │Register) │  │          │  │              │   │    │
│  │  └─────┬────┘  └────┬─────┘  └──────┬───────┘   │    │
│  │        │            │                │           │    │
│  │  ┌─────▼────────────▼────────────────▼───────┐   │    │
│  │  │         API Service Layer                 │   │    │
│  │  │   (HTTP Client, State Management)         │   │    │
│  │  └───────────────────┬───────────────────────┘   │    │
│  └────────────────────┼─┼─────────────────────────┘    │
└───────────────────────┼─┼──────────────────────────────┘
                        │ │
                     HTTP│ │REST API
                        │ │(WiFi/Network)
                        │ │
┌───────────────────────▼─▼──────────────────────────────────┐
│                    APPLICATION LAYER                        │
│                                                             │
│  ┌─────────────────────────────────────────────────────┐  │
│  │           Flask Application Server                  │  │
│  │                                                     │  │
│  │  ┌──────────────────────────────────────────────┐  │  │
│  │  │          API Route Handlers                  │  │  │
│  │  │  /api/status, /api/start_detection, etc.    │  │  │
│  │  └────┬─────────────────────────┬─────────┬─────┘  │  │
│  │       │                         │         │        │  │
│  │  ┌────▼──────────┐  ┌──────────▼───┐  ┌──▼──────┐  │  │
│  │  │  Detection    │  │  ML Model    │  │ History │  │  │
│  │  │  Controller   │  │  Predictor   │  │ Manager │  │  │
│  │  └────┬──────────┘  └──────┬───────┘  └────┬────┘  │  │
│  └───────┼─────────────────────┼───────────────┼───────┘  │
└──────────┼─────────────────────┼───────────────┼──────────┘
           │                     │               │
┌──────────▼─────────────────────▼───────────────▼──────────┐
│                        DATA LAYER                          │
│                                                             │
│  ┌─────────────┐  ┌──────────────┐  ┌──────────────────┐ │
│  │   Camera    │  │  ML Models   │  │  JSON Storage    │ │
│  │  Hardware   │  │   (.pkl)     │  │  (History Data)  │ │
│  │             │  │              │  │                  │ │
│  │  - USB Cam  │  │  - RF Model  │  │  - Detections   │ │
│  │  - RPi Cam  │  │  - Scaler    │  │  - User Data    │ │
│  │             │  │  - Encoder   │  │  - Statistics   │ │
│  └─────────────┘  └──────────────┘  └──────────────────┘ │
└─────────────────────────────────────────────────────────────┘
```

---

## Component Architecture

### 1. Flutter Mobile App

```
┌─────────────────────────────────────────┐
│         Application Layer               │
│  ┌───────────────────────────────┐     │
│  │        main.dart              │     │
│  │   - App Initialization        │     │
│  │   - Firebase Setup            │     │
│  │   - Theme Configuration       │     │
│  │   - Routing                   │     │
│  └─────────┬─────────────────────┘     │
│            │                            │
│  ┌─────────▼─────────────────────┐     │
│  │      Screen Layer             │     │
│  │  - SplashScreen               │     │
│  │  - LoginScreen                │     │
│  │  - DashboardScreen            │     │
│  │  - DetectionScreen            │     │
│  │  - ManualInputScreen          │     │
│  │  - HistoryScreen              │     │
│  │  - ProfileScreen              │     │
│  └─────┬────────────┬────────────┘     │
│        │            │                   │
│  ┌─────▼──────┐  ┌──▼─────────┐        │
│  │  Services  │  │  Models    │        │
│  │            │  │            │        │
│  │ - API      │  │ - Detection│        │
│  │ - Auth     │  │ - History  │        │
│  └────────────┘  └────────────┘        │
│                                         │
│  ┌──────────────────────────────┐      │
│  │      Utils & Widgets         │      │
│  │  - Constants                 │      │
│  │  - Helpers                   │      │
│  │  - Custom Widgets            │      │
│  └──────────────────────────────┘      │
└─────────────────────────────────────────┘
```

### 2. Flask Backend Server

```
┌────────────────────────────────────────────┐
│          Flask Application                 │
│  ┌──────────────────────────────────┐     │
│  │        server.py                 │     │
│  │   - Flask App Instance           │     │
│  │   - CORS Configuration           │     │
│  │   - Route Definitions            │     │
│  │   - Threading Logic              │     │
│  └────┬─────────────┬───────────────┘     │
│       │             │                      │
│  ┌────▼─────────┐  │  ┌───────────────┐   │
│  │ detection.py │  │  │ ml_predict.py │   │
│  │              │  │  │               │   │
│  │ - Camera     │  │  │ - Model Load  │   │
│  │   Management │  │  │ - Feature Eng │   │
│  │ - Image      │◄─┼──│ - Prediction  │   │
│  │   Processing │  │  │ - Confidence  │   │
│  │ - Contour    │  │  └───────────────┘   │
│  │   Detection  │  │                      │
│  │ - ESI Calc   │  │  ┌───────────────┐   │
│  └──────────────┘  └──│history_       │   │
│                       │manager.py     │   │
│                       │               │   │
│                       │ - JSON R/W    │   │
│                       │ - Statistics  │   │
│                       └───────────────┘   │
└────────────────────────────────────────────┘
```

---

## Data Flow

### Detection Workflow

```
User Taps "Start Detection"
         │
         ▼
┌────────────────────────┐
│ Flutter App            │
│ POST /api/start        │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ Flask Server           │
│ - Spawn Thread         │
│ - Return 200 OK        │
└──────────┬─────────────┘
           │
           ├─────────────────────┐
           │                     │
           ▼                     ▼
┌──────────────────┐    ┌───────────────┐
│ Main Thread      │    │ Detection     │
│ - Handle Requests│    │ Thread        │
└──────────────────┘    │               │
                        │ 1. Init Camera│
                        │ 2. Capture    │
                        │    Frames (5s)│
                        │ 3. Process    │
                        │    Images     │
                        │ 4. Calculate  │
                        │    Avg        │
                        │ 5. ML Predict │
                        │ 6. Store      │
                        │    Results    │
                        └───────┬───────┘
                                │
           ┌────────────────────┘
           │
           ▼
┌────────────────────────┐
│ Results Ready          │
│ status: "completed"    │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ Flutter App            │
│ - Poll GET /api/results│
│ - Display Results      │
│ - Save to History      │
└────────────────────────┘
```

### Manual Prediction Workflow

```
User Enters Width & Height
         │
         ▼
┌────────────────────────┐
│ Client-side Validation │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ POST /api/manual       │
│ {width: 5.5, height:7} │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ Flask Server           │
│ 1. Validate Input      │
│ 2. Calculate ESI       │
│ 3. Rule-based Class    │
│ 4. ML Prediction       │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ Return Results         │
│ - ESI                  │
│ - Camera Gender        │
│ - ML Gender            │
│ - Confidence           │
└──────────┬─────────────┘
           │
           ▼
┌────────────────────────┐
│ Display in App         │
│ Save to History        │
└────────────────────────┘
```

---

## Technology Stack Details

### Frontend Stack
- **Framework:** Flutter 3.0+
- **Language:** Dart 3.0+
- **State Management:** Provider
- **Networking:** HTTP package
- **Authentication:** Firebase Auth
- **Database:** Cloud Firestore (optional)
- **UI:** Material Design

### Backend Stack
- **Framework:** Flask 2.3+
- **Language:** Python 3.7+
- **Computer Vision:** OpenCV 4.8+
- **ML Framework:** Scikit-learn 1.3+
- **Data Processing:** NumPy, Pandas
- **Serialization:** Joblib
- **Storage:** JSON files

### Deployment Stack
- **Development:** Windows/Mac/Linux PC
- **Production:** Raspberry Pi 4B
- **OS:** Raspberry Pi OS (Debian-based)
- **Service Manager:** systemd
- **Network:** WiFi/Ethernet (mDNS support)

---

## Security Architecture

```
┌─────────────────────────────────┐
│      Security Layers            │
│                                 │
│  1. Authentication              │
│     - Firebase Auth             │
│     - Email/Password            │
│     - Session Management        │
│                                 │
│  2. Network Security            │
│     - HTTPS (recommended)       │
│     - CORS Configuration        │
│     - Same-Network Access       │
│                                 │
│  3. Data Security               │
│     - Local Storage Only        │
│     - No Sensitive Data in API  │
│     - User-specific History     │
│                                 │
│  4. Access Control              │
│     - User-based History Filter │
│     - No Public Data Exposure   │
└─────────────────────────────────┘
```

---

## Scalability Considerations

### Current Limitations
- Single camera per server instance
- One detection at a time
- JSON file storage (not suitable for large scale)
- No load balancing

### Future Scalability Options
1. **Database Migration**
   - PostgreSQL for production
   - MongoDB for flexibility
   - SQLite for embedded systems

2. **Multiple Camera Support**
   - Worker threads per camera
   - Queue-based processing
   - Load distribution

3. **Cloud Integration**
   - AWS S3 for image storage
   - Cloud ML for inference
   - CDN for static assets

4. **Microservices Architecture**
   - Separate detection service
   - Separate ML inference service
   - API gateway layer

---

## Performance Optimization

### Current Optimizations
1. **Background Processing** - Threading prevents blocking
2. **Moving Average** - 5-second window smooths measurements
3. **Efficient Image Processing** - Optimized OpenCV operations
4. **Model Caching** - Models loaded once at startup
5. **Lazy Loading** - Resources loaded on demand

### Future Optimizations
1. Connection pooling
2. Redis caching
3. Image compression
4. Model quantization
5. Edge computing (on-device ML)

---

## Monitoring & Logging

### Current Implementation
- Console logging (stdout/stderr)
- systemd journal (Raspberry Pi)
- Detection history (JSON)

### Recommended Additions
1. **Application Monitoring**
   - Request/response times
   - Error rates
   - Resource usage

2. **System Monitoring**
   - CPU/Memory usage
   - Network bandwidth
   - Camera health

3. **Business Metrics**
   - Detections per day
   - Accuracy rates
   - User engagement

---

## Deployment Architecture

### Development Environment
```
┌──────────────┐         ┌──────────────┐
│    Laptop    │◄───────►│  Laptop      │
│  (Frontend)  │  WiFi   │  (Backend)   │
│   Flutter    │         │   Python     │
│   Dev Mode   │         │   Debug On   │
└──────────────┘         └──────────────┘
```

### Production Environment
```
┌──────────────┐         ┌──────────────┐
│    Mobile    │         │ Raspberry Pi │
│    Device    │◄───────►│   Server     │
│  (Android/   │  WiFi   │  (Backend)   │
│    iOS)      │         │  Auto-start  │
└──────────────┘         └──────────────┘
```

---

## Maintenance & Updates

### Update Strategy
1. **Mobile App Updates**
   - Google Play Store / App Store
   - OTA Firebase updates
   - Manual APK distribution

2. **Backend Updates**
   - SSH access to Raspberry Pi
   - Git pull + restart service
   - Docker containers (future)

3. **ML Model Updates**
   - Replace .pkl files
   - Restart server
   - Verify compatibility

---

## Disaster Recovery

### Backup Strategy
1. **Code:** Git repository
2. **Models:** Version control large files
3. **History:** Daily JSON backups
4. **Configuration:** Document all settings

### Recovery Procedures
1. Restore from Git
2. Reinstall dependencies
3. Restore model files
4. Restore history JSON
5. Reconfigure network settings

---

For more details on specific components, see:
- [README.md](../README.md) - General overview
- [INSTALLATION.md](../INSTALLATION.md) - Setup instructions
- [API Documentation](API.md) - Endpoint specifications
