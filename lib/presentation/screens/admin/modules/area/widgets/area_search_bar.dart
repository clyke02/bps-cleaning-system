import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/area_controller.dart';

class AreaSearchBar extends StatelessWidget {
  const AreaSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AreaController>();
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: TextField(
        onChanged: controller.searchAreas,
        decoration: InputDecoration(
          hintText: 'Cari area berdasarkan nama atau deskripsi...',
          hintStyle: TextStyle(color: Colors.grey[500]),
          prefixIcon: Icon(Icons.search, color: Colors.grey[500]),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          suffixIcon: Obx(() {
            if (controller.searchQuery.value.isNotEmpty) {
              return IconButton(
                icon: const Icon(Icons.clear),
                onPressed: controller.clearSearch,
              );
            }
            return const SizedBox();
          }),
        ),
      ),
    );
  }
}