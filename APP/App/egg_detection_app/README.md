# 📱 Egg Detection Mobile App

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-3.0+-blue?logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-blue?logo=dart)
![Firebase](https://img.shields.io/badge/Firebase-Enabled-orange?logo=firebase)

**Cross-platform mobile application for egg gender detection**

</div>

---

## 📋 Overview

This is the Flutter-based mobile application for the Egg Gender Prediction System. It provides an intuitive interface for users to:
- Perform real-time camera-based egg detection
- Input manual measurements for prediction
- View detection history with filtering options
- Manage user authentication via Firebase

---

## ✨ Features

### Authentication
- 🔐 **Firebase Authentication** - Secure login/registration
- 👤 **User Profiles** - Personalized experience
- 📧 **Email Verification** - Account security

### Detection Methods
- 📷 **Camera Detection** - 5-second automated measurement with live countdown
- ✍️ **Manual Input** - Direct width/height entry for instant prediction
- 🔄 **Real-time Polling** - Live status updates during detection

### Results & History
- 📊 **Dual Predictions** - Compare camera-based and ML-based results
- 💾 **History Tracking** - All detections saved with timestamps
- 🔍 **Advanced Filtering** - Filter by detection type (all/camera/manual)
- 📈 **Confidence Scores** - ML prediction confidence displayed

### User Experience
- 🎨 **Material Design** - Modern, clean UI
- 🌈 **Custom Theming** - Golden yellow and dark gray color scheme
- 📱 **Responsive Design** - Adapts to different screen sizes
- ⚡ **Fast Performance** - Optimized API calls and state management
- 🔄 **Pull to Refresh** - Easy data updates

---

## 🛠 Tech Stack

| Technology | Purpose |
|------------|---------|
| **Flutter** | Cross-platform framework |
| **Dart** | Programming language |
| **Firebase Auth** | User authentication |
| **Cloud Firestore** | Optional cloud storage |
| **HTTP** | API communication |
| **Provider** | State management |
| **Google Fonts** | Typography |
| **Flutter SpinKit** | Loading animations |
| **Intl** | Date formatting |

---

## 📁 Project Structure

```
lib/
├── main.dart                   # App entry point
├── firebase_options.dart       # Firebase configuration
│
├── models/                     # Data models
│   └── egg_detection_model.dart
│
├── screens/                    # UI screens
│   ├── splash_screen.dart      # Launch screen
│   ├── login_screen.dart       # User login
│   ├── register_screen.dart    # User registration
│   ├── dashboard_screen.dart   # Main navigation hub
│   ├── detection_screen.dart   # Camera detection
│   ├── manual_input_screen.dart # Manual measurements
│   ├── history_screen.dart     # Detection history
│   └── profile_screen.dart     # User profile
│
├── services/                   # Business logic
│   ├── api_service.dart        # Backend API calls
│   └── auth_service.dart       # Authentication logic
│
├── utils/                      # Utilities
│   └── constants.dart          # App constants & colors
│
└── widgets/                    # Reusable widgets
    └── (custom widgets)
```

---

## 🚀 Installation & Setup

### Prerequisites
- **Flutter SDK** 3.0 or higher ([Install Flutter](https://flutter.dev/docs/get-started/install))
- **Dart SDK** 3.0+ (comes with Flutter)
- **Android Studio** or **VS Code** with Flutter extensions
- **Firebase Project** ([Create Firebase Project](https://console.firebase.google.com/))

### Step 1: Clone Repository
```bash
git clone https://github.com/yourusername/egg-gender-prediction.git
cd egg-gender-prediction/APP/App/egg_detection_app
```

### Step 2: Install Dependencies
```bash
flutter pub get
```

### Step 3: Firebase Configuration

#### For Android:
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Create a new project or use existing
3. Add an Android app
4. Download `google-services.json`
5. Place it in `android/app/google-services.json`

#### For iOS:
1. In Firebase Console, add an iOS app
2. Download `GoogleService-Info.plist`
3. Place it in `ios/Runner/GoogleService-Info.plist`

#### Generate Firebase Options:
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Configure Firebase
flutterfire configure
```

### Step 4: Update Server URL
Edit `lib/utils/constants.dart`:

```dart
// For Raspberry Pi on same network:
static const String baseUrl = 'http://raspberrypi.local:5000';

// OR for specific IP:
static const String baseUrl = 'http://192.168.1.100:5000';

// OR for local development:
static const String baseUrl = 'http://localhost:5000';
```

### Step 5: Run the App

```bash
# Check connected devices
flutter devices

# Run on specific device
flutter run -d <device_id>

# Or just run (will show device selection)
flutter run
```

---

## 📱 Build for Production

### Android APK
```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```
Output: `build/app/outputs/flutter-apk/app-release.apk`

### iOS
```bash
# Build for iOS
flutter build ios --release
```
Then open `ios/Runner.xcworkspace` in Xcode and archive.

---

## 🎨 Customization

### Theme Colors
Edit `lib/utils/constants.dart`:

```dart
class AppConstants {
  static const Color primaryColor = Color(0xFFFFD700); // Golden Yellow
  static const Color secondaryColor = Color(0xFF2C2C2C); // Dark Gray
  static const Color accentColor = Colors.white;
  
  // Gender colors
  static const Color maleColor = Color(0xFF2196F3);
  static const Color femaleColor = Color(0xFFE91E63);
  static const Color unhatchedColor = Color(0xFFFF9800);
}
```

### App Icon
Replace `assets/icon/app_icon.png` with your icon, then run:
```bash
flutter pub run flutter_launcher_icons:main
```

### App Name
Edit:
- `android/app/src/main/AndroidManifest.xml` (android:label)
- `ios/Runner/Info.plist` (CFBundleName)

---

## 🔌 API Integration

The app communicates with the Flask backend via REST API. All API calls are centralized in `lib/services/api_service.dart`.

### API Endpoints Used

| Endpoint | Method | Purpose |
|----------|--------|---------|
| `/api/status` | GET | Check server status |
| `/api/start_detection` | POST | Start camera detection |
| `/api/get_results` | GET | Poll for results |
| `/api/manual_predict` | POST | Manual prediction |
| `/api/save_history` | POST | Save to history |
| `/api/get_history` | GET | Retrieve history |

### Example API Call
```dart
final status = await ApiService.checkServerStatus();
print(status['camera_available']); // true or false
```

---

## 🐛 Troubleshooting

### Cannot Connect to Server
- ✅ Ensure backend server is running
- ✅ Check IP address matches in constants.dart
- ✅ Verify both devices on same WiFi network
- ✅ Check firewall settings
- ✅ Test server URL in browser first

### Firebase Issues
- ✅ Verify `google-services.json` is in correct location
- ✅ Check Firebase project settings
- ✅ Ensure SHA-1 fingerprint is added (Android)
- ✅ Run `flutterfire configure` again

### Build Errors
```bash
# Clean build cache
flutter clean

# Get dependencies fresh
flutter pub get

# Rebuild
flutter run
```

### Camera Permission (iOS)
Add to `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs camera access for egg detection</string>
```

---

## 📊 App Flow

```
Launch App
    ↓
Splash Screen (2s)
    ↓
Check Auth Status
    ↓
├─ Logged In → Dashboard
│                 ↓
│              ┌──────┐
│              │ Menu │
│              └──┬───┘
│                 ├─► Detection Screen
│                 │      └─► Start Detection / View Results
│                 ├─► Manual Input Screen
│                 │      └─► Enter Measurements / Get Prediction
│                 ├─► History Screen
│                 │      └─► View Past Results / Filter
│                 └─► Profile Screen
│                        └─► View Profile / Logout
│
└─ Not Logged In → Login Screen
                      └─► Register Screen (if new user)
```

---

## 🔒 Security Notes

- 🔐 **Never commit** `google-services.json` or `GoogleService-Info.plist` to public repos
- 🔐 **API Keys** should be stored securely (use environment variables)
- 🔐 **HTTPS** recommended for production (use SSL certificates)
- 🔐 **Firebase Rules** should be configured properly in Firebase Console

---

## 📈 Performance Tips

1. **Minimize Rebuilds** - Use `const` constructors where possible
2. **Lazy Loading** - Load history data as needed
3. **Image Optimization** - Compress assets before adding
4. **API Caching** - Consider caching server status
5. **Debouncing** - Prevent multiple rapid API calls

---

## 🤝 Contributing

Contributions welcome! Please:
1. Follow Flutter style guidelines
2. Test on both Android and iOS
3. Update documentation for new features
4. Ensure code is formatted (`dart format .`)

---

## 📄 License

See [LICENSE](../../../LICENSE) in root directory.

---

## 🆘 Support

For issues specific to the mobile app:
1. Check existing issues
2. Provide device info, OS version, and error logs
3. Include screenshots if UI-related

---

<div align="center">

**Built with Flutter 💙**

[Back to Main README](../../../README.md)

</div>
