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
      height: 60,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.zero,
        boxShadow: [],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildTab(context, 0, "Laporan", Icons.assignment_outlined),
          _buildTab(context, 1, "Petugas", Icons.people_outline),
          _buildTab(context, 2, "Area", Icons.location_on_outlined),
          _buildTab(context, 3, "Pengaturan", Icons.settings_outlined),
        ],
      ),
    );
  }

  Widget _buildTab(BuildContext context, int index, String title, IconData icon) {
    final bool isActive = index == currentIndex;
    return Expanded(
      child: InkWell(
        onTap: () => onTabSelected(index),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isActive ? Colors.black : Colors.grey,
              size: 26,
            ),
            const SizedBox(height: 2),
            Text(
              title,
              style: TextStyle(
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                color: isActive ? Colors.black : Colors.grey,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
