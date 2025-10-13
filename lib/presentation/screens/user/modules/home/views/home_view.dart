import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'cleaning_task_dialog.dart';
import '../../../../admin/modules/area/controllers/area_controller.dart';

class HomeView extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

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
      child: RefreshIndicator(
        onRefresh: () => controller.refreshData(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Welcome Card
            Container(
              padding: const EdgeInsets.all(20),
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
                  Obx(
                    () => Text(
                      'Selamat datang, ${controller.userName.value}!',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Siap untuk menjalankan tugas kebersihan hari ini?',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Aktivitas Terbaru
            Obx(() {
              final isLoading = controller.isLoadingAreas.value;
              final isEmpty = controller.areaList.isEmpty;
              // Saat kosong/loading beri tinggi tetap agar isi bisa di-center sempurna
              final double? fixedHeight = (isLoading || isEmpty) ? 240 : null;

              return Container(
                height: fixedHeight, // null = auto (ketika ada data)
                padding: const EdgeInsets.all(20),
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
                      children: [
                        Icon(
                          Icons.cleaning_services_outlined,
                          size: 20,
                          color: Colors.blue[600],
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Aktivitas Terbaru',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black87,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    if (isLoading)
                      const Expanded(
                        child: Center(child: CircularProgressIndicator()),
                      )
                    else if (isEmpty)
                      Expanded(
                        child: Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.location_off_outlined,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 12),
                              const Text(
                                'Belum Ada Area',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Area yang perlu dibersihkan akan muncul di sini',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey[600],
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      Column(
                        children: controller.areaList
                            .map<Widget>((area) => _buildAreaCard(area))
                            .toList(),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildAreaCard(dynamic area) {
    final controller = Get.find<HomeController>();

    return GestureDetector(
      onTap: () {
        // Convert dynamic area to Area object
        final areaObj = Area(
          id: area['id'] ?? 0,
          name: area['name'] ?? 'Area Tidak Dikenal',
          lantai: area['lantai']?.toString() ?? 'Tidak ada info',
          nomorRuangan: area['nomorRuangan']?.toString() ?? 'Tidak ada info',
          kebersihan: List<String>.from(area['kebersihan'] ?? []),
          keterangan: area['keterangan'] ?? 'Tidak ada deskripsi',
          createdAt: area['createdAt'] != null
              ? DateTime.parse(area['createdAt'])
              : DateTime.now(),
        );

        // Show cleaning task dialog
        Get.dialog(CleaningTaskDialog(area: areaObj));
      },
      child: Obx(() {
        // Get report status for this area
        final report = controller.getAreaReportStatus(area['id'] ?? 0);
        final status = report?['status'] ?? 'not_reported';

        // Determine status color and text
        Color statusColor;
        Color statusBgColor;
        String statusText;

        switch (status) {
          case 'pending':
            statusColor = Colors.orange[700]!;
            statusBgColor = Colors.orange[100]!;
            statusText = 'Menunggu';
            break;
          case 'approved':
            statusColor = Colors.green[700]!;
            statusBgColor = Colors.green[100]!;
            statusText = 'Disetujui';
            break;
          case 'rejected':
            statusColor = Colors.red[700]!;
            statusBgColor = Colors.red[100]!;
            statusText = 'Ditolak';
            break;
          default:
            statusColor = Colors.blue[700]!;
            statusBgColor = Colors.blue[100]!;
            statusText = 'Belum Lapor';
        }

        return Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey[50],
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.blue[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  Icons.location_on_outlined,
                  color: Colors.blue[600],
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      area['name'] ?? 'Area Tidak Dikenal',
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      area['keterangan'] ?? 'Tidak ada deskripsi',
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: statusColor,
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
