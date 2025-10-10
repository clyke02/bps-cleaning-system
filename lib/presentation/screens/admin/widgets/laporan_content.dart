import 'package:flutter/material.dart';
import '../../../../data/models/report_model.dart';
import '../../../../data/datasources/sample_report_data.dart';
import 'report_card.dart';
import 'report_detail_dialog.dart';
import 'add_catatan_dialog.dart';

class LaporanContentWidget extends StatelessWidget {
  final Map<String, int> weeklySummary;

  const LaporanContentWidget({super.key, required this.weeklySummary});

  @override
  Widget build(BuildContext context) {
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
          _buildWeeklySummary(),

          // SEARCH DAN LIST LAPORAN
          _buildReportsList(context),
        ],
      ),
    );
  }

  Widget _buildWeeklySummary() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
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
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      "Ringkasan Mingguan",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD32F2F),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "${weeklySummary['total']} Tugas",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SummaryItem(
                    count: "${weeklySummary['selesai']}",
                    label: "Selesai",
                    color: const Color(0xFF388E3C),
                  ),
                  _SummaryItem(
                    count: "${weeklySummary['menunggu']}",
                    label: "Menunggu",
                    color: const Color(0xFFF39C12),
                  ),
                  _SummaryItem(
                    count: "${weeklySummary['ditolak']}",
                    label: "Ditolak",
                    color: const Color(0xFFD32F2F),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReportsList(BuildContext context) {
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
            ...SampleReportData.reports
                .map(
                  (report) => ReportCard(
                    report: report,
                    onDetailPressed: () => _showReportDetail(context, report),
                    onSetujuPressed: () => _setujuiLaporan(report),
                    onTolakPressed: () => _tolakLaporan(report),
                    onBeriCatatanPressed: () => _beriCatatan(context, report),
                    onDownloadPressed: () => _downloadLaporan(report),
                  ),
                )
                .toList(),
          ],
        ),
      ),
    );
  }

  void _showReportDetail(BuildContext context, Report report) {
    // Show detail dialog
    ReportDetailDialog.show(context, report);
  }

  void _setujuiLaporan(Report report) {
    // TODO: Implement setujui laporan
    print('Setujui laporan: ${report.title}');
  }

  void _tolakLaporan(Report report) {
    // TODO: Implement tolak laporan
    print('Tolak laporan: ${report.title}');
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

class _SummaryItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.25), width: 1),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            count,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              height: 1.0,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              height: 1.0,
            ),
          ),
        ],
      ),
    );
  }
}
