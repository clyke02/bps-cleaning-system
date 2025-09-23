import 'package:flutter/material.dart';

class AdminNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;
  const AdminNavbar({
    super.key,
    required this.currentIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(context, 0, "Laporan", Icons.assignment),
          _buildTab(context, 1, "Petugas", Icons.people),
          _buildTab(context, 2, "Area", Icons.map),
          _buildTab(context, 3, "Pengaturan", Icons.settings),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String title, IconData icon) {
    final bool isActive = index == currentIndex;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isActive ? Colors.grey.shade200 : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: isActive ? Colors.blue : Colors.grey, size: 22),
              const SizedBox(height: 4),
              Text(
                title,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: isActive ? Colors.black : Colors.grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
