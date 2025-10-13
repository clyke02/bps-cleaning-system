import 'package:get/get.dart';
import '../../../../../../data/models/report_model.dart';
import '../../../../../../data/datasources/sample_report_data.dart';

class LaporanController extends GetxController {
  // Reactive Variables
  final RxList<Report> reportList = <Report>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final Rx<ReportStatus?> selectedFilter = Rx<ReportStatus?>(null);

  // Filtered reports based on search and status
  List<Report> get filteredReports {
    var filtered = reportList.toList();
    
    // Filter by status
    if (selectedFilter.value != null) {
      filtered = filtered.where((report) => report.status == selectedFilter.value).toList();
    }
    
    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((report) {
        return report.title.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               report.petugas.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               report.status.toString().toLowerCase().contains(searchQuery.value.toLowerCase());
      }).toList();
    }
    
    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadReports();
  }

  // Load all reports
  Future<void> loadReports() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load sample data (replace with actual API call)
      final reports = SampleReportData.reports;
      reportList.assignAll(reports);
      
    } catch (e) {
      errorMessage.value = 'Gagal memuat laporan: ${e.toString()}';
    } finally {
      isLoading.value = false;
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
  Future<bool> updateReportStatus(int reportId, ReportStatus newStatus) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // Find and update report
      final reportIndex = reportList.indexWhere((report) => report.id == reportId);
      if (reportIndex != -1) {
        final updatedReport = reportList[reportIndex].copyWith(status: newStatus);
        reportList[reportIndex] = updatedReport;
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
      final reportIndex = reportList.indexWhere((report) => report.id == reportId);
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

  // Get weekly summary
  Map<String, int> get weeklySummary {
    final total = reportList.length;
    final selesai = reportList.where((r) => r.status == ReportStatus.selesai).length;
    final menunggu = reportList.where((r) => r.status == ReportStatus.menunggu).length;
    final ditolak = reportList.where((r) => r.status == ReportStatus.ditolak).length;
    
    return {
      'total': total,
      'selesai': selesai,
      'menunggu': menunggu,
      'ditolak': ditolak,
    };
  }
}