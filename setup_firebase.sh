#!/bin/bash

# Flutter FCM Setup Script
# This script helps you set up Firebase configuration after cloning the repository

echo "🔥 Flutter FCM Setup Helper 🔥"
echo "================================"
echo ""

# Check if flutter is installed
if ! command -v flutter &> /dev/null; then
    echo "❌ Flutter is not installed or not in PATH"
    echo "Please install Flutter SDK first: https://docs.flutter.dev/get-started/install"
    exit 1
fi

echo "✅ Flutter SDK found"

# Check if firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo "⚠️  Firebase CLI not found. Installing..."
    npm install -g firebase-tools
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install Firebase CLI"
        echo "Please install manually: npm install -g firebase-tools"
        exit 1
    fi
fi

echo "✅ Firebase CLI found"

# Check if flutterfire_cli is installed
if ! command -v flutterfire &> /dev/null; then
    echo "⚠️  FlutterFire CLI not found. Installing..."
    dart pub global activate flutterfire_cli
    if [ $? -ne 0 ]; then
        echo "❌ Failed to install FlutterFire CLI"
        exit 1
    fi
fi

echo "✅ FlutterFire CLI found"
echo ""

# Login to Firebase
echo "🔑 Logging into Firebase..."
firebase login --no-localhost
if [ $? -ne 0 ]; then
    echo "❌ Firebase login failed"
    exit 1
fi

echo "✅ Firebase login successful"
echo ""

# Configure Firebase
echo "🔥 Configuring Firebase for this project..."
echo "Please select your Firebase project or create a new one"
echo ""
flutterfire configure
if [ $? -ne 0 ]; then
    echo "❌ Firebase configuration failed"
    exit 1
fi

echo ""
echo "✅ Firebase configuration complete!"
echo ""

# Install dependencies
echo "📦 Installing Flutter dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "❌ Failed to install dependencies"
    exit 1
fi

echo "✅ Dependencies installed"
echo ""

# Final instructions
echo "🎉 Setup Complete! 🎉"
echo "===================="
echo ""
echo "Next steps:"
echo "1. Enable Cloud Messaging in Firebase Console:"
echo "   https://console.firebase.google.com/project/YOUR_PROJECT/messaging"
echo ""
echo "2. Run the app:"
echo "   flutter run"
echo ""
echo "3. Test FCM:"
echo "   - Tap notification icon in app"
echo "   - Copy FCM token"
echo "   - Send test message from Firebase Console"
echo ""
echo "📖 For troubleshooting, see: SETUP_FIREBASE.md"
echo ""
echo "Happy coding! 🚀"