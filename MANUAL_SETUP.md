# 🔧 Manual Firebase Setup (Alternative to FlutterFire CLI)

Use this guide if you're getting `PERMISSION_DENIED` errors with FlutterFire CLI.

## 🚨 Why You Need This

If you see this error:
```
ServiceFileRequirementException: android - Failed to obtain the service file: google-services.json for android. Response code: 403. Response body: {
  "error": {
    "code": 403,
    "message": "The caller does not have permission",
    "status": "PERMISSION_DENIED"
  }
}
```

**This means you're trying to access someone else's Firebase project. You need to create your own!**

## 🛠️ Step-by-Step Manual Setup

### Step 1: Create Your Firebase Project
1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **"Create a project"**
3. **Project name**: Enter `my-fcm-app-[yourname]` (e.g., `my-fcm-app-john`)
4. **Google Analytics**: Choose "Enable" or "Not right now" (your choice)
5. Click **"Create project"**
6. Wait for project creation to complete

### Step 2: Add Android App
1. In your new Firebase project, click **"Add app"**
2. Select **Android** icon
3. **Android package name**: `com.example.flutternotiffcm`
4. **App nickname**: `Flutter FCM App` (optional)
5. Click **"Register app"**

### Step 3: Download Configuration File
1. Click **"Download google-services.json"**
2. Save the file to your computer
3. **Move the file** to `android/app/google-services.json` in your Flutter project
4. **Replace** the existing file if it exists

### Step 4: Update Firebase Options
1. Copy the template file:
   ```bash
   # Windows
   copy lib\firebase_options_template.dart lib\firebase_options.dart
   
   # Linux/Mac
   cp lib/firebase_options_template.dart lib/firebase_options.dart
   ```

2. Open `lib/firebase_options.dart` in your editor

3. **Get your project values:**
   - In Firebase Console, go to **Project Settings** (gear icon)
   - Scroll down to **"Your apps"** section
   - Click on your Android app
   - Copy the configuration values

4. **Replace template values:**
   ```dart
   // Replace these in firebase_options.dart:
   static const FirebaseOptions android = FirebaseOptions(
     apiKey: 'YOUR_ANDROID_API_KEY',        // From Firebase Console
     appId: 'YOUR_ANDROID_APP_ID',          // From Firebase Console  
     messagingSenderId: 'YOUR_SENDER_ID',   // From Firebase Console
     projectId: 'YOUR_PROJECT_ID',          // Your project name
     storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
   );
   ```

### Step 5: Enable Cloud Messaging
1. In Firebase Console, go to **"Cloud Messaging"** in left sidebar
2. Cloud Messaging should be automatically enabled
3. Note your **Server Key** and **Sender ID** (you'll need these for testing)

### Step 6: Test Your Setup
1. Clean and rebuild:
   ```bash
   flutter clean
   flutter pub get
   flutter run
   ```

2. **Success indicators:**
   - App launches without Firebase errors
   - You see a long FCM token on the home screen
   - FCM Test Page shows "FCM Ready ✅"

## 🧪 Verify Setup Works

### Test Local Notifications:
1. Open app → Tap notification icon
2. Tap **"Send Test"** button
3. You should see a notification appear

### Test Firebase Console:
1. Copy FCM token from app
2. Go to Firebase Console → **Cloud Messaging**
3. Click **"Send your first message"**
4. Enter title/body, paste token, click **"Test"**
5. You should receive the notification

## 🔧 Troubleshooting Manual Setup

### Error: "Default FirebaseApp is not initialized"
- Check `google-services.json` is in `android/app/`
- Verify `firebase_options.dart` has correct values
- Make sure project ID matches between files

### Error: "No matching client found for package name"  
- Package name in `google-services.json` must be `com.example.flutternotiffcm`
- Re-download `google-services.json` with correct package name

### FCM Token is still null
- Clean project: `flutter clean && flutter pub get`
- Check internet connection
- Verify all Firebase values are correct
- Try on real device instead of emulator

## 📝 Configuration Template

Here's what your `firebase_options.dart` should look like after setup:

```dart
static const FirebaseOptions android = FirebaseOptions(
  apiKey: 'AIzaSyB...', // Your actual API key
  appId: '1:123456789:android:abc123def456', // Your actual app ID
  messagingSenderId: '123456789', // Your actual sender ID
  projectId: 'my-fcm-app-john', // Your project name
  storageBucket: 'my-fcm-app-john.firebasestorage.app',
);
```

## ✅ Success Checklist

- [ ] Created my own Firebase project (not using flutter-e273f)
- [ ] Downloaded `google-services.json` to `android/app/`
- [ ] Updated `firebase_options.dart` with my project values
- [ ] App runs without Firebase errors
- [ ] FCM token appears on home screen
- [ ] Can send test notifications locally
- [ ] Can receive notifications from Firebase Console

---

**Remember: The key is creating YOUR OWN Firebase project. Never try to use someone else's Firebase configuration!**