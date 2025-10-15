import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import '../../../../../../core/constants/app_styles.dart';
import 'cleaning_task_dialog.dart';
import '../../../../admin/modules/area/controllers/area_controller.dart';

class HomeView extends StatelessWidget {
  final Function(int)? onNavigateToTab;

  const HomeView({super.key, this.onNavigateToTab});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeController());

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: RefreshIndicator(
        onRefresh: () => controller.forceRefreshAssignments(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
                  MediaQuery.of(context).size.height -
                  MediaQuery.of(context).padding.top -
                  kToolbarHeight -
                  kBottomNavigationBarHeight -
                  32,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header dengan greeting
                _buildGreetingHeader(controller),
                const SizedBox(height: 20),

                // Summary Cards
                _buildSummaryCards(controller),
                const SizedBox(height: 20),

                // Aktivitas Terbaru
                _buildTodayAssignments(controller),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGreetingHeader(HomeController controller) {
    return RepaintBoundary(
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Row(
          children: [
            Container(
              width: 60,
              height: 60,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF2196F3), Color(0xFF4ADE80)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(30)),
              ),
              child: const Icon(Icons.waving_hand, color: Colors.white, size: 28),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Selamat Datang!',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text('Siap bekerja hari ini?', style: TextStyle(fontSize: 14, color: Colors.grey)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCards(HomeController controller) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _buildSummaryCard(
              title: 'Pending',
              icon: Icons.schedule,
              color: Colors.orange,
              value: controller.pendingAssignmentsCount,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildSummaryCard(
              title: 'Selesai',
              icon: Icons.check_circle,
              color: Colors.green,
              value: controller.completedAssignmentsCount,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildSummaryCard({required String title, required IconData icon, required Color color, required int value}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(10)),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(height: 12),
          Text(
            value.toString(),
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: color),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(fontSize: 12, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayAssignments(HomeController controller) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Color(0xFF2196F3), Color(0xFF4ADE80)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.assignment, color: Colors.white, size: 22),
              ),
              const SizedBox(width: 16),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Aktivitas Terbaru',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                    SizedBox(height: 2),
                    Text('Tugas pembersihan hari ini', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF2196F3).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextButton.icon(
                  onPressed: () => controller.forceRefreshAssignments(),
                  icon: const Icon(Icons.refresh, size: 16, color: Color(0xFF2196F3)),
                  label: const Text(
                    'Refresh',
                    style: TextStyle(fontSize: 12, color: Color(0xFF2196F3), fontWeight: FontWeight.w600),
                  ),
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Content Section
          Obx(() {
            if (controller.isLoadingAssignments.value) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                child: const Column(
                  children: [
                    CircularProgressIndicator(color: Color(0xFF2196F3), strokeWidth: 3),
                    SizedBox(height: 16),
                    Text('Memuat aktivitas...', style: TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              );
            }

            if (controller.dailyAssignments.isEmpty) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!, width: 1),
                ),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                      child: Icon(Icons.assignment_outlined, size: 32, color: Colors.grey[400]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Belum ada assignment hari ini',
                      style: TextStyle(fontSize: 16, color: Colors.grey[700], fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Assignment akan di-generate otomatis oleh admin',
                      style: TextStyle(fontSize: 13, color: Colors.grey[500]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: controller.dailyAssignments.map((assignment) => _buildAssignmentCard(assignment)).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAssignmentCard(dynamic assignment) {
    Color statusColor;
    Color statusBgColor;
    String statusText;

    switch (assignment.status) {
      case 'pending':
        statusColor = Colors.orange[700]!;
        statusBgColor = Colors.orange[100]!;
        statusText = 'Belum Lapor';
        break;
      case 'completed':
        statusColor = Colors.green[700]!;
        statusBgColor = Colors.green[100]!;
        statusText = 'Disetujui';
        break;
      case 'missed':
        statusColor = Colors.red[700]!;
        statusBgColor = Colors.red[100]!;
        statusText = 'Ditolak';
        break;
      default:
        statusColor = Colors.blue[700]!;
        statusBgColor = Colors.blue[100]!;
        statusText = 'Belum Lapor';
    }

    return GestureDetector(
      onTap: () {
        // Only open dialog if status is pending
        if (assignment.status == 'pending' && assignment.area != null) {
          // Convert Map to Area object
          final areaData = assignment.area!;
          final area = Area(
            id: areaData['id'] ?? assignment.areaId,
            name: areaData['name'] ?? assignment.areaName,
            lantai: areaData['floor']?.toString() ?? '0',
            nomorRuangan: areaData['room_number']?.toString() ?? '0',
            kebersihan: List<String>.from(areaData['kebersihan'] ?? []),
            keterangan: areaData['description'] ?? areaData['keterangan'] ?? '',
            isActive: areaData['isActive'] ?? true,
            reportCount: areaData['reportCount'] ?? 0,
            createdAt: areaData['created_at'] != null ? DateTime.parse(areaData['created_at']) : DateTime.now(),
          );

          Get.dialog(CleaningTaskDialog(area: area), barrierDismissible: false);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[200]!, width: 1),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [statusColor.withOpacity(0.2), statusColor.withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.location_on, color: statusColor, size: 22),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    assignment.areaName,
                    style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    assignment.areaDescription.isNotEmpty ? assignment.areaDescription : 'Tidak ada deskripsi',
                    style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.3),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusBgColor,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: statusColor.withOpacity(0.3), width: 1),
              ),
              child: Text(
                statusText,
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: statusColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
