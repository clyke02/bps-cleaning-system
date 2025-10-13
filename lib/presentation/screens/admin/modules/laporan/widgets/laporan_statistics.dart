import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/laporan_controller.dart';

class LaporanStatistics extends StatelessWidget {
  const LaporanStatistics({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<LaporanController>();
    
    return Obx(() {
      final summary = controller.weeklySummary;
      
      return Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total',
              summary['total']?.toString() ?? '0',
              Colors.blue,
              Icons.assignment,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Selesai',
              summary['selesai']?.toString() ?? '0',
              Colors.green,
              Icons.check_circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Menunggu',
              summary['menunggu']?.toString() ?? '0',
              Colors.orange,
              Icons.pending,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Ditolak',
              summary['ditolak']?.toString() ?? '0',
              Colors.red,
              Icons.cancel,
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