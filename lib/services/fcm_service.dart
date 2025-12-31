import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'dart:developer' as dev;
import '../firebase_options.dart';
import '../shared/widgets/custom_snackbar.dart';

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  dev.log('Background message: ${message.notification?.title}');
}

class FCMService {
  static final FirebaseMessaging _messaging = FirebaseMessaging.instance;

  // Initialize FCM without requesting permission (called in main.dart)
  static Future<void> initializeWithoutPermission() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Setup message handlers (will be called after permission granted)
    _setupMessageHandlers();
  }

  // Request notification permission (called in splash screen)
  static Future<bool> requestNotificationPermission() async {
    try {
      // Check current permission status
      final NotificationSettings currentSettings = await _messaging.getNotificationSettings();

      // If already authorized, skip request
      if (currentSettings.authorizationStatus == AuthorizationStatus.authorized) {
        dev.log('✅ Notification permission already granted');
        return true;
      }

      // Request permission
      final NotificationSettings settings = await _messaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        announcement: false,
        criticalAlert: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        dev.log('✅ User granted notification permission');
        return true;
      } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
        dev.log('⚠️ User granted provisional notification permission');
        return true;
      } else {
        dev.log('❌ User declined notification permission');
        return false;
      }
    } catch (e) {
      dev.log('❌ Error requesting notification permission: $e');
      return false;
    }
  }

  // Setup message handlers for foreground and background notifications
  static void _setupMessageHandlers() {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      dev.log('Foreground message: ${message.notification?.title}');

      if (message.notification != null) {
        CustomSnackbar.showInfo(
          title: message.notification!.title ?? 'Notifikasi',
          message: message.notification!.body ?? '',
        );
      }
    });

    // Handle notification tap (app opened from background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dev.log('Message tapped: ${message.data}');
      _handleNotificationTap(message.data);
    });

    // Check if app was opened from notification (terminated state)
    _messaging.getInitialMessage().then((RemoteMessage? initialMessage) {
      if (initialMessage != null) {
        _handleNotificationTap(initialMessage.data);
      }
    });
  }

  // Get FCM token
  static Future<String?> getToken() async {
    try {
      final String? token = await _messaging.getToken();
      dev.log('FCM Token: $token');
      return token;
    } catch (e) {
      dev.log('Error getting FCM token: $e');
      return null;
    }
  }

  // Handle notification tap navigation
  static void _handleNotificationTap(Map<String, dynamic> data) {
    final String? type = data['type'];

    switch (type) {
      case 'new_assignment':
        Get.offAllNamed('/user'); // Navigate to user home
        break;
      case 'report_reviewed':
        Get.offAllNamed('/user'); // Navigate to user riwayat
        break;
      case 'new_report':
        Get.offAllNamed('/admin'); // Navigate to admin laporan
        break;
    }
  }
}
