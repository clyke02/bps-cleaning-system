import 'package:flutter/material.dart';
import '../../../../../../data/models/report_model.dart';

class ReportCard extends StatelessWidget {
  final Report report;
  final VoidCallback? onDetailPressed;
  final VoidCallback? onSetujuPressed;
  final VoidCallback? onTolakPressed;
  final VoidCallback? onBeriCatatanPressed;
  final VoidCallback? onDownloadPressed;

  const ReportCard({
    super.key,
    required this.report,
    this.onDetailPressed,
    this.onSetujuPressed,
    this.onTolakPressed,
    this.onBeriCatatanPressed,
    this.onDownloadPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 15, offset: const Offset(0, 6), spreadRadius: 2),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2)),
        ],
        border: Border.all(color: Colors.grey.shade100, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header dengan title, status dan tombol detail
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  report.title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getStatusColor(report.status),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      report.status.displayName,
                      style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(width: 8),
                  InkWell(
                    onTap: onDetailPressed,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline, size: 14, color: Colors.grey),
                          SizedBox(width: 4),
                          Text(
                            'Detail',
                            style: TextStyle(fontSize: 11, color: Colors.grey, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),

          // Info petugas dan tanggal
          Padding(
            padding: const EdgeInsets.only(top: 4, bottom: 12),
            child: Text(
              '${report.petugas} • ${report.formattedDate}',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),

          // Content area dengan gambar dan catatan
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Preview gambar
              Container(
                width: 120,
                height: 90,
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: report.imagePaths.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          report.imagePaths.first,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return _buildImagePlaceholder();
                          },
                        ),
                      )
                    : _buildImagePlaceholder(),
              ),

              const SizedBox(width: 12),

              // Info catatan
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (report.catatanPetugas != null && report.catatanPetugas!.isNotEmpty) ...[
                      const Text(
                        'Catatan Petugas:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        report.catatanPetugas!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                    ],

                    if (report.catatanAdmin != null && report.catatanAdmin!.isNotEmpty) ...[
                      const Text(
                        'Catatan Admin:',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.black87),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        report.catatanAdmin!,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade700, height: 1.3),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: onBeriCatatanPressed,
                  icon: const Icon(Icons.edit_note, size: 16),
                  label: const Text('Catatan', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.green,
                    side: const BorderSide(color: Colors.green),
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              if (report.status == ReportStatus.menunggu) ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onSetujuPressed,
                    icon: const Icon(Icons.check, size: 16),
                    label: const Text('Setujui', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onTolakPressed,
                    icon: const Icon(Icons.close, size: 16),
                    label: const Text('Tolak', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      backgroundColor: const Color(0xFFEF5350),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ] else ...[
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: onDownloadPressed,
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download Laporan', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size(0, 42),
                      backgroundColor: const Color(0xFF4CAF50),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(8)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.camera_alt_outlined, size: 24, color: Colors.grey.shade400),
          const SizedBox(height: 4),
          Text(
            'Foto bukti',
            style: TextStyle(fontSize: 10, color: Colors.grey.shade500, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(ReportStatus status) {
    switch (status) {
      case ReportStatus.selesai:
        return const Color(0xFF388E3C);
      case ReportStatus.menunggu:
        return const Color(0xFFF39C12);
      case ReportStatus.ditolak:
        return const Color(0xFFD32F2F);
    }
  }
}
