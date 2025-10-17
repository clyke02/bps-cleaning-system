import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';
import '../../../../../../shared/widgets/ringkasan_widget.dart';
import '../widgets/report_card.dart';
import '../widgets/report_detail_dialog.dart';
import '../widgets/add_catatan_dialog.dart';
import '../../../../../../data/models/report_model.dart';
import '../../../../../../core/constants/app_styles.dart';
import '../../../../../../services/pdf_service.dart';
import '../../../../../../shared/widgets/custom_dialog.dart';
import '../../../../../../shared/widgets/custom_snackbar.dart';

class LaporanView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const LaporanView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LaporanController());

    return Container(
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          // RINGKASAN MINGGU INI
          const RingkasanWidget(),

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
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
          ],
          border: Border.all(color: Colors.grey.shade100, width: 1),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Laporan Kebersihan",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 2),
            const Text(
              "Kelola dan verifikasi laporan dari petugas",
              style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black54),
            ),
            const SizedBox(height: 12),

            // SEARCH BAR AND EXPORT BUTTON
            Container(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: Row(
                children: [
                  Expanded(
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
                        contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Export PDF Button
                  Container(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFE53E3E), Color(0xFFD73227)]),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: controller.showWeeklyExportDialog,
                        borderRadius: BorderRadius.circular(8),
                        child: const Padding(
                          padding: EdgeInsets.all(12),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.picture_as_pdf, color: Colors.white, size: 20),
                              SizedBox(width: 8),
                              Text(
                                'Export PDF',
                                style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // LIST LAPORAN
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
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
                        Icon(Icons.assignment_outlined, size: 64, color: Colors.grey[400]),
                        const SizedBox(height: 16),
                        const Text(
                          'Belum Ada Laporan',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.black87),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Laporan dari petugas akan muncul di sini',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
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
                        onDetailPressed: () => _showReportDetail(context, report),
                        onSetujuPressed: () => _setujuiLaporan(controller, report),
                        onTolakPressed: () => _tolakLaporan(controller, report),
                        onBeriCatatanPressed: () => _beriCatatan(context, report),
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
    // Show dialog untuk rating dan catatan admin
    _showRatingDialog(Get.context!, controller, report, 'approved');
  }

  void _tolakLaporan(LaporanController controller, Report report) {
    // Show dialog untuk rating dan catatan admin
    _showRatingDialog(Get.context!, controller, report, 'rejected');
  }

  void _beriCatatan(BuildContext context, Report report) {
    // Show add catatan dialog
    AddCatatanDialog.show(context, report);
  }

  Future<void> _downloadLaporan(Report report) async {
    try {
      // Show loading indicator
      Get.dialog(const CustomLoadingDialog(message: 'Membuat PDF...'), barrierDismissible: false);

      // Determine report type from title
      final isEmergency = report.title.toLowerCase().contains('darurat');
      final reportType = isEmergency ? 'emergency' : 'cleaning';

      // Prepare report data for PDF
      final reportData = {
        'id': report.id,
        'report_type': reportType,
        'type': reportType,
        'area_name': report.title,
        'area': {'name': report.title},
        'user_name': report.petugas,
        'user': {'name': report.petugas},
        'created_at': report.tanggal,
        'submission_date': report.tanggal,
        'notes': report.catatanPetugas ?? '',
        'tasks': report.tasks
            .map((task) => {'name': task.description, 'task_name': task.description, 'is_completed': task.isCompleted})
            .toList(),
        'photos': report.imagePaths.map((path) => {'original_name': path.split('/').last, 'photo_path': path}).toList(),
      };

      // Generate PDF using PDFService
      final pdf = await PDFService.generateSingleReportPDF(reportData: reportData);

      // Close loading dialog
      Get.back();

      // Generate filename
      final reportTypeText = isEmergency ? 'Darurat' : 'Pembersihan';
      final dateStr = report.tanggal.split(' ')[0].replaceAll(':', '-');
      final areaName = report.title.replaceAll(' ', '_');
      final filename = 'Laporan_${reportTypeText}_${areaName}_$dateStr';

      // Share PDF
      await PDFService.sharePDF(pdf, filename);

      CustomSnackbar.showSuccess(title: 'Berhasil', message: 'PDF laporan berhasil dibuat');
    } catch (e) {
      // Close loading dialog if still open
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      CustomSnackbar.showError(title: 'Error', message: 'Gagal membuat PDF: $e');
      print('Error downloading laporan: $e');
    }
  }

  void _showRatingDialog(BuildContext context, LaporanController controller, Report report, String status) {
    final RxInt selectedRating = 1.obs;
    final TextEditingController notesController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => CustomDialog(
        title: status == 'approved' ? 'Setujui Laporan' : 'Tolak Laporan',
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Laporan: ${report.title}'),
            const SizedBox(height: 16),

            const Text('Rating (1-5):', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                children: List.generate(5, (index) {
                  return GestureDetector(
                    onTap: () => selectedRating.value = index + 1,
                    child: Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        index < selectedRating.value ? Icons.star : Icons.star_border,
                        color: Colors.amber,
                        size: 32,
                      ),
                    ),
                  );
                }),
              ),
            ),

            const SizedBox(height: 20),
            const Text('Catatan Admin:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                hintText: 'Masukkan catatan untuk petugas...',
                contentPadding: const EdgeInsets.all(12),
              ),
            ),
          ],
        ),
        actions: [
          OutlinedButton(
            onPressed: () => Navigator.pop(context),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Batal'),
          ),
          const SizedBox(width: 12),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              final reportStatus = status == 'approved' ? ReportStatus.selesai : ReportStatus.ditolak;
              controller.updateReportStatusWithNotes(
                report.id.toString(),
                reportStatus,
                notesController.text,
                selectedRating.value,
              );
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              backgroundColor: status == 'approved' ? Colors.green : Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              elevation: 0,
            ),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }
}
