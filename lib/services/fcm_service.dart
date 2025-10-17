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

  // Initialize FCM
  static Future<void> initialize() async {
    await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

    // Request permission (Android 13+)
    final NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      announcement: true,
      criticalAlert: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      dev.log('FCM: User granted permission');
    }

    // Register background handler
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

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

    // Handle notification tap (app opened from terminated state)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      dev.log('Message tapped: ${message.data}');
      _handleNotificationTap(message.data);
    });

    // Check if app was opened from notification (terminated state)
    final RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      _handleNotificationTap(initialMessage.data);
    }
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
