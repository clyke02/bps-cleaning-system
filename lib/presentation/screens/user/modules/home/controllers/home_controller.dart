import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../config/environment.dart';

class HomeController extends GetxController {
  var userName = 'User'.obs;
  var isLoading = false.obs;
  var isLoadingAreas = false.obs;
  var areaList = <dynamic>[].obs;
  var userReports = <dynamic>[].obs; // Laporan user hari ini

  @override
  void onInit() {
    super.onInit();
    Environment.printConfig(); // Print konfigurasi saat init
    loadUserData();
    loadAreas();
    loadUserReports();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name');
      if (name != null && name.isNotEmpty) {
        userName.value = name;
      }
    } catch (e) {
      print('Error loading user data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadAreas() async {
    try {
      isLoadingAreas.value = true;
      final baseUrl = Environment.baseUrl;
      print('Loading areas from: $baseUrl/areas');

      final response = await http
          .get(
            Uri.parse('$baseUrl/areas'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          areaList.value = data['data'];
          print('Areas loaded successfully: ${areaList.length} areas');
        } else {
          print('API returned success: false or no data');
          areaList.value = [];
        }
      } else {
        print('Failed to load areas: ${response.statusCode}');
        print('Response: ${response.body}');
        areaList.value = [];
      }
    } catch (e) {
      print('Error loading areas: $e');
      areaList.value = [];
    } finally {
      isLoadingAreas.value = false;
    }
  }

  Future<void> loadUserReports() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        print('User ID not found');
        return;
      }

      final baseUrl = Environment.baseUrl;
      final response = await http.get(
        Uri.parse('$baseUrl/cleaning-reports?user_id=$userId'),
        headers: {'Accept': 'application/json'},
      );

      print('User reports response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          userReports.value = data['data'] ?? [];
          print('Loaded ${userReports.length} user reports');
        }
      }
    } catch (e) {
      print('Error loading user reports: $e');
    }
  }

  // Get report status for specific area
  Map<String, dynamic>? getAreaReportStatus(int areaId) {
    try {
      // Find latest report for this area today
      final today = DateTime.now();
      final reportsForArea = userReports.where((report) {
        final reportAreaId = report['area']?['id'];
        final reportDate = DateTime.parse(report['submission_date'] ?? '');
        return reportAreaId == areaId &&
            reportDate.year == today.year &&
            reportDate.month == today.month &&
            reportDate.day == today.day;
      }).toList();

      if (reportsForArea.isNotEmpty) {
        // Return latest report
        return reportsForArea.first;
      }
      return null;
    } catch (e) {
      print('Error getting area report status: $e');
      return null;
    }
  }

  Future<void> refreshData() async {
    print('DEBUG: Refreshing home data...');
    await Future.wait([loadUserData(), loadAreas(), loadUserReports()]);
  }

  void clearData() {
    areaList.clear();
    isLoading.value = false;
    isLoadingAreas.value = false;
    print('DEBUG: Home data cleared');
  }

  @override
  void onReady() {
    super.onReady();
    // Load data when controller is ready
    loadAreas();
  }
}
