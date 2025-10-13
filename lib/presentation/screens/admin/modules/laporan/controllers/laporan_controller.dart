import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../data/models/report_model.dart';
import '../../../../../../config/environment.dart';

class LaporanController extends GetxController {
  // Reactive Variables
  final RxList<Report> reportList = <Report>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ReportStatus?> selectedFilter = Rx<ReportStatus?>(null);

  // Weekly Summary
  final Rx<Map<String, int>> weeklySummary = Rx<Map<String, int>>({
    'Selesai': 0,
    'Menunggu': 0,
    'Ditolak': 0,
  });

  // Filtered reports based on search and status
  List<Report> get filteredReports {
    var filtered = reportList.toList();

    // Filter by status
    if (selectedFilter.value != null) {
      filtered = filtered
          .where((report) => report.status == selectedFilter.value)
          .toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((report) {
        return report.title.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            report.petugas.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            report.status.toString().toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  @override
  void onReady() {
    super.onReady();
    // Auto refresh saat controller ready
    loadReports();
  }

  // Load all reports
  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      print('Loading reports from API...');

      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/cleaning-reports'),
        headers: {'Accept': 'application/json'},
      );

      print('Reports response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final List<dynamic> reportsJson = data['data'] ?? [];
          reportList.value = reportsJson.map((json) {
            // Map backend data to frontend Report model
            return Report(
              id: json['id'] ?? 0,
              title: json['title'] ?? 'Laporan',
              petugas: json['user']?['name'] ?? 'Unknown',
              tanggal:
                  json['submission_date'] ?? DateTime.now().toIso8601String(),
              status: _mapStatus(json['status']),
              imagePaths:
                  (json['photos'] as List?)
                      ?.map((p) => p['photo_path'] as String)
                      .toList() ??
                  [],
              catatanPetugas: json['description'] ?? '',
              catatanAdmin: json['admin_notes'],
              areaId: json['area']?['id'] ?? 0,
              tasks:
                  (json['tasks'] as List?)
                      ?.map(
                        (t) => CleaningTask(
                          id: t['id'] ?? 0,
                          description: t['task_name'] ?? '',
                          isCompleted: t['is_completed'] ?? false,
                        ),
                      )
                      .toList() ??
                  [],
            );
          }).toList();

          print('Loaded ${reportList.length} reports');

          // Update weekly summary
          _updateWeeklySummary();
        }
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat laporan: ${e.toString()}';
      print('Error loading reports: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // Update weekly summary based on report list
  void _updateWeeklySummary() {
    int selesai = reportList
        .where((r) => r.status == ReportStatus.selesai)
        .length;
    int menunggu = reportList
        .where((r) => r.status == ReportStatus.menunggu)
        .length;
    int ditolak = reportList
        .where((r) => r.status == ReportStatus.ditolak)
        .length;

    weeklySummary.value = {
      'total': reportList.length,
      'selesai': selesai,
      'menunggu': menunggu,
      'ditolak': ditolak,
      'Selesai': selesai,
      'Menunggu': menunggu,
      'Ditolak': ditolak,
    };
  }

  // Map backend status to frontend ReportStatus enum
  ReportStatus _mapStatus(String? status) {
    switch (status?.toLowerCase()) {
      case 'approved':
        return ReportStatus.selesai;
      case 'rejected':
        return ReportStatus.ditolak;
      case 'pending':
      default:
        return ReportStatus.menunggu;
    }
  }

  // Search functionality
  void searchReports(String query) {
    searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  // Filter by status
  void filterByStatus(ReportStatus? status) {
    selectedFilter.value = status;
  }

  // Update report status
  Future<bool> updateReportStatus(
    String reportId,
    ReportStatus newStatus,
  ) async {
    try {
      isLoading.value = true;

      // Map frontend status to backend status
      String backendStatus;
      switch (newStatus) {
        case ReportStatus.selesai:
          backendStatus = 'approved';
          break;
        case ReportStatus.ditolak:
          backendStatus = 'rejected';
          break;
        default:
          backendStatus = 'pending';
      }

      // TODO: Get admin user_id from SharedPreferences
      // For now using dummy admin id
      final response = await http.put(
        Uri.parse('${Environment.baseUrl}/cleaning-reports/$reportId/status'),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: json.encode({
          'status': backendStatus,
          'reviewed_by': 1, // TODO: Replace with actual admin ID
        }),
      );

      print('Update status response: ${response.statusCode}');

      if (response.statusCode == 200) {
        // Reload reports to get updated data
        await loadReports();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Gagal update status: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Add note to report
  Future<bool> addNoteToReport(int reportId, String note) async {
    try {
      isLoading.value = true;

      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));

      // Find and update report with note
      final reportIndex = reportList.indexWhere(
        (report) => report.id == reportId,
      );
      if (reportIndex != -1) {
        final updatedReport = reportList[reportIndex].copyWith(
          catatanAdmin: note.isNotEmpty ? note : null,
        );
        reportList[reportIndex] = updatedReport;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Gagal menambah catatan: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }
}
