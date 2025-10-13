import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../home/controllers/home_controller.dart';

class ProfileController extends GetxController {
  var userName = 'User'.obs;
  var userEmail = 'user@example.com'.obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserData();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name');
      final email = prefs.getString('user_email');

      if (name != null && name.isNotEmpty) {
        userName.value = name;
      }
      if (email != null && email.isNotEmpty) {
        userEmail.value = email;
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void showLogoutConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah Anda yakin ingin keluar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await performLogout();
              },
              child: const Text('Logout', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  Future<void> performLogout() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.clear();

      // Clear home data saat logout
      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().clearData();
      }

      // Navigate to login and clear all previous routes
      Get.offAllNamed('/login');
    } catch (e) {
      print('Logout error: ${e.toString()}');
      // Still navigate even if there's an error clearing prefs
      Get.offAllNamed('/login');
    }
  }

  Future<void> refreshData() async {
    await loadUserData();
  }
}
