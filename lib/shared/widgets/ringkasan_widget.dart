import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../presentation/screens/admin/controllers/admin_shared_controller.dart';

class RingkasanWidget extends StatelessWidget {
  final Map<String, int>? weeklySummary;
  final String title;
  final Color? titleColor;
  final bool useSharedController;

  const RingkasanWidget({
    super.key,
    this.weeklySummary,
    this.title = "Ringkasan Mingguan",
    this.titleColor,
    this.useSharedController = true, // Default gunakan shared controller
  });

  @override
  Widget build(BuildContext context) {
    if (useSharedController && Get.isRegistered<AdminSharedController>()) {
      final controller = Get.find<AdminSharedController>();
      return Obx(() => _buildContent(controller.weeklySummary));
    }

    return _buildContent(weeklySummary ?? {});
  }

  Widget _buildContent(Map<String, dynamic> summary) {
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
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor ?? Colors.black87,
                  decoration: TextDecoration.none,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _SummaryItem(
                    count: "${summary['selesai'] ?? 0}",
                    label: "Selesai",
                    color: const Color(0xFF388E3C),
                  ),
                  _SummaryItem(
                    count: "${summary['menunggu'] ?? 0}",
                    label: "Menunggu",
                    color: const Color(0xFFF39C12),
                  ),
                  _SummaryItem(
                    count: "${summary['ditolak'] ?? 0}",
                    label: "Ditolak",
                    color: const Color(0xFFD32F2F),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryItem extends StatelessWidget {
  final String count;
  final String label;
  final Color color;

  const _SummaryItem({
    required this.count,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
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
