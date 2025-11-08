import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/fcm_service_simple.dart' as FCMService;

class FCMTestPage extends StatefulWidget {
  const FCMTestPage({super.key});

  @override
  State<FCMTestPage> createState() => _FCMTestPageState();
}

class _FCMTestPageState extends State<FCMTestPage> {
  String? _fcmToken;
  String _status = 'Initializing...';
  List<String> _messages = [];

  @override
  void initState() {
    super.initState();
    _initializeFCM();
  }

  Future<void> _initializeFCM() async {
    try {
      setState(() => _status = 'Getting FCM Token...');
      
      String? token = await FCMService.FCMService.getToken();
      setState(() {
        _fcmToken = token;
        if (token != null) {
          _status = 'FCM Ready ✅';
          _messages.add('✅ FCM initialized successfully');
          _messages.add('ℹ️ Token generated: ${token.substring(0, 20)}...');
        } else {
          _status = 'FCM Setup Required ⚠️';
          _messages.add('❌ FCM initialization failed');
          _messages.add('🔥 Firebase configuration needed');
          _messages.add('📖 See SETUP_FIREBASE.md for instructions');
          _messages.add('💡 Quick fix: Run "flutterfire configure"');
        }
      });
    } catch (e) {
      setState(() {
        _status = 'FCM Error: $e';
        _messages.add('❌ FCM Error: $e');
        _messages.add('🔧 Check Firebase configuration');
      });
    }
  }
  
  void _refreshToken() async {
    setState(() {
      _status = 'Refreshing token...';
    });
    await _initializeFCM();
  }

  void _copyToken() {
    if (_fcmToken != null) {
      Clipboard.setData(ClipboardData(text: _fcmToken!));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('FCM Token copied to clipboard!')),
      );
    }
  }

  void _subscribeToTopic() async {
    try {
      await FCMService.FCMService.subscribeToTopic('test-topic');
      setState(() {
        _messages.add('Subscribed to test-topic ✅');
      });
    } catch (e) {
      setState(() {
        _messages.add('Subscribe error: $e');
      });
    }
  }

  void _unsubscribeFromTopic() async {
    try {
      await FCMService.FCMService.unsubscribeFromTopic('test-topic');
      setState(() {
        _messages.add('Unsubscribed from test-topic ');
      });
    } catch (e) {
      setState(() {
        _messages.add('Unsubscribe error: $e');
      });
    }
  }
  
  void _sendTestNotification() async {
    try {
      setState(() {
        _messages.add('🔔 Sending test notification...');
      });
      
      await FCMService.FCMService.showTestNotification();
      
      setState(() {
        _messages.add('✅ Test notification sent successfully!');
        _messages.add('ℹ️ Check notification panel');
      });
    } catch (e) {
      setState(() {
        _messages.add('❌ Test notification failed: $e');
      });
    }
  }
  
  void _showInfo() {
    setState(() {
      _messages.add('ℹ️ FCM Test Page loaded');
      _messages.add('ℹ️ Foreground: Local notifications will show');
      _messages.add('ℹ️ Background: System notifications will show');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('FCM Test'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            onPressed: _refreshToken,
            icon: const Icon(Icons.refresh),
            tooltip: 'Refresh Token',
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Status Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FCM Status',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Text(_status),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // FCM Token Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'FCM Token',
                          style: Theme.of(context).textTheme.headlineSmall,
                        ),
                        if (_fcmToken != null)
                          ElevatedButton.icon(
                            onPressed: _copyToken,
                            icon: const Icon(Icons.copy),
                            label: const Text('Copy'),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.grey[100],
                      ),
                      child: SelectableText(
                        _fcmToken ?? 'Loading FCM Token...',
                        style: const TextStyle(fontSize: 12, fontFamily: 'monospace'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Actions
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'FCM Actions',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _subscribeToTopic,
                            child: const Text('Subscribe to test-topic'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: _unsubscribeFromTopic,
                            child: const Text('Unsubscribe'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _sendTestNotification,
                            icon: const Icon(Icons.notifications_active),
                            label: const Text('Send Test'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _showInfo,
                            icon: const Icon(Icons.info),
                            label: const Text('Show Info'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Messages Log
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Messages Log',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      height: 200,
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(8),
                        color: Colors.black87,
                      ),
                      child: SingleChildScrollView(
                        child: Text(
                          _messages.isEmpty 
                              ? 'No messages yet...' 
                              : _messages.reversed.join('\n'),
                          style: const TextStyle(
                            fontSize: 12, 
                            fontFamily: 'monospace',
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Test Instructions
            Card(
              color: Colors.blue[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.info, color: Colors.blue),
                        const SizedBox(width: 8),
                        Text(
                          'Testing Instructions',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Text('1. Copy the FCM Token above'),
                    const Text('2. Go to Firebase Console → Cloud Messaging'),
                    const Text('3. Click "Send your first message"'),
                    const Text('4. Enter title and body for the notification'),
                    const Text('5. Paste FCM Token in "Send test message to device"'),
                    const Text('6. Click Send'),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}