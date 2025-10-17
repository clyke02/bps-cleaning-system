import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/area_controller.dart';
import 'area_add_dialog.dart';
import '../../../../../../shared/widgets/custom_snackbar.dart';

class AreaCard extends StatelessWidget {
  final Area area;

  const AreaCard({super.key, required this.area});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AreaController>();

    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              area.name,
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                            ),
                          ),
                          _buildStatusChip(),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(area.description, style: TextStyle(fontSize: 14, color: Colors.grey[600], height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Statistics Row
            Row(
              children: [
                Icon(Icons.assignment, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text('${area.reportCount} Laporan', style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                const Spacer(),
                Icon(Icons.calendar_today, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(_formatDate(area.createdAt), style: TextStyle(fontSize: 12, color: Colors.grey[600])),
              ],
            ),

            const SizedBox(height: 16),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: () => _showEditDialog(context, controller),
                    icon: const Icon(Icons.edit, size: 16),
                    label: const Text('Edit'),
                    style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 8)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => _showToggleDialog(context, controller),
                    icon: Icon(area.isActive ? Icons.pause : Icons.play_arrow, size: 16),
                    label: Text(area.isActive ? 'Nonaktifkan' : 'Aktifkan'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: area.isActive ? Colors.orange[600] : Colors.green[600],
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  onPressed: () => _showDeleteDialog(context, controller),
                  icon: const Icon(Icons.delete, color: Colors.red),
                  tooltip: 'Hapus Area',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: area.isActive ? Colors.green.withOpacity(0.1) : Colors.grey.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: area.isActive ? Colors.green.withOpacity(0.3) : Colors.grey.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            area.isActive ? Icons.check_circle : Icons.pause_circle,
            size: 14,
            color: area.isActive ? Colors.green : Colors.grey,
          ),
          const SizedBox(width: 4),
          Text(
            area.isActive ? 'Aktif' : 'Nonaktif',
            style: TextStyle(
              fontSize: 12,
              color: area.isActive ? Colors.green : Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  void _showEditDialog(BuildContext context, AreaController controller) {
    showDialog(
      context: context,
      builder: (context) => TambahAreaDialog(controller: controller, area: area),
    );
  }

  void _showToggleDialog(BuildContext context, AreaController controller) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${area.isActive ? 'Nonaktifkan' : 'Aktifkan'} Area'),
        content: Text(
          'Apakah Anda yakin ingin ${area.isActive ? 'menonaktifkan' : 'mengaktifkan'} area "${area.name}"?',
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Batal')),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.toggleAreaStatus(area.id);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  CustomSnackbar.showSuccess(
                    title: 'Berhasil',
                    message: 'Area berhasil ${area.isActive ? 'dinonaktifkan' : 'diaktifkan'}',
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: area.isActive ? Colors.orange : Colors.green,
              foregroundColor: Colors.white,
            ),
            child: Text(area.isActive ? 'Nonaktifkan' : 'Aktifkan'),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, AreaController controller) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 15, offset: const Offset(0, 5)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: Colors.red.withValues(alpha: 0.1), shape: BoxShape.circle),
                child: const Icon(Icons.delete_outline, color: Colors.red, size: 32),
              ),
              const SizedBox(height: 20),
              // Title
              const Text(
                'Hapus Area',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
              ),
              const SizedBox(height: 12),
              // Content
              Text(
                'Apakah Anda yakin ingin menghapus area "${area.name}"?',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 14, color: Colors.black54),
              ),
              const SizedBox(height: 24),
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: BorderSide(color: Colors.grey.shade300),
                      ),
                      child: const Text(
                        'Batal',
                        style: TextStyle(color: Colors.black87, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final success = await controller.deleteArea(area.id);
                        if (context.mounted) {
                          Navigator.pop(context);
                          if (success) {
                            CustomSnackbar.showSuccess(title: 'Berhasil', message: 'Area berhasil dihapus');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Hapus', style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
