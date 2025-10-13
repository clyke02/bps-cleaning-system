import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/area_controller.dart';

class AreaStatistics extends StatelessWidget {
  const AreaStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AreaController>();
    
    return Obx(() {
      final stats = controller.areaStatistics;
      
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Area',
              stats['total']?.toString() ?? '0',
              Colors.blue,
              Icons.location_on,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Aktif',
              stats['active']?.toString() ?? '0',
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Tidak Aktif',
              stats['inactive']?.toString() ?? '0',
              Colors.orange,
              Icons.pause_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Total Laporan',
              stats['totalReports']?.toString() ?? '0',
              Colors.purple,
              Icons.assignment,
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(String title, String value, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: color.withOpacity(0.8),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}