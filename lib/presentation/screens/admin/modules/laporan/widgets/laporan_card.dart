import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';
import '../../../../../../data/models/report_model.dart';

class LaporanCard extends StatelessWidget {
  final Report report;

  const LaporanCard({super.key, required this.report});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaporanController>();

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showReportDetail(context),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          report.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.person,
                              size: 16,
                              color: Colors.grey[600],
                            ),
                            const SizedBox(width: 4),
                            Text(
                              report.petugas,
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  _buildStatusChip(),
                ],
              ),

              const SizedBox(height: 12),

              // Details Row
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    report.tanggal,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                  const Spacer(),
                  Icon(Icons.location_on, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    'Area ${report.areaId}',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _showReportDetail(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        side: BorderSide(color: Colors.blue[600]!),
                      ),
                      child: Text(
                        'Detail',
                        style: TextStyle(color: Colors.blue[600]),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  if (report.status == ReportStatus.menunggu) ...[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showStatusDialog(context, controller),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 8),
                        ),
                        child: const Text('Update Status'),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color color;
    String text;
    IconData icon;

    switch (report.status) {
      case ReportStatus.menunggu:
        color = Colors.orange;
        text = 'Menunggu';
        icon = Icons.pending;
        break;
      case ReportStatus.selesai:
        color = Colors.green;
        text = 'Selesai';
        icon = Icons.check_circle;
        break;
      case ReportStatus.ditolak:
        color = Colors.red;
        text = 'Ditolak';
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              fontSize: 12,
              color: color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _showReportDetail(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(report.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Petugas', report.petugas),
            _buildDetailRow('Tanggal', report.tanggal),
            _buildDetailRow('Area', 'Area ${report.areaId}'),
            _buildDetailRow('Status', _getStatusText()),
            if (report.catatanPetugas?.isNotEmpty == true)
              _buildDetailRow('Catatan Petugas', report.catatanPetugas!),
            if (report.catatanAdmin?.isNotEmpty == true)
              _buildDetailRow('Catatan Admin', report.catatanAdmin!),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  void _showStatusDialog(BuildContext context, LaporanController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Status Laporan'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Selesai'),
              leading: const Icon(Icons.check_circle, color: Colors.green),
              onTap: () {
                Navigator.pop(context);
                controller.updateReportStatus(
                  report.id.toString(),
                  ReportStatus.selesai,
                );
              },
            ),
            ListTile(
              title: const Text('Ditolak'),
              leading: const Icon(Icons.cancel, color: Colors.red),
              onTap: () {
                Navigator.pop(context);
                controller.updateReportStatus(
                  report.id.toString(),
                  ReportStatus.ditolak,
                );
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          Expanded(
            child: Text(value, style: const TextStyle(color: Colors.black87)),
          ),
        ],
      ),
    );
  }

  String _getStatusText() {
    switch (report.status) {
      case ReportStatus.menunggu:
        return 'Menunggu';
      case ReportStatus.selesai:
        return 'Selesai';
      case ReportStatus.ditolak:
        return 'Ditolak';
    }
  }
}
