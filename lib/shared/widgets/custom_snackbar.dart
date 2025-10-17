import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Custom Snackbar modern, desain mirip referensi:
/// - Kartu putih rounded besar
/// - Icon dalam kotak rounded dengan warna status
/// - Title bold + subtitle abu-abu
/// - Tombol close dalam pill halus
/// - Glow warna status di bawah kartu
class CustomSnackbar {
  CustomSnackbar._();

  /// API dipertahankan agar tidak perlu ubah pemanggilan di project
  static void showSuccess({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.check_rounded,
      color: const Color(0xFF22C55E), // green 500
      duration: duration,
    );
  }

  static void showError({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.close_rounded,
      color: const Color(0xFFEF4444), // red 500
      duration: duration,
    );
  }

  static void showWarning({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 4),
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.warning_amber_rounded,
      color: const Color(0xFFF59E0B), // amber 500
      duration: duration,
    );
  }

  static void showInfo({
    required String title,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(
      title: title,
      message: message,
      icon: Icons.info_rounded,
      color: const Color(0xFF3B82F6), // blue 500
      duration: duration,
    );
  }

  /// Tetap sediakan method generik 'show' seperti sebelumnya
  static void show({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    Duration duration = const Duration(seconds: 3),
  }) {
    _show(title: title, message: message, icon: icon, color: color, duration: duration);
  }

  /// -------- Renderer inti (dipakai semua varian) ---------------------------
  static void _show({
    required String title,
    required String message,
    required IconData icon,
    required Color color,
    required Duration duration,
  }) {
    final Color glow = color.withOpacity(0.30);
    final Color pill = color.withOpacity(0.12);
    final Color iconBg = color.withOpacity(0.18);

    Get.showSnackbar(
      GetSnackBar(
        snackPosition: SnackPosition.TOP,
        snackStyle: SnackStyle.FLOATING,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
        // Lebar maksimal ala card modern (tetap responsif di hp)
        maxWidth: Get.width > 560 ? 560 : Get.width - 24,
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        borderRadius: 20,
        duration: duration,
        backgroundColor: Colors.white,
        animationDuration: const Duration(milliseconds: 280),
        forwardAnimationCurve: Curves.easeOutCubic,
        reverseAnimationCurve: Curves.easeInCubic,
        boxShadows: [
          // shadow dasar
          BoxShadow(color: Colors.black.withOpacity(0.06), blurRadius: 20, offset: const Offset(0, 8)),
          // glow berwarna lembut di bawah card
          BoxShadow(color: glow, blurRadius: 40, spreadRadius: 2, offset: const Offset(0, 22)),
        ],
        // Pakai messageText untuk kontrol penuh isi snackbar
        messageText: _ToastContent(
          title: title,
          message: message,
          color: color,
          pillColor: pill,
          iconBg: iconBg,
          icon: icon,
        ),
      ),
    );
  }
}

/// Widget isi toast agar rapi & mudah di-maintain
class _ToastContent extends StatelessWidget {
  final String title;
  final String message;
  final Color color;
  final Color pillColor;
  final Color iconBg;
  final IconData icon;

  const _ToastContent({
    required this.title,
    required this.message,
    required this.color,
    required this.pillColor,
    required this.iconBg,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Icon kotak rounded
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: iconBg, borderRadius: BorderRadius.circular(12)),
            alignment: Alignment.center,
            child: Icon(icon, color: color, size: 26),
          ),
          const SizedBox(width: 12),
          // Teks
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A), // slate-900
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF475569), // slate-600
                    height: 1.25,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Tombol close bergaya pill
          InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () => Get.back(), // tutup snackbar
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(color: pillColor, borderRadius: BorderRadius.circular(12)),
              alignment: Alignment.center,
              child: Icon(Icons.close_rounded, color: color, size: 22),
            ),
          ),
        ],
      ),
    );
  }
}
