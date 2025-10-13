class ApiConfig {
  // Base URL untuk API Laravel
  static const String baseUrl = 'http://127.0.0.1:8000/api';

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
