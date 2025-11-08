# 🚨 Common Errors & Solutions

This document covers common errors you might encounter after cloning the Flutter FCM repository and their solutions.

## Error: `SERVICE_NOT_AVAILABLE`

### Full Error Message:
```
I/flutter ( 5091): ❌ Error getting FCM token: [firebase_messaging/unknown] java.io.IOException: java.util.concurrent.ExecutionException: java.io.IOException: SERVICE_NOT_AVAILABLE
token null
```

### ❌ **Root Cause:**
This error occurs because Firebase is not properly configured for your development environment. When you clone this repository, you get the source code but not the Firebase configuration files that connect to a Firebase project.

## Error: `PERMISSION_DENIED` (FlutterFire CLI)

### Full Error Message:
```
Failed to write android google-services.json file write for default service file.
ServiceFileRequirementException: android - Failed to obtain the service file: google-services.json for android. Response code: 403. Response body: {
  "error": {
    "code": 403,
    "message": "The caller does not have permission",
    "status": "PERMISSION_DENIED"
  }
}
```

### ❌ **Root Cause:**
You're trying to access a Firebase project that belongs to someone else (the original repository owner). You don't have permission to access their Firebase project.

### ✅ **Solution:**
**You MUST create your own Firebase project!** Don't try to use the existing "flutter-e273f" project.

#### Quick Fix:
1. **Create new Firebase project** at [Firebase Console](https://console.firebase.google.com/)
2. **Name it something unique**: `my-fcm-app-[yourname]`
3. **Use Manual Setup**: Follow [MANUAL_SETUP.md](MANUAL_SETUP.md) for step-by-step instructions
4. **Never select existing projects** when using FlutterFire CLI

#### Alternative Solutions:
- **Option 1**: Use [MANUAL_SETUP.md](MANUAL_SETUP.md) - Most reliable
- **Option 2**: Try FlutterFire CLI again but **create new project**:
  ```bash
  flutterfire configure
  # Choose "Create a new project" - NOT existing project
  ```

### ✅ **Solutions:**

#### Option 1: Automated Setup (Recommended)
```bash
# Run the setup script
./setup_firebase.sh      # Linux/Mac
setup_firebase.bat       # Windows
```

#### Option 2: FlutterFire CLI (Quick)
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Login to Firebase
firebase login

# Configure Firebase
flutterfire configure
```

#### Option 3: Manual Setup
1. **Create Firebase Project:**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Click "Create a project"
   - Name your project (e.g., "my-fcm-app")

2. **Add Android App:**
   - Click "Add app" → Android
   - Package name: `com.example.flutternotiffcm`
   - Download `google-services.json`
   - Place in `android/app/google-services.json`

3. **Update Firebase Options:**
   ```bash
   # Copy template to actual config
   cp lib/firebase_options_template.dart lib/firebase_options.dart
   ```
   - Edit `lib/firebase_options.dart`
   - Replace `YOUR_PROJECT_ID`, `YOUR_API_KEY`, etc. with real values

4. **Enable Cloud Messaging:**
   - In Firebase Console → Cloud Messaging
   - Should be enabled automatically

### 🧪 **Verify Fix:**
```bash
flutter clean
flutter pub get
flutter run
```

You should see:
- ✅ App launches without errors
- ✅ FCM token is displayed on home screen
- ✅ Can navigate to FCM Test Page
- ✅ "FCM Ready ✅" status in test page

---

## Error: `Default FirebaseApp is not initialized`

### ❌ **Root Cause:**
Firebase initialization failed in `main.dart`

### ✅ **Solutions:**
1. Check `google-services.json` is in correct location
2. Verify `firebase_options.dart` has correct values
3. Ensure package name matches Firebase Console

---

## Error: `No matching client found for package name`

### ❌ **Root Cause:**
Package name mismatch between code and Firebase Console

### ✅ **Solutions:**
1. **Check Package Name in Code:**
   - `android/app/build.gradle.kts` → `applicationId`
   - Should be `com.example.flutternotiffcm`

2. **Check Firebase Console:**
   - Your Android app should have same package name
   - Download correct `google-services.json`

3. **Change Package Name (if needed):**
   ```kotlin
   // android/app/build.gradle.kts
   android {
       namespace = "your.new.package.name"
       defaultConfig {
           applicationId = "your.new.package.name"
       }
   }
   ```

---

## Error: Network/Connectivity Issues

### ❌ **Symptoms:**
- Token generation timeout
- Firebase connection errors
- "Unable to resolve host" errors

### ✅ **Solutions:**
1. Check internet connection
2. Try mobile data instead of WiFi
3. Disable VPN if using one
4. Check corporate firewall settings

---

## Error: Emulator Issues

### ❌ **Symptoms:**
- FCM works on real device but not emulator
- Google Play Services errors

### ✅ **Solutions:**
1. Use emulator with Google Play Store
2. Update Google Play Services in emulator
3. Test on real device instead

---

## Error: Gradle Build Failures

### ❌ **Symptoms:**
- Build fails with Google Services plugin errors
- Dependency resolution errors

### ✅ **Solutions:**
1. **Clean Project:**
   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   ```

2. **Check Google Services Plugin:**
   ```kotlin
   // android/build.gradle.kts
   plugins {
       id("com.google.gms.google-services") version "4.3.15" apply false
   }
   
   // android/app/build.gradle.kts
   plugins {
       id("com.google.gms.google-services")
   }
   ```

---

## Still Having Issues?

### 🔍 **Debugging Steps:**
1. **Check Flutter Doctor:**
   ```bash
   flutter doctor -v
   ```

2. **Verify Firebase Files:**
   ```bash
   # These files should exist:
   ls android/app/google-services.json
   ls lib/firebase_options.dart
   ```

3. **Check Firebase Console:**
   - Project exists and is active
   - Cloud Messaging is enabled
   - Android app is properly configured

4. **Test Basic Firebase:**
   ```dart
   // Add to main.dart for testing
   print("Firebase apps: ${Firebase.apps}");
   ```

### 📞 **Get Help:**
1. Read the [Firebase Documentation](https://firebase.google.com/docs/flutter/setup)
2. Check [FlutterFire Documentation](https://firebase.flutter.dev/)
3. Review `SETUP_FIREBASE.md` for complete setup guide
4. Try the automated setup scripts

### 🎯 **Success Indicators:**
After proper setup, you should see:
- ✅ `I/flutter: User granted permission: AuthorizationStatus.authorized`
- ✅ `I/flutter: FCM Token: [long token string]`
- ✅ No error messages in console
- ✅ FCM Test Page shows "FCM Ready ✅"

---

**Remember: The error `SERVICE_NOT_AVAILABLE` is almost always a Firebase configuration issue, not a code problem. Focus on getting Firebase properly set up first!**