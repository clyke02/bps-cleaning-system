import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../../config/environment.dart';
import '../../../../../../shared/widgets/custom_snackbar.dart';

class RiwayatController extends GetxController {
  var isLoading = false.obs;
  var historyList = <Map<String, dynamic>>[].obs;
  var selectedFilter = 'Semua'.obs;

  @override
  void onInit() {
    super.onInit();
    loadHistoryData();
  }

  Future<void> loadHistoryData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userId = prefs.getInt('user_id');

      if (token == null || userId == null) {
        print('⚠️ Token or User ID not found');
        return;
      }

      print('🔄 Loading riwayat for user $userId...');
      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/user-reports/$userId'),
        headers: {'Authorization': 'Bearer $token', 'Accept': 'application/json'},
      );

      print('📊 Riwayat Response: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          historyList.value = (data['data'] as List).cast<Map<String, dynamic>>();
          print('✅ Loaded ${historyList.length} riwayat items');
        }
      } else {
        print('❌ Failed to load riwayat: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Error loading riwayat: $e');
      CustomSnackbar.showError(title: 'Error', message: 'Gagal memuat riwayat: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  // Filter riwayat berdasarkan status
  List<Map<String, dynamic>> get filteredHistory {
    if (selectedFilter.value == 'Semua') {
      return historyList;
    }
    return historyList.where((item) {
      final status = item['status']?.toString().toLowerCase() ?? '';
      final filter = selectedFilter.value.toLowerCase();

      if (filter == 'selesai') return status == 'approved';
      if (filter == 'menunggu') return status == 'pending';
      if (filter == 'ditolak') return status == 'rejected';

      return true;
    }).toList();
  }

  // Get status display
  String getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return 'Selesai';
      case 'pending':
        return 'Menunggu';
      case 'rejected':
        return 'Ditolak';
      default:
        return status;
    }
  }

  Future<void> refreshData() async {
    await loadHistoryData();
  }
}
