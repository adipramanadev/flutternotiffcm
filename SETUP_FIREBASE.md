# 🔥 Firebase Setup Guide

**Important**: After cloning this repository, you need to configure Firebase before the app will work properly.

## 🚨 Common Error After Clone

If you see this error:
```
❌ Error getting FCM token: [firebase_messaging/unknown] java.io.IOException: java.util.concurrent.ExecutionException: java.io.IOException: SERVICE_NOT_AVAILABLE
```

This means Firebase is not configured for your environment. Follow the setup steps below.

## 🛠️ Method 1: Automatic Setup (Recommended)

### 1. Install FlutterFire CLI
```bash
dart pub global activate flutterfire_cli
```

### 2. Login to Firebase
```bash
firebase login
```

### 3. Configure Firebase for this project
```bash
cd flutternotiffcm
flutterfire configure
```

### 4. **IMPORTANT: Create NEW project (don't use existing)**
⚠️ **DO NOT** try to use the existing "flutter-e273f" project - you don't have permission!

When FlutterFire CLI asks:
- **Select project**: Choose **"Create a new project"** 
- **Project name**: Enter something like "my-fcm-app-[yourname]"
- **Select platforms**: Choose Android (and others if needed)
- FlutterFire CLI will automatically generate configuration files

### 5. Enable Cloud Messaging
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Select your project
3. Go to **Cloud Messaging** in left sidebar
4. Cloud Messaging should be automatically enabled

### 6. Run the app
```bash
flutter pub get
flutter run
```

## 🛠️ Method 2: Manual Setup

### 1. Create Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Create a project"**
3. Enter project name (e.g., "my-fcm-app")
4. Enable Google Analytics (optional)
5. Click **"Create project"**

### 2. Add Android App
1. In Firebase Console, click **"Add app"** → **Android**
2. Enter package name: `com.example.flutternotiffcm`
3. Enter app nickname (optional): "Flutter FCM App"
4. Download `google-services.json`
5. Place the file in `android/app/google-services.json`

### 3. Add iOS App (Optional)
1. In Firebase Console, click **"Add app"** → **iOS**  
2. Enter bundle ID: `com.example.flutternotiffcm`
3. Download `GoogleService-Info.plist`
4. Add to `ios/Runner/GoogleService-Info.plist`

### 4. Add Web App (Optional)
1. In Firebase Console, click **"Add app"** → **Web**
2. Enter app nickname: "Flutter FCM Web"
3. Copy the configuration object

### 5. Update Firebase Options
1. Copy `lib/firebase_options_template.dart` to `lib/firebase_options.dart`
2. Replace template values with your Firebase project configuration:
   - Replace `YOUR_PROJECT_ID` with your project ID
   - Replace `YOUR_API_KEY` values with actual API keys
   - Replace `YOUR_APP_ID` values with actual app IDs
   - Replace `YOUR_SENDER_ID` with your sender ID

### 6. Enable Cloud Messaging
1. In Firebase Console → **Cloud Messaging**
2. Cloud Messaging should be automatically enabled
3. Note your project's **Sender ID** for FCM configuration

## 🧪 Testing Setup

### 1. Run the app
```bash
flutter pub get
flutter run
```

### 2. Check FCM Token
- Open the app
- Tap the notification icon to go to **FCM Test Page**
- You should see a valid FCM token (long string starting with letters/numbers)

### 3. Test Notifications
1. Copy the FCM token from the app
2. Go to Firebase Console → **Cloud Messaging**
3. Click **"Send your first message"**
4. Enter notification title and body
5. Click **"Send test message"**
6. Paste your FCM token
7. Click **"Test"**

## 📱 Package Name Configuration

If you want to use a different package name:

### 1. Change Android Package
Edit `android/app/build.gradle.kts`:
```kotlin
android {
    namespace = "your.new.package.name"
    defaultConfig {
        applicationId = "your.new.package.name"
    }
}
```

### 2. Change iOS Bundle ID
Edit `ios/Runner/Info.plist`:
```xml
<key>CFBundleIdentifier</key>
<string>your.new.package.name</string>
```

### 3. Update Firebase Configuration
- Update Firebase apps in Console with new package/bundle ID
- Download new configuration files
- Update `firebase_options.dart` with new values

## 🔧 Troubleshooting

### Error: "Default FirebaseApp is not initialized"
- Make sure `google-services.json` is in correct location
- Ensure Firebase is initialized in `main.dart`
- Check `firebase_options.dart` has correct values

### Error: "SERVICE_NOT_AVAILABLE"
- Firebase project not configured properly
- Missing `google-services.json` file
- Wrong package name in Firebase Console
- Network connectivity issues

### Error: "No matching client found for package name"
- Package name in code doesn't match Firebase Console
- Download correct `google-services.json` for your package
- Check `applicationId` in `build.gradle.kts`

### FCM Token is null
- Firebase not initialized properly
- Google Play Services not available (emulator)
- Network connectivity issues
- Firebase project permissions

## 🚀 Success Indicators

✅ App runs without Firebase errors  
✅ FCM token is generated and displayed  
✅ Can send test notifications from Firebase Console  
✅ Notifications appear on device (foreground/background)  
✅ Topic subscription works  

---

## 📞 Need Help?

If you're still having issues:
1. Check the [Firebase Documentation](https://firebase.google.com/docs/flutter/setup)
2. Verify your `google-services.json` is valid
3. Make sure package names match exactly
4. Try the automatic FlutterFire CLI method
5. Check Firebase Console for any error messages

**Once Firebase is configured, all FCM features will work automatically!**