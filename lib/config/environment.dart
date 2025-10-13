import 'dart:io';

class Environment {
  // ================================
  // KONFIGURASI IP ADDRESS
  // ================================

  // IP Address PC Anda di jaringan lokal
  // Cara cek: Buka CMD/Terminal, ketik: ipconfig (Windows) atau ifconfig (Mac/Linux)
  // Cari IPv4 Address, contoh: 192.168.1.100
  static const String localNetworkIP =
      '192.168.1.100'; // ⚠️ GANTI DENGAN IP PC ANDA!

  // ================================
  // AUTO DETECTION
  // ================================

  static String get baseUrl {
    if (Platform.isAndroid) {
      // Android: Gunakan emulator atau device fisik?
      return useEmulator ? emulatorUrl : deviceUrl;
    } else if (Platform.isIOS) {
      // iOS Simulator
      return 'http://127.0.0.1:8000/api';
    } else {
      // Web atau platform lain
      return 'http://127.0.0.1:8000/api';
    }
  }

  // ================================
  // SWITCH MODE
  // ================================

  // Set ke TRUE jika pakai emulator, FALSE jika pakai device fisik
  static const bool useEmulator = true; // ⚠️ UBAH INI SESUAI KEBUTUHAN!

  // ================================
  // URL CONFIGURATIONS
  // ================================

  // URL untuk Android Emulator
  static const String emulatorUrl = 'http://10.0.2.2:8000/api';

  // URL untuk Device Fisik (menggunakan IP lokal)
  static String get deviceUrl => 'http://$localNetworkIP:8000/api';

  // ================================
  // HELPER INFO
  // ================================

  static String get currentMode {
    if (Platform.isAndroid) {
      return useEmulator ? 'Android Emulator' : 'Android Device Fisik';
    } else if (Platform.isIOS) {
      return 'iOS Simulator';
    } else {
      return 'Web/Desktop';
    }
  }

  static void printConfig() {
    print('═══════════════════════════════════════');
    print('📱 Environment Configuration');
    print('═══════════════════════════════════════');
    print('Mode: $currentMode');
    print('Base URL: $baseUrl');
    print('Local IP: $localNetworkIP');
    print('═══════════════════════════════════════');
  }
}
