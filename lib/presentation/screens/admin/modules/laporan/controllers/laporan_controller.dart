import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../../../../../data/models/report_model.dart';
import '../../../../../../config/environment.dart';
import '../../../../../../services/pdf_service.dart';

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

  // Update report status with notes and rating
  Future<bool> updateReportStatusWithNotes(
    String reportId,
    ReportStatus newStatus,
    String adminNotes,
    int rating,
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
          'admin_notes': adminNotes.isNotEmpty ? adminNotes : null,
          'rating': rating > 0 ? rating : null,
        }),
      );

      print('Update status with notes response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        // Reload reports to get updated data
        await loadReports();
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Gagal update status: ${e.toString()}';
      print('Error updating status: $e');
      return false;
    } finally {
      isLoading.value = false;
    }
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

  // Export PDF Mingguan
  Future<void> showWeeklyExportDialog() async {
    final now = DateTime.now();
    final selectedYear = now.year.obs;
    final selectedMonth = now.month.obs;
    final selectedWeek = 1.obs;

    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Export Laporan Mingguan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Pilih periode mingguan untuk export PDF',
                style: TextStyle(color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // Year Selector
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Tahun:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => DropdownButtonFormField<int>(
                        value: selectedYear.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: List.generate(5, (index) => now.year - 2 + index)
                            .map(
                              (year) => DropdownMenuItem(
                                value: year,
                                child: Text(year.toString()),
                              ),
                            )
                            .toList(),
                        onChanged: (value) => selectedYear.value = value!,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Month Selector
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Bulan:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => DropdownButtonFormField<int>(
                        value: selectedMonth.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(value: 1, child: Text('Januari')),
                          DropdownMenuItem(value: 2, child: Text('Februari')),
                          DropdownMenuItem(value: 3, child: Text('Maret')),
                          DropdownMenuItem(value: 4, child: Text('April')),
                          DropdownMenuItem(value: 5, child: Text('Mei')),
                          DropdownMenuItem(value: 6, child: Text('Juni')),
                          DropdownMenuItem(value: 7, child: Text('Juli')),
                          DropdownMenuItem(value: 8, child: Text('Agustus')),
                          DropdownMenuItem(value: 9, child: Text('September')),
                          DropdownMenuItem(value: 10, child: Text('Oktober')),
                          DropdownMenuItem(value: 11, child: Text('November')),
                          DropdownMenuItem(value: 12, child: Text('Desember')),
                        ],
                        onChanged: (value) => selectedMonth.value = value!,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Week Selector
              Row(
                children: [
                  const Expanded(
                    flex: 2,
                    child: Text(
                      'Minggu:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Obx(
                      () => DropdownButtonFormField<int>(
                        value: selectedWeek.value,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 8,
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 1,
                            child: Text('Minggu ke-1'),
                          ),
                          DropdownMenuItem(
                            value: 2,
                            child: Text('Minggu ke-2'),
                          ),
                          DropdownMenuItem(
                            value: 3,
                            child: Text('Minggu ke-3'),
                          ),
                          DropdownMenuItem(
                            value: 4,
                            child: Text('Minggu ke-4'),
                          ),
                        ],
                        onChanged: (value) => selectedWeek.value = value!,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(Get.context!),
                      child: const Text('Batal'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.pop(Get.context!);
                        await exportWeeklyPDF(
                          year: selectedYear.value,
                          month: selectedMonth.value,
                          week: selectedWeek.value,
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Export PDF'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  Future<void> exportWeeklyPDF({
    required int year,
    required int month,
    required int week,
  }) async {
    try {
      isLoading.value = true;

      // Fetch weekly report data from API
      final response = await http.get(
        Uri.parse(
          '${Environment.baseUrl}/weekly-report-data?year=$year&month=$month&week=$week',
        ),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);

        if (responseData['success'] == true) {
          final weeklyData = responseData['data'];

          // Generate PDF
          final pdf = await PDFService.generateWeeklyReportPDF(
            weeklyData: weeklyData,
          );

          // Generate filename
          final monthNames = [
            'Januari',
            'Februari',
            'Maret',
            'April',
            'Mei',
            'Juni',
            'Juli',
            'Agustus',
            'September',
            'Oktober',
            'November',
            'Desember',
          ];
          final filename =
              'Laporan_Mingguan_${monthNames[month - 1]}_Minggu${week}_$year';

          // Show export options
          _showExportOptions(pdf, filename);
        } else {
          Get.snackbar(
            'Error',
            responseData['message'] ?? 'Gagal mengambil data mingguan',
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Gagal mengambil data dari server',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Terjadi kesalahan: ${e.toString()}',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void _showExportOptions(dynamic pdf, String filename) {
    Get.dialog(
      Dialog(
        child: Container(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.picture_as_pdf, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              const Text(
                'Export PDF',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 24),

              _buildExportOption(
                icon: Icons.share,
                label: 'Share PDF',
                color: Colors.blue,
                onTap: () async {
                  Navigator.pop(Get.context!);
                  await PDFService.sharePDF(pdf, filename);
                },
              ),
              const SizedBox(height: 12),
              _buildExportOption(
                icon: Icons.save,
                label: 'Save to Device',
                color: Colors.orange,
                onTap: () async {
                  Navigator.pop(Get.context!);
                  await PDFService.savePDF(pdf, filename);
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () => Navigator.pop(Get.context!),
                child: const Text('Batal'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: color.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: color),
            const SizedBox(width: 16),
            Text(
              label,
              style: TextStyle(fontWeight: FontWeight.w600, color: color),
            ),
            const Spacer(),
            Icon(Icons.arrow_forward_ios, size: 16, color: color),
          ],
        ),
      ),
    );
  }
}
