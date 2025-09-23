import 'package:flutter/material.dart';
import 'screens/auth/login_page.dart';
import 'screens/admin/admin_dashboard.dart';
import 'screens/user/user_dashboard.dart';
import 'screens/admin/staff_management/staff_dashboard.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BPS Cleaning System',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
        // Theme khusus BPS
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF4CAF50),
          primary: const Color(0xFF4CAF50),
          secondary: const Color(0xFF2196F3),
        ),
      ),
      home: const LoginPage(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/admin': (context) => const AdminDashboardPage(),
        '/user': (context) => const UserDashboard(),
        '/admin/staff_management': (context) => const StaffDashboard(),
      },
    );
  }
}
