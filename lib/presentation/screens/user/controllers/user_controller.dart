import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../data/models/petugas_model.dart';
import '../../../../config/environment.dart';

class UserController extends GetxController {
  // Observable variables untuk user yang login
  final RxList<Petugas> userList = <Petugas>[].obs;
  final RxList<Petugas> filteredUserList = <Petugas>[].obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedFilter = 'semua'.obs; // semua, aktif, tidak_aktif

  // Statistics
  final RxInt totalPetugas = 0.obs;
  final RxInt activePetugas = 0.obs;
  final RxInt inactivePetugas = 0.obs;
  final RxDouble averageCompletion = 0.0.obs;

  @override
  void onInit() {
    super.onInit();
    loadPetugas();

    // Listen to search and filter changes
    ever(searchQuery, (_) => _applyFilters());
    ever(selectedFilter, (_) => _applyFilters());
  }

  // Load all petugas data
  Future<void> loadPetugas() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      if (token == null) {
        errorMessage.value = 'Token tidak ditemukan';
        return;
      }

      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/users'),
        headers: {'Authorization': 'Bearer $token', 'Content-Type': 'application/json', 'Accept': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);

        if (data['success'] == true && data['data'] != null) {
          final List<dynamic> petugasList = data['data'];

          userList.value = petugasList.map((item) => Petugas.fromJson(item)).toList();

          if (Environment.isDebug) {
            print('DEBUG: Loaded ${userList.length} petugas');
          }
        } else {
          userList.clear();
        }
      } else {
        throw Exception('Failed to load petugas: ${response.statusCode}');
      }

      _updateStatistics();
      _applyFilters();
    } catch (e) {
      if (Environment.isDebug) {
        print('DEBUG: Error loading petugas: $e');
      }
      errorMessage.value = 'Gagal memuat data petugas: ${e.toString()}';
      Get.snackbar('Error', errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  // Add new petugas
  Future<bool> addPetugas({
    required String nama,
    required String username,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      // TODO: Implement API call to create petugas
      // final response = await _apiService.post('/petugas', {
      //   'nama': nama,
      //   'username': username,
      //   'phone': phone,
      //   'password': password,
      //   'role': role,
      // });

      Get.snackbar(
        'Sukses',
        'Petugas berhasil ditambahkan!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadPetugas();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menambahkan petugas: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update petugas
  Future<bool> updatePetugas({
    required int id,
    required String nama,
    required String username,
    required String phone,
    String? password,
    required String role,
  }) async {
    try {
      isLoading.value = true;

      // TODO: Implement API call to update petugas
      // final response = await _apiService.put('/petugas/$id', {
      //   'nama': nama,
      //   'username': username,
      //   'phone': phone,
      //   if (password != null) 'password': password,
      //   'role': role,
      // });

      Get.snackbar(
        'Sukses',
        'Data petugas berhasil diperbarui!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadPetugas();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui petugas: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete petugas
  Future<bool> deletePetugas(int id) async {
    try {
      isLoading.value = true;

      // TODO: Implement API call to delete petugas
      // await _apiService.delete('/petugas/$id');

      Get.snackbar(
        'Sukses',
        'Petugas berhasil dihapus!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadPetugas();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal menghapus petugas: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update petugas status
  Future<bool> updatePetugasStatus(int id, String status) async {
    try {
      // TODO: Implement API call to update status
      // await _apiService.patch('/petugas/$id/status', {'status': status});

      Get.snackbar(
        'Sukses',
        'Status petugas berhasil diperbarui!',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Get.theme.primaryColor,
        colorText: Get.theme.colorScheme.onPrimary,
      );

      await loadPetugas();
      return true;
    } catch (e) {
      Get.snackbar('Error', 'Gagal memperbarui status: ${e.toString()}', snackPosition: SnackPosition.BOTTOM);
      return false;
    }
  }

  // Search functionality
  void searchPetugas(String query) {
    searchQuery.value = query;
  }

  // Filter functionality
  void filterPetugas(String filter) {
    selectedFilter.value = filter;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  // Apply filters and search
  void _applyFilters() {
    var filtered = userList.toList();

    // Apply status filter
    if (selectedFilter.value != 'semua') {
      filtered = filtered.where((petugas) {
        switch (selectedFilter.value) {
          case 'aktif':
            return petugas.status == 'active';
          case 'tidak_aktif':
            return petugas.status == 'inactive';
          default:
            return true;
        }
      }).toList();
    }

    // Apply search filter
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((petugas) {
        final query = searchQuery.value.toLowerCase();
        return petugas.nama.toLowerCase().contains(query) ||
            petugas.username.toLowerCase().contains(query) ||
            petugas.phone.contains(query) ||
            petugas.displayRole.toLowerCase().contains(query);
      }).toList();
    }

    filteredUserList.assignAll(filtered);
  }

  // Update statistics
  void _updateStatistics() {
    totalPetugas.value = userList.length;
    activePetugas.value = userList.where((p) => p.status == 'active').length;
    inactivePetugas.value = userList.where((p) => p.status == 'inactive').length;

    if (userList.isNotEmpty) {
      final totalCompletion = userList.map((p) => p.completionRate).reduce((a, b) => a + b);
      averageCompletion.value = totalCompletion / userList.length;
    } else {
      averageCompletion.value = 0.0;
    }
  }

  // Get weekly summary for dashboard
  Map<String, int> get weeklySummary {
    return {
      'total': totalPetugas.value,
      'aktif': activePetugas.value,
      'tidak_aktif': inactivePetugas.value,
      'tugas_selesai': userList.fold(0, (sum, p) => sum + p.completedTask),
    };
  }
}
