# Firebase Setup Guide 🔥

File `firebase_options.dart` telah dibuat dengan konfigurasi template. Berikut adalah panduan lengkap untuk setup Firebase dengan FCM (Firebase Cloud Messaging).

## ⚠️ Troubleshooting Firebase CLI

Jika Anda mengalami error seperti:
```
FirebaseCommandException: An error occured on the Firebase CLI when attempting to run a command.
```

**Solusi PowerShell (Windows):**
```powershell
# 1. Ubah execution policy
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# 2. Logout dan login ulang Firebase
firebase logout
firebase login

# 3. Jika masih error, gunakan FlutterFire CLI
dart pub global activate flutterfire_cli
flutterfire configure
```

## Langkah 1: Setup Firebase Project

1. Pergi ke [Firebase Console](https://console.firebase.google.com/)
2. Buat project baru atau pilih project yang sudah ada
3. Aktifkan Firebase Cloud Messaging (FCM) di project Anda

## Langkah 2: Konfigurasi Platform

### Android
1. Di Firebase Console, tambahkan aplikasi Android
2. Gunakan package name: `com.example.flutternotiffcm` (atau sesuaikan dengan kebutuhan)
3. Download file `google-services.json`
4. Letakkan file tersebut di `android/app/google-services.json`

### iOS
1. Di Firebase Console, tambahkan aplikasi iOS
2. Gunakan bundle ID: `com.example.flutternotiffcm`
3. Download file `GoogleService-Info.plist`
4. Tambahkan file tersebut ke project iOS Anda

### Web
1. Di Firebase Console, tambahkan aplikasi Web
2. Salin konfigurasi web yang diberikan

## Langkah 3: Update firebase_options.dart

Ganti placeholder values di `lib/firebase_options.dart` dengan nilai sebenarnya dari Firebase Console:

- `YOUR_PROJECT_ID` → Project ID dari Firebase
- `YOUR_API_KEY` → API Key untuk masing-masing platform
- `YOUR_APP_ID` → App ID untuk masing-masing platform
- `YOUR_MESSAGING_SENDER_ID` → Sender ID untuk FCM
- Dan lainnya...

## Langkah 4: Konfigurasi Platform Android

Tambahkan plugin Google Services ke `android/build.gradle`:

```gradle
buildscript {
    dependencies {
        classpath 'com.google.gms:google-services:4.3.15'
    }
}
```

Tambahkan plugin ke `android/app/build.gradle`:

```gradle
apply plugin: 'com.google.gms.google-services'
```

## Langkah 5: Permissions

Tambahkan permissions yang diperlukan untuk notifikasi di `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.INTERNET" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
<uses-permission android:name="android.permission.VIBRATE" />
```

## Langkah 6: Generate firebase_options.dart dengan FlutterFire CLI (Opsional)

Untuk hasil yang lebih akurat, Anda bisa menggunakan FlutterFire CLI:

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Konfigurasi Firebase
flutterfire configure
```

Perintah ini akan otomatis mengenerate file `firebase_options.dart` dengan konfigurasi yang benar.

## 🚀 Testing FCM

1. **Jalankan aplikasi:**
```bash
flutter run
```

2. **Copy FCM Token** yang muncul di aplikasi

3. **Test notifikasi** menggunakan Firebase Console:
   - Buka Firebase Console → Cloud Messaging
   - Pilih "Send your first message"
   - Masukkan title dan body
   - Pilih target: paste FCM token yang di-copy
   - Send Test Message

## 📱 Fitur yang Sudah Diimplementasi

✅ Firebase Core integration  
✅ FCM Service dengan background/foreground handling  
✅ FCM Token display di UI  
✅ Topic subscription/unsubscription  
✅ Android configuration  
✅ Notification permissions  

## 🔧 Next Steps

- Implementasi local notifications untuk custom UI
- Navigasi berdasarkan notification data
- Analytics tracking
- Crashlytics integration

Aplikasi sekarang sudah siap untuk menerima Firebase Cloud Messaging! 🎉