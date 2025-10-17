import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../controllers/area_controller.dart';
import '../../../../../../shared/widgets/ringkasan_widget.dart';
import '../widgets/area_add_dialog.dart';
import '../../../../../../core/constants/app_styles.dart';
import '../../../../../../config/environment.dart';
import '../../../../../../shared/widgets/custom_snackbar.dart';

class AreaView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const AreaView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AreaController());

    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ringkasan Mingguan Card
                  const RingkasanWidget(),

                  // Manajemen Area Section
                  _buildAreaManagement(context, controller),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAreaManagement(BuildContext context, AreaController controller) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Manajemen Area",
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                      ),
                      SizedBox(height: 2),
                      Text(
                        "Kelola data area kebersihan",
                        style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black54),
                      ),
                    ],
                  ),
                ),
                Row(
                  children: [
                    // Tombol Generate Tugas
                    ElevatedButton.icon(
                      onPressed: () => _generateDailyAssignments(context),
                      icon: const Icon(Icons.auto_awesome, size: 18),
                      label: const Text('Generate', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2196F3),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        elevation: 2,
                      ),
                    ),
                    const SizedBox(width: 8),
                    // Tombol Tambah Area
                    FloatingActionButton(
                      onPressed: () => _showAddAreaDialog(context, controller),
                      backgroundColor: const Color(0xFF4CAF50),
                      mini: true,
                      child: const Icon(Icons.add, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List Area
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()),
                );
              }

              final areas = controller.filteredAreas;

              if (areas.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text('Tidak ada area ditemukan', style: TextStyle(color: Colors.grey)),
                  ),
                );
              }

              return Column(children: areas.map((area) => _buildAreaCard(context, area, controller)).toList());
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(BuildContext context, Area area, AreaController controller) {
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
          // Area Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(area.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(area.description, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),

          // Edit Button
          GestureDetector(
            onTap: () => _showEditAreaDialog(context, area, controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(color: Colors.orange, borderRadius: BorderRadius.circular(12)),
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Delete Button
          GestureDetector(
            onTap: () => _showDeleteDialog(context, area, controller),
            child: const Icon(Icons.delete_outline, color: Colors.grey),
          ),
        ],
      ),
    );
  }

  void _showAddAreaDialog(BuildContext context, AreaController controller) {
    showDialog(
      context: context,
      builder: (context) => TambahAreaDialog(controller: controller),
    );
  }

  void _showEditAreaDialog(BuildContext context, Area area, AreaController controller) {
    showDialog(
      context: context,
      builder: (context) => TambahAreaDialog(controller: controller, area: area),
    );
  }

  void _showDeleteDialog(BuildContext context, Area area, AreaController controller) {
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

  void _generateDailyAssignments(BuildContext context) async {
    try {
      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF2196F3))),
        ),
      );

      final response = await http
          .post(
            Uri.parse('${Environment.baseUrl}/assignments/generate-daily'),
            headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      // Close loading
      if (context.mounted) Navigator.pop(context);

      final data = json.decode(response.body);

      if (response.statusCode == 200 && data['success'] == true) {
        final created = data['data']['created'] ?? 0;
        final skipped = data['data']['skipped'] ?? 0;

        if (context.mounted) {
          showDialog(
            context: context,
            builder: (BuildContext dialogContext) {
              return Dialog(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF4CAF50).withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.check_circle, color: Color(0xFF4CAF50), size: 48),
                      ),
                      const SizedBox(height: 16),
                      const Text('Berhasil!', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                        'Tugas harian berhasil di-generate',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(8)),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Tugas dibuat:'),
                                Text(
                                  '$created',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4CAF50)),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Sudah ada:'),
                                Text(
                                  '$skipped',
                                  style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4CAF50),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text(
                            'Tutup',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
      } else {
        if (context.mounted) {
          CustomSnackbar.showError(title: 'Error', message: data['message'] ?? 'Gagal generate tugas');
        }
      }
    } catch (e) {
      // Close loading if still open
      if (context.mounted) Navigator.pop(context);

      if (context.mounted) {
        CustomSnackbar.showError(title: 'Error', message: 'Error: ${e.toString()}');
      }
    }
  }
}
