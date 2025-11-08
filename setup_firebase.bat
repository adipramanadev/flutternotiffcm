@echo off
REM Flutter FCM Setup Script for Windows
REM This script helps you set up Firebase configuration after cloning the repository

echo 🔥 Flutter FCM Setup Helper 🔥
echo ================================
echo.

REM Check if flutter is installed
flutter --version >nul 2>&1
if errorlevel 1 (
    echo ❌ Flutter is not installed or not in PATH
    echo Please install Flutter SDK first: https://docs.flutter.dev/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter SDK found

REM Check if firebase CLI is installed
firebase --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  Firebase CLI not found. Please install manually:
    echo npm install -g firebase-tools
    echo.
    echo After installation, run this script again.
    pause
    exit /b 1
)

echo ✅ Firebase CLI found

REM Check if flutterfire_cli is installed
flutterfire --version >nul 2>&1
if errorlevel 1 (
    echo ⚠️  FlutterFire CLI not found. Installing...
    dart pub global activate flutterfire_cli
    if errorlevel 1 (
        echo ❌ Failed to install FlutterFire CLI
        pause
        exit /b 1
    )
)

echo ✅ FlutterFire CLI found
echo.

REM Login to Firebase
echo 🔑 Logging into Firebase...
firebase login
if errorlevel 1 (
    echo ❌ Firebase login failed
    pause
    exit /b 1
)

echo ✅ Firebase login successful
echo.

REM Configure Firebase
echo 🔥 Configuring Firebase for this project...
echo.
echo ⚠️  IMPORTANT: You MUST create a NEW Firebase project!
echo ❌ DO NOT use the existing 'flutter-e273f' project
echo ✅ Choose 'Create a new project' when prompted
echo.
echo Suggested project name: my-fcm-app-%USERNAME%
echo.
pause
flutterfire configure
if errorlevel 1 (
    echo ❌ Firebase configuration failed
    pause
    exit /b 1
)

echo.
echo ✅ Firebase configuration complete!
echo.

REM Install dependencies
echo 📦 Installing Flutter dependencies...
flutter pub get
if errorlevel 1 (
    echo ❌ Failed to install dependencies
    pause
    exit /b 1
)

echo ✅ Dependencies installed
echo.

REM Final instructions
echo 🎉 Setup Complete! 🎉
echo ====================
echo.
echo Next steps:
echo 1. Enable Cloud Messaging in Firebase Console:
echo    https://console.firebase.google.com/project/YOUR_PROJECT/messaging
echo.
echo 2. Run the app:
echo    flutter run
echo.
echo 3. Test FCM:
echo    - Tap notification icon in app
echo    - Copy FCM token
echo    - Send test message from Firebase Console
echo.
echo 📖 For troubleshooting, see: SETUP_FIREBASE.md
echo.
echo Happy coding! 🚀
echo.
pause