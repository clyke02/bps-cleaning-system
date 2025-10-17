import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/petugas_controller.dart';
import '../widgets/petugas_list_widget.dart';
import '../widgets/tambah_petugas_dialog.dart';
import '../../../../../../shared/widgets/ringkasan_widget.dart';
import '../../../../../../core/constants/app_styles.dart';

class PetugasView extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const PetugasView({super.key, this.weeklySummary});

  @override
  Widget build(BuildContext context) {
    // Initialize controller
    Get.put(PetugasController());

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

                  // Manajemen Petugas Section (DESIGN ASLI)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 2)),
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
                                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    "Kelola data petugas kebersihan",
                                    style: TextStyle(fontWeight: FontWeight.w400, fontSize: 12, color: Colors.black54),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                                  // Refresh button
                                  IconButton(
                                    onPressed: () {
                                      Get.find<PetugasController>().loadUsers();
                                    },
                                    icon: const Icon(Icons.refresh),
                                    tooltip: 'Refresh Data',
                                    style: IconButton.styleFrom(
                                      backgroundColor: Colors.blue.withOpacity(0.1),
                                      foregroundColor: Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  FloatingActionButton(
                                    onPressed: () => _showTambahPetugas(context),
                                    backgroundColor: const Color(0xFF4CAF50),
                                    mini: true,
                                    child: const Icon(Icons.add, color: Colors.white),
                                  ),
                                ],
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
          ),
        );
      },
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
}
