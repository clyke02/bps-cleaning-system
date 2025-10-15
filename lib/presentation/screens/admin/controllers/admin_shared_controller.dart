import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../config/environment.dart';

class AdminSharedController extends GetxController {
  var weeklySummary = <String, dynamic>{
    'selesai': 0,
    'menunggu': 0,
    'ditolak': 0,
  }.obs;

  var isLoadingSummary = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadWeeklySummary();
  }

  Future<void> loadWeeklySummary() async {
    try {
      isLoadingSummary.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // FIX: gunakan key yang benar

      if (token == null) {
        print('⚠️ Token not found in SharedPreferences');
        return;
      }

      print('🔄 Loading weekly summary from API...');
      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/weekly-summary'),
        headers: {
          'Authorization': 'Bearer $token',
          'Accept': 'application/json',
        },
      );

      print('📊 Weekly Summary Response: ${response.statusCode}');
      print('📦 Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          weeklySummary.value = {
            'selesai': data['data']['selesai'] ?? 0,
            'menunggu': data['data']['menunggu'] ?? 0,
            'ditolak': data['data']['ditolak'] ?? 0,
          };
          print(
            '✅ Weekly summary loaded successfully: Selesai=${weeklySummary['selesai']}, Menunggu=${weeklySummary['menunggu']}, Ditolak=${weeklySummary['ditolak']}',
          );
        } else {
          print('⚠️ Response success is false or data is null');
        }
      } else {
        print('❌ Failed to load weekly summary: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('❌ Error loading weekly summary: $e');
    } finally {
      isLoadingSummary.value = false;
    }
  }

  Future<void> refreshSummary() async {
    await loadWeeklySummary();
  }
}
