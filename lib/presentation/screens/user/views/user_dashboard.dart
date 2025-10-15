import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';
import '../user_navbar.dart';
import '../modules/home/views/home_view.dart';
import '../modules/laporanDarurat/views/report_view.dart';
import '../modules/riwayat/views/riwayat_view.dart';
import '../modules/profile/views/profile_view.dart';
import '../modules/home/controllers/home_controller.dart';

class UserDashboard extends StatefulWidget {
  const UserDashboard({super.key});

  @override
  State<UserDashboard> createState() => _UserDashboardState();
}

class _UserDashboardState extends State<UserDashboard> {
  int _selectedIndex = 0;
  String _userName = 'User';

  @override
  void initState() {
    super.initState();
    _loadUserData();

    // Auto refresh home data saat dashboard dibuka
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().refreshData();
      }
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    final userName = prefs.getString('user_name');
    if (userName != null && userName.isNotEmpty) {
      setState(() {
        _userName = userName;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      extendBodyBehindAppBar: false,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 2,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF4CAF50).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset('assets/images/logo.png', width: 28, height: 28, fit: BoxFit.contain),
            ),
            const SizedBox(width: 10),
            const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BPS Sukabumi',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Colors.black87),
                ),
                Text(
                  'User Dashboard',
                  style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w500, fontSize: 11),
                ),
              ],
            ),
          ],
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(color: Colors.grey.shade100, borderRadius: BorderRadius.circular(20)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFF4CAF50)),
                  child: const Icon(Icons.person, size: 14, color: Colors.white),
                ),
                const SizedBox(width: 6),
                Text(
                  _userName,
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ],
            ),
          ),
        ],
      ),
      body: _buildContent(),
      bottomNavigationBar: UserNavbar(
        currentIndex: _selectedIndex,
        onTabSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });

          // Auto refresh data ketika kembali ke home
          if (index == 0) {
            // Home tab
            if (Get.isRegistered<HomeController>()) {
              Get.find<HomeController>().refreshData();
            }
          }
        },
      ),
    );
  }

  Widget _buildContent() {
    switch (_selectedIndex) {
      case 0:
        return const HomeView(key: ValueKey('home'));
      case 1:
        return const ReportView(key: ValueKey('report'));
      case 2:
        return const RiwayatView(key: ValueKey('riwayat'));
      case 3:
        return const ProfileView(key: ValueKey('profile'));
      default:
        return const HomeView(key: ValueKey('home_default'));
    }
  }
}
