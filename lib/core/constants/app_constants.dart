class AppConstants {
  // App Info
  static const String appName = 'BPS Cleaning System';
  static const String appVersion = '1.0.0';

  // API Constants
  static const String baseUrl = 'http://localhost:8000/api';
  static const int connectionTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String userKey = 'user_data';
  static const String themeKey = 'theme_mode';

  // Image Paths
  static const String logoPath = 'assets/images/logo.png';
  static const String homePath = 'assets/images/home.png';
  static const String profilePath = 'assets/images/profile.png';
  static const String settingPath = 'assets/images/setting.png';
  static const String laporanPath = 'assets/images/laporan.png';
  static const String notifikasiPath = 'assets/images/notifikasi.png';

  // Pagination
  static const int defaultPageSize = 10;
  static const int maxPageSize = 100;

  // Validation
  static const int minPasswordLength = 6;
  static const int maxNameLength = 50;

  // Report Status
  static const String statusSelesai = 'selesai';
  static const String statusMenunggu = 'menunggu';
  static const String statusDitolak = 'ditolak';
}
