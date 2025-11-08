import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class FCMService {
  static final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  static final FlutterLocalNotificationsPlugin _localNotifications = FlutterLocalNotificationsPlugin();
  
  // Initialize local notifications
  static Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestSoundPermission: true,
      requestBadgePermission: true,
      requestAlertPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    await _localNotifications.initialize(initSettings);
    
    // Create notification channel for Android
    const androidChannel = AndroidNotificationChannel(
      'fcm_default_channel',
      'FCM Default Channel',
      description: 'This channel is used for Firebase Cloud Messaging notifications.',
      importance: Importance.high,
    );
    
    await _localNotifications
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(androidChannel);
  }
  
  // Initialize FCM
  static Future<void> initialize() async {
    try {
      // Initialize local notifications first
      await _initializeLocalNotifications();
      
      // Request permission for notifications
      NotificationSettings settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );
      
      if (kDebugMode) {
        print('User granted permission: ${settings.authorizationStatus}');
      }
      
      // Get FCM token with retry mechanism
      String? token;
      int retryCount = 0;
      while (token == null && retryCount < 3) {
        try {
          token = await _firebaseMessaging.getToken();
          if (token != null) break;
        } catch (e) {
          if (kDebugMode) {
            print('FCM Token retrieval attempt ${retryCount + 1} failed: $e');
          }
          retryCount++;
          await Future.delayed(Duration(seconds: retryCount * 2));
        }
      }
      
      if (kDebugMode) {
        print('FCM Token: $token');
      }
      
      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      
      // Handle foreground messages
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('📱 Received foreground message: ${message.notification?.title}');
          print('📱 Message body: ${message.notification?.body}');
          print('📱 Message data: ${message.data}');
        }
        
        // Handle the message when app is in foreground
        _handleMessage(message);
      });
      
      // Handle message when app is opened from terminated state
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        if (kDebugMode) {
          print('📱 App opened from terminated state: ${message.notification?.title}');
        }
        
        // Navigate to specific screen based on message data
        _handleMessageClick(message);
      });
      
      // Check if app was opened from terminated state by clicking notification
      RemoteMessage? initialMessage = await _firebaseMessaging.getInitialMessage();
      if (initialMessage != null) {
        _handleMessageClick(initialMessage);
      }
      
    } catch (e) {
      if (kDebugMode) {
        print('❌ FCM Initialization error: $e');
      }
    }
  }
  
  // Handle message when app is in foreground
  static void _handleMessage(RemoteMessage message) {
    if (kDebugMode) {
      print('🔔 Handling foreground message: ${message.notification?.title}');
    }
    // Show local notification when app is in foreground
    _showLocalNotification(message);
  }
  
  // Show local notification for foreground messages
  static Future<void> _showLocalNotification(RemoteMessage message) async {
    const androidDetails = AndroidNotificationDetails(
      'fcm_default_channel',
      'FCM Default Channel',
      channelDescription: 'This channel is used for Firebase Cloud Messaging notifications.',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      icon: '@mipmap/ic_launcher',
    );
    
    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
    
    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );
    
    await _localNotifications.show(
      message.hashCode,
      message.notification?.title ?? 'Notifikasi Baru',
      message.notification?.body ?? 'Anda mendapat pesan baru',
      notificationDetails,
      payload: message.data.toString(),
    );
    
    if (kDebugMode) {
      print('📱 Local notification shown: ${message.notification?.title}');
    }
  }
  
  // Handle message click
  static void _handleMessageClick(RemoteMessage message) {
    if (kDebugMode) {
      print('👆 Message clicked: ${message.notification?.title}');
    }
    // Navigate to specific screen based on message data
    // Example: Get.toNamed('/notification-detail', arguments: message.data);
  }
  
  // Get FCM token
  static Future<String?> getToken() async {
    try {
      return await _firebaseMessaging.getToken();
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error getting FCM token: $e');
        
        // Check for common Firebase configuration issues
        if (e.toString().contains('SERVICE_NOT_AVAILABLE') || 
            e.toString().contains('java.io.IOException')) {
          print('');
          print('🔥 FIREBASE SETUP REQUIRED 🔥');
          print('This error usually means Firebase is not properly configured.');
          print('');
          print('📋 To fix this:');
          print('1. Create YOUR OWN Firebase project at https://console.firebase.google.com/');
          print('2. Add Android app with package: com.example.flutternotiffcm');
          print('3. Download google-services.json to android/app/');
          print('4. Copy lib/firebase_options_template.dart to lib/firebase_options.dart');
          print('5. Replace template values with your Firebase project config');
          print('');
          print('🚀 OR use FlutterFire CLI (create NEW project):');
          print('dart pub global activate flutterfire_cli');
          print('flutterfire configure');
          print('');
          print('⚠️  IMPORTANT: Do NOT try to use "flutter-e273f" project!');
          print('✅ You must create your own Firebase project for this to work.');
          print('');
        }
      }
      return null;
    }
  }
  
  // Subscribe to topic
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      if (kDebugMode) {
        print('✅ Subscribed to topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error subscribing to topic $topic: $e');
      }
    }
  }
  
  // Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      if (kDebugMode) {
        print('✅ Unsubscribed from topic: $topic');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error unsubscribing from topic $topic: $e');
      }
    }
  }
  
  // Public method for testing local notifications
  static Future<void> showTestNotification() async {
    try {
      const androidDetails = AndroidNotificationDetails(
        'fcm_default_channel',
        'FCM Default Channel',
        channelDescription: 'Test notification',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const notificationDetails = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      await _localNotifications.show(
        DateTime.now().millisecondsSinceEpoch.remainder(100000),
        'Test Notifikasi',
        'Ini adalah test notifikasi lokal dari FCM Test Page',
        notificationDetails,
        payload: 'test_notification',
      );
      
      if (kDebugMode) {
        print('🔔 Test notification sent successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ Error showing test notification: $e');
      }
      rethrow;
    }
  }
}

// Top-level function to handle background messages
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (kDebugMode) {
    print('🔥 Handling background message: ${message.messageId}');
    print('🔥 Title: ${message.notification?.title}');
    print('🔥 Body: ${message.notification?.body}');
  }
}