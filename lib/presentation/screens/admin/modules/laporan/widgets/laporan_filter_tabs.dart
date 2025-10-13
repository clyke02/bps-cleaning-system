import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';
import '../../../../../../data/models/report_model.dart';

class LaporanFilterTabs extends StatelessWidget {
  const LaporanFilterTabs({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaporanController>();
    
    return Container(
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey, width: 0.2),
        ),
      ),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        children: [
          _buildFilterChip('Semua', null, controller),
          const SizedBox(width: 8),
          _buildFilterChip('Menunggu', ReportStatus.menunggu, controller),
          const SizedBox(width: 8),
          _buildFilterChip('Selesai', ReportStatus.selesai, controller),
          const SizedBox(width: 8),
          _buildFilterChip('Ditolak', ReportStatus.ditolak, controller),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, ReportStatus? status, LaporanController controller) {
    return Obx(() {
      final isSelected = controller.selectedFilter.value == status;
      
      return FilterChip(
        label: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.grey[700],
            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: isSelected,
        onSelected: (_) => controller.filterByStatus(status),
        backgroundColor: Colors.grey[100],
        selectedColor: Colors.blue[600],
        checkmarkColor: Colors.white,
        side: BorderSide(
          color: isSelected ? Colors.blue[600]! : Colors.grey[300]!,
        ),
      );
    });
  }
}