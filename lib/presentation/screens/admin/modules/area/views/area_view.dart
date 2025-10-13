import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/area_controller.dart';
import '../../../../../../shared/widgets/ringkasan_widget.dart';
import '../widgets/area_add_dialog.dart';

class AreaView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const AreaView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AreaController());

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
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ringkasan Mingguan Card
            RingkasanWidget(
              weeklySummary:
                  weeklySummary ??
                  {'total': 0, 'selesai': 0, 'menunggu': 0, 'ditolak': 0},
            ),

            // Manajemen Area Section
            _buildAreaManagement(context, controller),
          ],
        ),
      ),
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
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Manajemen Area",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Kelola data area kebersihan",
                      style: TextStyle(
                        fontWeight: FontWeight.w400,
                        fontSize: 12,
                        color: Colors.black54,
                      ),
                    ),
                  ],
                ),
                FloatingActionButton(
                  onPressed: () => _showAddAreaDialog(context, controller),
                  backgroundColor: const Color(0xFF4CAF50),
                  mini: true,
                  child: const Icon(Icons.add, color: Colors.white),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // List Area
            Obx(() {
              if (controller.isLoading.value) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final areas = controller.filteredAreas;

              if (areas.isEmpty) {
                return const Center(
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      'Tidak ada area ditemukan',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                );
              }

              return Column(
                children: areas
                    .map((area) => _buildAreaCard(context, area, controller))
                    .toList(),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(
    BuildContext context,
    Area area,
    AreaController controller,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
            spreadRadius: 1,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
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
                Text(
                  area.name,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  area.description,
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Edit Button
          GestureDetector(
            onTap: () => _showEditAreaDialog(context, area, controller),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'Edit',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
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

  void _showEditAreaDialog(
    BuildContext context,
    Area area,
    AreaController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) =>
          TambahAreaDialog(controller: controller, area: area),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    Area area,
    AreaController controller,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus Area'),
        content: Text('Apakah Anda yakin ingin menghapus area "${area.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              final success = await controller.deleteArea(area.id);
              if (context.mounted) {
                Navigator.pop(context);
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Area berhasil dihapus')),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
