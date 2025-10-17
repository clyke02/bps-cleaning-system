import 'environment.dart';

class ApiConfig {
  // Base URL untuk API Laravel - menggunakan Environment configuration
  static String get baseUrl => Environment.baseUrl;

  // Default headers untuk semua request
  static Map<String, String> get defaultHeaders => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };

  // Timeout untuk request
  static const Duration requestTimeout = Duration(seconds: 10);

  // Environment configurations
  static const bool isDevelopment = true;
  static const bool enableLogging = true;
}
