#!/bin/bash

# Firebase Configuration Checker
# This script checks if you have proper Firebase configuration after cloning

echo "🔍 Firebase Configuration Checker"
echo "=================================="
echo ""

# Check if we're in the right directory
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ Error: Run this script from the Flutter project root directory"
    exit 1
fi

echo "✅ Running from Flutter project directory"
echo ""

# Check google-services.json
echo "📋 Checking Android Configuration..."
if [ ! -f "android/app/google-services.json" ]; then
    echo "❌ Missing: android/app/google-services.json"
    echo "   You need to download this from your Firebase project"
else
    # Check if it's the template file
    if grep -q "your-project-id" "android/app/google-services.json"; then
        echo "⚠️  Template file detected: android/app/google-services.json"
        echo "   You need to replace this with the real file from Firebase Console"
    else
        echo "✅ Found: android/app/google-services.json (appears to be real config)"
    fi
fi

echo ""

# Check firebase_options.dart
echo "📋 Checking Flutter Configuration..."
if [ ! -f "lib/firebase_options.dart" ]; then
    echo "❌ Missing: lib/firebase_options.dart"
    if [ -f "lib/firebase_options_template.dart" ]; then
        echo "   Template available: lib/firebase_options_template.dart"
        echo "   Copy this to lib/firebase_options.dart and configure it"
    fi
else
    # Check if it's the template file
    if grep -q "YOUR_PROJECT_ID" "lib/firebase_options.dart"; then
        echo "⚠️  Template file detected: lib/firebase_options.dart"
        echo "   You need to replace template values with your Firebase project config"
    else
        echo "✅ Found: lib/firebase_options.dart (appears to be configured)"
    fi
fi

echo ""

# Summary and recommendations
echo "📋 Summary:"
echo "==========="

missing_config=false

if [ ! -f "android/app/google-services.json" ] || grep -q "your-project-id" "android/app/google-services.json" 2>/dev/null; then
    echo "❌ Android configuration incomplete"
    missing_config=true
fi

if [ ! -f "lib/firebase_options.dart" ] || grep -q "YOUR_PROJECT_ID" "lib/firebase_options.dart" 2>/dev/null; then
    echo "❌ Flutter configuration incomplete"
    missing_config=true
fi

if [ "$missing_config" = true ]; then
    echo ""
    echo "🔥 Firebase setup required!"
    echo ""
    echo "📖 Next steps:"
    echo "1. Create your own Firebase project (don't use flutter-e273f)"
    echo "2. Follow MANUAL_SETUP.md for step-by-step instructions"
    echo "3. Or try: flutterfire configure (create NEW project)"
    echo ""
    echo "📚 Documentation:"
    echo "- MANUAL_SETUP.md - Manual setup guide"
    echo "- SETUP_FIREBASE.md - Complete setup instructions"  
    echo "- TROUBLESHOOTING.md - Common issues and solutions"
else
    echo "✅ Firebase configuration appears complete!"
    echo ""
    echo "🚀 Ready to run:"
    echo "flutter run"
    echo ""
    echo "🧪 Test FCM:"
    echo "1. Run the app"
    echo "2. Check if FCM token appears on home screen"
    echo "3. Tap notification icon for FCM Test Page"
fi

echo ""