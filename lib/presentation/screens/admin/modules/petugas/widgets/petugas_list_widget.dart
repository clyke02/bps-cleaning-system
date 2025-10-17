import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/petugas_controller.dart';
import '../../../../../../data/models/user.dart';
import 'edit_petugas_dialog.dart';

class PetugasListWidget extends StatelessWidget {
  const PetugasListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<PetugasController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      }

      if (controller.errorMessage.isNotEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
              const SizedBox(height: 16),
              Text(
                'Terjadi Kesalahan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[800]),
              ),
              const SizedBox(height: 8),
              Text(
                controller.errorMessage.value,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                onPressed: () => controller.loadUsers(),
                icon: const Icon(Icons.refresh),
                label: const Text('Coba Lagi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        );
      }

      if (controller.staffList.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
              const SizedBox(height: 16),
              Text(
                'Belum Ada Data Petugas',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.grey[600]),
              ),
              const SizedBox(height: 8),
              Text(
                'Tambahkan petugas pertama dengan menekan tombol tambah',
                style: TextStyle(fontSize: 14, color: Colors.grey[500]),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        );
      }

      return Column(children: controller.staffList.map((staff) => _buildStaffCard(context, staff)).toList());
    });
  }

  Widget _buildStaffCard(BuildContext context, User staff) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4), spreadRadius: 1),
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 6, offset: const Offset(0, 1)),
        ],
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: staff.isAdmin ? const Color(0xFF2196F3) : const Color(0xFF4CAF50),
              borderRadius: BorderRadius.circular(25),
            ),
            child: Center(
              child: Text(
                _getInitials(staff.name),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
          ),
          const SizedBox(width: 16),

          // Staff Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        staff.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: staff.isAdmin ? Colors.blue[100] : Colors.green[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        staff.displayRole,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: staff.isAdmin ? Colors.blue[700] : Colors.green[700],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  staff.phone.isNotEmpty ? staff.phone : 'No phone number',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 2),
                Text('@${staff.username}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
              ],
            ),
          ),

          // Edit Button (DESIGN ASLI)
          GestureDetector(
            onTap: () => _showEditPetugas(context, staff),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 4),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Delete Button (DESIGN ASLI)
          GestureDetector(
            onTap: () => _showDeleteConfirmation(context, staff),
            child: const Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  String _getInitials(String name) {
    final names = name.split(' ');
    if (names.length >= 2) {
      return (names[0][0] + names[1][0]).toUpperCase();
    } else if (names.isNotEmpty) {
      return names[0][0].toUpperCase();
    }
    return 'U';
  }

  void _showEditPetugas(BuildContext context, User staff) {
    showDialog(
      context: context,
      builder: (context) => EditPetugasDialog(user: staff),
    );
  }

  void _showDeleteConfirmation(BuildContext context, User staff) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withValues(alpha: 0.7), // Dark overlay
      builder: (context) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        elevation: 15,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.delete_outline, color: Colors.red),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Hapus Petugas', style: TextStyle(fontSize: 18))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Apakah Anda yakin ingin menghapus petugas berikut?', style: TextStyle(color: Colors.grey[600])),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(staff.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(staff.phone, style: TextStyle(color: Colors.grey[600])),
                  const SizedBox(height: 2),
                  Text('@${staff.username}', style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Text(
              'Tindakan ini tidak dapat dibatalkan.',
              style: TextStyle(color: Colors.red[600], fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Batal')),
          const SizedBox(width: 8),
          Obx(() {
            final controller = Get.find<PetugasController>();
            return ElevatedButton(
              onPressed: controller.isLoading.value ? null : () => _handleDelete(context, staff),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red, foregroundColor: Colors.white),
              child: controller.isLoading.value
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Hapus'),
            );
          }),
        ],
      ),
    );
  }

  void _handleDelete(BuildContext context, User user) async {
    final controller = Get.find<PetugasController>();
    await controller.deleteUser(user);

    Navigator.of(context).pop(); // Close dialog
    // Snackbar sudah ditampilkan oleh controller
  }
}
