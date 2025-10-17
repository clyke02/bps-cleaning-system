// Core Flutter
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// External packages
import 'package:get/get.dart';

// Screens (using barrel export)
import 'presentation/exports/screens_exports.dart';

// Services
import 'services/fcm_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize FCM
  try {
    await FCMService.initialize();
  } catch (e) {
    debugPrint('FCM initialization failed: $e');
    // Continue app execution even if FCM fails
  }

  // Performance optimizations
  _optimizeImageCache();
  _optimizeSystemSettings();

  runApp(const MyApp());
}

void _optimizeImageCache() {
  // Optimize image cache for better performance
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB
}

void _optimizeSystemSettings() {
  // Hide system overlays for better immersion
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [SystemUiOverlay.top, SystemUiOverlay.bottom]);

  // Set preferred orientations
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'BPS Cleaning System',
      debugShowCheckedModeBanner: false,
      // Performance optimizations
      showPerformanceOverlay: false,
      checkerboardRasterCacheImages: false,
      checkerboardOffscreenLayers: false,

      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Performance: Disable animations in production
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
        // Theme khusus BPS
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF2196F3),
        ),
      ),
      home: const SplashScreen(),
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminDashboardPage(),
        '/user': (context) => const UserDashboard(),
      },
    );
  }
}
