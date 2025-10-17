import '../models/report_model.dart';

abstract class ReportRepository {
  Future<List<Report>> getAllReports();
  Future<Report?> getReportById(int id);
  Future<List<Report>> getReportsByStatus(ReportStatus status);
  Future<List<Report>> getReportsByPetugas(String petugasName);
  Future<bool> updateReportStatus(int id, ReportStatus status);
  Future<bool> addAdminNote(int id, String note);
  Future<bool> updateReport(Report report);
  Future<bool> deleteReport(int id);
  Future<Map<String, int>> getWeeklySummary();
}
