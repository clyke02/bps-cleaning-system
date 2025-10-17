import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_profile_controller.dart';
import '../../../../core/constants/app_styles.dart';

class PengaturanContent extends StatelessWidget {
  final Map<String, int>? weeklySummary;

  const PengaturanContent({Key? key, this.weeklySummary}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminProfileController());

    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: const LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Color(0xFFFF6B6B), Color(0xFFFFAA33)],
                      ),
                      border: Border.all(color: Colors.white, width: 4),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 6)),
                      ],
                    ),
                    child: const Center(child: Icon(Icons.admin_panel_settings, size: 45, color: Colors.white)),
                  ),
                  const SizedBox(height: 16),
                  Obx(
                    () => Text(
                      controller.userName.value,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ),
                  const SizedBox(height: 6),
                  Obx(
                    () => Text(
                      controller.userPhone.value,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(fontSize: 14, color: Colors.grey[600], fontWeight: FontWeight.w500),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF6B6B).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Text(
                      'Administrator',
                      style: TextStyle(color: Color(0xFFFF6B6B), fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Profile Menu
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 16, offset: const Offset(0, 4)),
                ],
              ),
              child: Column(
                children: [
                  _buildProfileMenuItem(
                    icon: Icons.person_outline,
                    title: 'Profile Admin',
                    subtitle: 'Lihat informasi profil Anda',
                    iconColor: const Color(0xFFFF6B6B),
                    onTap: () => controller.showProfileDetail(context),
                  ),
                  _buildDivider(),
                  _buildProfileMenuItem(
                    icon: Icons.lock_outline,
                    title: 'Ubah Password',
                    subtitle: 'Ganti kata sandi akun Anda',
                    iconColor: const Color(0xFF9C27B0),
                    onTap: () => controller.showChangePasswordDialog(context),
                  ),
                  _buildDivider(),
                  _buildProfileMenuItem(
                    icon: Icons.help_outline,
                    title: 'Panduan Aplikasi',
                    subtitle: 'Pelajari cara menggunakan aplikasi',
                    iconColor: const Color(0xFF4ADE80),
                    onTap: () => controller.showAppGuide(context),
                  ),
                  _buildDivider(),
                  _buildProfileMenuItem(
                    icon: Icons.logout,
                    title: 'Logout',
                    subtitle: 'Keluar dari aplikasi',
                    titleColor: Colors.red[600],
                    iconColor: Colors.red[600],
                    onTap: () => controller.showLogoutConfirmation(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(margin: const EdgeInsets.symmetric(horizontal: 16), height: 1, color: Colors.grey[200]);
  }

  Widget _buildProfileMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    Color? titleColor,
    Color? iconColor,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (iconColor ?? const Color(0xFFFF6B6B)).withOpacity(0.12),
                ),
                child: Icon(icon, color: iconColor ?? const Color(0xFFFF6B6B), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: titleColor ?? Colors.black87),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600], fontWeight: FontWeight.w400),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: Colors.grey[100], shape: BoxShape.circle),
                child: Icon(Icons.chevron_right, color: Colors.grey[500], size: 18),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
