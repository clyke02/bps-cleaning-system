import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';
import '../../../../../../shared/widgets/ringkasan_widget.dart';
import '../widgets/report_card.dart';
import '../widgets/report_detail_dialog.dart';
import '../widgets/add_catatan_dialog.dart';
import '../../../../../../data/models/report_model.dart';

class LaporanView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const LaporanView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaporanController());

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF2196F3), // biru
            Color(0xFF4ADE80), // hijau muda
          ],
        ),
      ),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // RINGKASAN MINGGU INI
          Obx(() => RingkasanWidget(weeklySummary: controller.weeklySummary)),

          // SEARCH DAN LIST LAPORAN
          _buildReportsList(context, controller),
        ],
      ),
    );
  }

  Widget _buildReportsList(BuildContext context, LaporanController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 15,
              offset: const Offset(0, 6),
              spreadRadius: 2,
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Laporan Kebersihan",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 2),
            const Text(
              "Kelola dan verifikasi laporan dari petugas",
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 12,
                color: Colors.black54,
              ),
            ),
            const SizedBox(height: 12),

            // SEARCH BAR
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: TextField(
                onChanged: controller.searchReports,
                decoration: InputDecoration(
                  hintText: "Cari Ruangan",
                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 14),
                  filled: true,
                  fillColor: Colors.grey.shade50,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: Color(0xFF2196F3)),
                  ),
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 16,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 8),

            // LIST LAPORAN
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final reports = controller.filteredReports;

              if (reports.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(40),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.assignment_outlined,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum Ada Laporan',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Laporan dari petugas akan muncul di sini',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return Column(
                children: reports
                    .map(
                      (report) => ReportCard(
                        report: report,
                        onDetailPressed: () =>
                            _showReportDetail(context, report),
                        onSetujuPressed: () =>
                            _setujuiLaporan(controller, report),
                        onTolakPressed: () => _tolakLaporan(controller, report),
                        onBeriCatatanPressed: () =>
                            _beriCatatan(context, report),
                        onDownloadPressed: () => _downloadLaporan(report),
                      ),
                    )
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  void _showReportDetail(BuildContext context, Report report) {
    // Show detail dialog
    ReportDetailDialog.show(context, report);
  }

  void _setujuiLaporan(LaporanController controller, Report report) {
    controller.updateReportStatus(report.id, ReportStatus.selesai);
  }

  void _tolakLaporan(LaporanController controller, Report report) {
    controller.updateReportStatus(report.id, ReportStatus.ditolak);
  }

  void _beriCatatan(BuildContext context, Report report) {
    // Show add catatan dialog
    AddCatatanDialog.show(context, report);
  }

  void _downloadLaporan(Report report) {
    // TODO: Implement download functionality
    print('Download laporan: ${report.title}');
  }
}
