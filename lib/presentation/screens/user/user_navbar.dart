import 'package:flutter/material.dart';

class UserNavbar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabSelected;

  const UserNavbar({super.key, required this.currentIndex, required this.onTabSelected});

  @override
  Widget build(BuildContext context) {
    final bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return Container(
      height: 65 + bottomPadding,
      padding: EdgeInsets.only(left: 12, right: 12, bottom: bottomPadding),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Expanded(child: _buildNavItem(0, Icons.home_outlined, 'Home')),
          Expanded(child: _buildNavItem(1, Icons.assignment_outlined, 'Laporan Darurat')),
          Expanded(child: _buildNavItem(2, Icons.history_outlined, 'Riwayat')),
          Expanded(child: _buildNavItem(3, Icons.person_outline, 'Profile')),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = currentIndex == index;
    return InkWell(
      onTap: () => onTabSelected(index),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: isSelected ? const Color(0xFF4CAF50) : Colors.grey, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: isSelected ? const Color(0xFF4CAF50) : Colors.grey,
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}
