import '../models/report_model.dart';
import '../datasources/sample_report_data.dart';
import 'report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  @override
  Future<List<Report>> getAllReports() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    return SampleReportData.reports;
  }

  @override
  Future<Report?> getReportById(int id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return SampleReportData.reports.firstWhere((report) => report.id == id);
    } catch (e) {
      return null;
    }
  }

  @override
  Future<List<Report>> getReportsByStatus(ReportStatus status) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SampleReportData.reports
        .where((report) => report.status == status)
        .toList();
  }

  @override
  Future<List<Report>> getReportsByPetugas(String petugasName) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return SampleReportData.reports
        .where((report) => report.petugas.toLowerCase().contains(petugasName.toLowerCase()))
        .toList();
  }

  @override
  Future<bool> updateReportStatus(int id, ReportStatus status) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final reportIndex = SampleReportData.reports.indexWhere((report) => report.id == id);
      if (reportIndex != -1) {
        SampleReportData.reports[reportIndex] = SampleReportData.reports[reportIndex].copyWith(status: status);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> addAdminNote(int id, String note) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final reportIndex = SampleReportData.reports.indexWhere((report) => report.id == id);
      if (reportIndex != -1) {
        SampleReportData.reports[reportIndex] = SampleReportData.reports[reportIndex].copyWith(catatanAdmin: note);
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> updateReport(Report report) async {
    await Future.delayed(const Duration(milliseconds: 600));
    try {
      final reportIndex = SampleReportData.reports.indexWhere((r) => r.id == report.id);
      if (reportIndex != -1) {
        SampleReportData.reports[reportIndex] = report;
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<bool> deleteReport(int id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      SampleReportData.reports.removeWhere((report) => report.id == id);
      return true;
    } catch (e) {
      return false;
    }
  }

  @override
  Future<Map<String, int>> getWeeklySummary() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return SampleReportData.weeklySummary;
  }
}