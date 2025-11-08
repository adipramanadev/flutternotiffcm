@echo off
REM Firebase Configuration Checker for Windows
REM This script checks if you have proper Firebase configuration after cloning

echo 🔍 Firebase Configuration Checker
echo ==================================
echo.

REM Check if we're in the right directory
if not exist "pubspec.yaml" (
    echo ❌ Error: Run this script from the Flutter project root directory
    pause
    exit /b 1
)

echo ✅ Running from Flutter project directory
echo.

REM Check google-services.json
echo 📋 Checking Android Configuration...
if not exist "android\app\google-services.json" (
    echo ❌ Missing: android\app\google-services.json
    echo    You need to download this from your Firebase project
) else (
    REM Check if it's the template file
    findstr /C:"your-project-id" "android\app\google-services.json" >nul 2>&1
    if not errorlevel 1 (
        echo ⚠️  Template file detected: android\app\google-services.json
        echo    You need to replace this with the real file from Firebase Console
    ) else (
        echo ✅ Found: android\app\google-services.json ^(appears to be real config^)
    )
)

echo.

REM Check firebase_options.dart
echo 📋 Checking Flutter Configuration...
if not exist "lib\firebase_options.dart" (
    echo ❌ Missing: lib\firebase_options.dart
    if exist "lib\firebase_options_template.dart" (
        echo    Template available: lib\firebase_options_template.dart
        echo    Copy this to lib\firebase_options.dart and configure it
    )
) else (
    REM Check if it's the template file
    findstr /C:"YOUR_PROJECT_ID" "lib\firebase_options.dart" >nul 2>&1
    if not errorlevel 1 (
        echo ⚠️  Template file detected: lib\firebase_options.dart
        echo    You need to replace template values with your Firebase project config
    ) else (
        echo ✅ Found: lib\firebase_options.dart ^(appears to be configured^)
    )
)

echo.

REM Summary and recommendations
echo 📋 Summary:
echo ===========

set missing_config=false

if not exist "android\app\google-services.json" set missing_config=true
if exist "android\app\google-services.json" (
    findstr /C:"your-project-id" "android\app\google-services.json" >nul 2>&1
    if not errorlevel 1 set missing_config=true
)

if not exist "lib\firebase_options.dart" set missing_config=true
if exist "lib\firebase_options.dart" (
    findstr /C:"YOUR_PROJECT_ID" "lib\firebase_options.dart" >nul 2>&1
    if not errorlevel 1 set missing_config=true
)

if "%missing_config%"=="true" (
    echo ❌ Android configuration incomplete
    echo ❌ Flutter configuration incomplete
    echo.
    echo 🔥 Firebase setup required!
    echo.
    echo 📖 Next steps:
    echo 1. Create your own Firebase project ^(don't use flutter-e273f^)
    echo 2. Follow MANUAL_SETUP.md for step-by-step instructions
    echo 3. Or try: flutterfire configure ^(create NEW project^)
    echo.
    echo 📚 Documentation:
    echo - MANUAL_SETUP.md - Manual setup guide
    echo - SETUP_FIREBASE.md - Complete setup instructions
    echo - TROUBLESHOOTING.md - Common issues and solutions
) else (
    echo ✅ Firebase configuration appears complete!
    echo.
    echo 🚀 Ready to run:
    echo flutter run
    echo.
    echo 🧪 Test FCM:
    echo 1. Run the app
    echo 2. Check if FCM token appears on home screen
    echo 3. Tap notification icon for FCM Test Page
)

echo.
pause