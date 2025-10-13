import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/petugas_controller.dart';
import '../widgets/petugas_list_widget.dart';
import '../widgets/tambah_petugas_dialog.dart';

class PetugasView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const PetugasView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    final controller = Get.put(PetugasController());

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
            // Ringkasan Statistik Petugas Card
            Obx(() {
              final stats = controller.weeklySummary;
              return _buildPetugasStatsCard(stats);
            }),

            // Manajemen Petugas Section (DESIGN ASLI)
            Padding(
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
                              "Manajemen Petugas",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                                color: Colors.black87,
                              ),
                            ),
                            SizedBox(height: 2),
                            Text(
                              "Kelola data petugas kebersihan",
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 12,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                        FloatingActionButton(
                          onPressed: () => _showTambahPetugas(context),
                          backgroundColor: const Color(0xFF4CAF50),
                          mini: true,
                          child: const Icon(Icons.add, color: Colors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // List Petugas menggunakan widget
                    const PetugasListWidget(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showTambahPetugas(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return TambahPetugasDialog(
          onUserAdded: () {
            // Refresh data setelah user ditambahkan
            Get.find<PetugasController>().loadStaff();
          },
        );
      },
    );
  }

  Widget _buildPetugasStatsCard(Map<String, int> stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.only(top: 16, bottom: 20),
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
              const Text(
                "Ringkasan Mingguan",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildStatsItem(
                    count: "${stats['total_petugas'] ?? 0}",
                    label: "Petugas",
                    color: const Color(0xFF388E3C),
                  ),
                  _buildStatsItem(
                    count: "${stats['total_admin'] ?? 0}",
                    label: "Admin",
                    color: const Color(0xFFF39C12),
                  ),
                  _buildStatsItem(
                    count: "${stats['total_all'] ?? 0}",
                    label: "Total",
                    color: const Color(0xFF2196F3),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsItem({
    required String count,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
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
