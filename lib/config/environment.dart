import 'dart:io';

class Environment {
  // ================================
  // 🎯 PILIH MODE (UBAH SESUAI KEBUTUHAN)
  // ================================

  // Mode yang tersedia:
  // - 'development' : Testing di local (emulator/device fisik)
  // - 'production'  : Deploy ke server production (BPS)
  static const String mode = 'development'; // ⚠️ UBAH KE 'production' SAAT DEPLOY!

  // ================================
  // 🌐 PRODUCTION SERVER (UNTUK DEPLOYMENT)
  // ================================

  // URL server production BPS (ganti dengan domain/IP server sebenarnya)
  // Contoh:
  // - 'http://192.168.1.100:8000/api'  (IP server lokal BPS)
  // - 'http://bps.go.id/cleaning-api'  (Domain production)
  // - 'https://api.bps-cleaning.com'   (Domain dengan SSL)
  static const String productionUrl = 'http://SERVER_IP_ANDA:8000/api'; // ⚠️ GANTI SEBELUM DEPLOY!

  // ================================
  // 🔧 DEVELOPMENT CONFIG (UNTUK TESTING)
  // ================================

  // IP Address PC Developer (hanya untuk development)
  // Cara cek: ipconfig (Windows) atau ifconfig (Mac/Linux)
  static const String localNetworkIP = '192.168.110.128'; // IP PC untuk development

  // Set TRUE = emulator, FALSE = device fisik
  static const bool useEmulator = false;

  // Debug mode detection
  static bool get isDebug {
    bool debugMode = false;
    assert(debugMode = true);
    return debugMode;
  }

  // ================================
  // 🚀 AUTO SELECTION
  // ================================

  static String get baseUrl {
    // Jika mode production, gunakan URL production
    if (mode == 'production') {
      return productionUrl;
    }

    // Jika development
    if (Platform.isAndroid) {
      return useEmulator ? emulatorUrl : deviceUrl;
    } else if (Platform.isIOS) {
      return 'http://127.0.0.1:8000/api';
    } else {
      return 'http://127.0.0.1:8000/api';
    }
  }

  // ================================
  // URL CONFIGURATIONS
  // ================================

  // URL untuk Android Emulator
  static const String emulatorUrl = 'http://10.0.2.2:8000/api';

  // URL untuk Device Fisik (development)
  static String get deviceUrl => 'http://$localNetworkIP:8000/api';

  // ================================
  // HELPER INFO
  // ================================

  static String get currentMode {
    if (mode == 'production') {
      return '🚀 PRODUCTION';
    }

    if (Platform.isAndroid) {
      return useEmulator ? '🔧 DEV - Android Emulator' : '🔧 DEV - Android Device Fisik';
    } else if (Platform.isIOS) {
      return '🔧 DEV - iOS Simulator';
    } else {
      return '🔧 DEV - Web/Desktop';
    }
  }

  static void printConfig() {
    print('═══════════════════════════════════════');
    print('📱 BPS Cleaning System - API Config');
    print('═══════════════════════════════════════');
    print('Environment: $currentMode');
    print('Base URL: $baseUrl');
    if (mode == 'development') {
      print('Dev IP: $localNetworkIP');
    }
    print('═══════════════════════════════════════');
  }
}
