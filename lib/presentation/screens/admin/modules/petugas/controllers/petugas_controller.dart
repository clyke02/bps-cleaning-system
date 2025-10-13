import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../../data/models/user.dart';
import '../../../../../../data/repositories/user_repository.dart';

class PetugasController extends GetxController {
  final UserRepository _userRepository = UserRepository();

  // Observable variables
  final RxList<User> staffList = <User>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;

  // Form controllers for add/edit
  final RxString selectedRole = ''.obs;
  final RxBool isSubmitting = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadUsers();
  }

  // Load all users (alias for backward compatibility)
  Future<void> loadStaff() async => loadUsers();

  // Load all users
  Future<void> loadUsers() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final users = await _userRepository.getAllUsers();
      staffList.assignAll(users);
    } catch (e) {
      errorMessage.value = e.toString();
      Get.snackbar(
        'Error',
        'Gagal memuat data petugas: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Create new user
  Future<bool> createUser({
    required String name,
    required String username,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      isSubmitting.value = true;

      await _userRepository.createUser(
        name: name,
        username: username,
        phone: phone,
        password: password,
        role: role,
      );

      Get.snackbar(
        'Sukses',
        '${role == 'admin' ? 'Admin' : 'Petugas'} berhasil ditambahkan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      // Reload data
      await loadUsers();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menambahkan ${role == 'admin' ? 'admin' : 'petugas'}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Update user
  Future<bool> updateUser({
    required int id,
    required String name,
    required String username,
    required String phone,
    String? password,
    required String role,
  }) async {
    try {
      isSubmitting.value = true;

      await _userRepository.updateUser(
        id: id,
        name: name,
        username: username,
        phone: phone,
        password: password,
        role: role,
      );

      Get.snackbar(
        'Sukses',
        '${role == 'admin' ? 'Admin' : 'Petugas'} berhasil diperbarui!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      // Reload data
      await loadUsers();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal memperbarui ${role == 'admin' ? 'admin' : 'petugas'}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    } finally {
      isSubmitting.value = false;
    }
  }

  // Delete user
  Future<bool> deleteUser(User user) async {
    try {
      await _userRepository.deleteUser(user.id);

      Get.snackbar(
        'Sukses',
        '${user.displayRole} ${user.name} berhasil dihapus!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      // Reload data
      await loadUsers();
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Gagal menghapus ${user.displayRole}: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  // Confirm delete
  void confirmDelete(User user) {
    Get.dialog(
      AlertDialog(
        title: const Text('Konfirmasi Hapus'),
        content: Text(
          'Apakah Anda yakin ingin menghapus ${user.displayRole} ${user.name}?',
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Batal')),
          TextButton(
            onPressed: () {
              Get.back();
              deleteUser(user);
            },
            style: TextButton.styleFrom(
              foregroundColor: Get.theme.colorScheme.error,
            ),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }

  // Get weekly summary
  Map<String, int> get weeklySummary {
    final adminCount = staffList.where((user) => user.isAdmin).length;
    final userCount = staffList.where((user) => !user.isAdmin).length;

    return {
      'total_petugas': userCount,
      'total_admin': adminCount,
      'total_all': staffList.length,
    };
  }
}
