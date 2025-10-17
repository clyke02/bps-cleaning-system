// Core Dart libraries
import 'dart:async';
import 'dart:convert';
import 'dart:developer' as dev;

// External packages
import 'package:http/http.dart' as http;

// Internal imports
import '../../config/api_config.dart';
import '../../config/environment.dart';

// Cache entry structure - moved to top level
class CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  bool isExpired(Duration timeout) => DateTime.now().difference(timestamp) > timeout;
}

class ApiService {
  // Singleton pattern untuk reuse HTTP client
  static final http.Client _client = http.Client();

  // Cache untuk responses
  static final Map<String, CacheEntry> _cache = {};
  static const Duration _cacheTimeout = Duration(minutes: 5);

  // Base URL dari konfigurasi
  static String get baseUrl => ApiConfig.baseUrl;

  // Headers untuk request
  static Map<String, String> get headers => ApiConfig.defaultHeaders;

  // Helper method untuk logging (only in debug mode)
  static void _logRequest(String method, String url, Map<String, dynamic>? body) {
    if (Environment.isDebug) {
      dev.log('API Request: $method $url');
      if (body != null) {
        dev.log('Request Body: ${json.encode(body)}');
      }
    }
  }

  static void _logResponse(http.Response response) {
    if (Environment.isDebug) {
      dev.log('API Response: ${response.statusCode}');
      dev.log('Response Body: ${response.body}');
    }
  }

  static void _logError(String method, String url, dynamic error) {
    if (Environment.isDebug) {
      dev.log('API Error: $method $url - $error');
    }
  }

  // Cache management
  static T? _getFromCache<T>(String key) {
    final entry = _cache[key];
    if (entry != null && !entry.isExpired(_cacheTimeout)) {
      return entry.data as T?;
    }
    _cache.remove(key);
    return null;
  }

  static void _saveToCache<T>(String key, T data) {
    _cache[key] = CacheEntry(data, DateTime.now());
  }

  static void _removeFromCache(String key) {
    _cache.remove(key);
  }

  static void clearAssignmentCache() {
    // Clear all assignment-related cache entries
    _cache.removeWhere((key, value) => key.contains('assignments') || key.contains('assignment'));
    if (Environment.isDebug) {
      dev.log('Assignment cache cleared');
    }
  }

  static void clearCache() {
    _cache.clear();
  }

  // Get all users (staff) with caching
  static Future<List<Map<String, dynamic>>> getUsers({bool useCache = true}) async {
    const String method = 'GET';
    final String url = '$baseUrl/users';
    const String cacheKey = 'users_list';

    try {
      // Check cache first
      if (useCache) {
        final cachedData = _getFromCache<List<Map<String, dynamic>>>(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
      }

      _logRequest(method, url, null);

      final response = await _client.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          final result = List<Map<String, dynamic>>.from(data['data'] ?? []);
          if (useCache) {
            _saveToCache(cacheKey, result);
          }
          return result;
        } else {
          throw Exception(data['message'] ?? 'Gagal memuat data users');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Failed to load users: ${response.statusCode}');
        } catch (e) {
          throw Exception('Failed to load users: ${response.statusCode}');
        }
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  // Create new user
  static Future<Map<String, dynamic>> createUser({
    required String name,
    required String username,
    required String phone,
    required String password,
    required String role,
  }) async {
    const String method = 'POST';
    final String url = '$baseUrl/users';

    try {
      _logRequest(method, url, {'name': name, 'username': username, 'phone': phone, 'password': '***', 'role': role});

      final response = await _client
          .post(
            Uri.parse(url),
            headers: headers,
            body: json.encode({'name': name, 'username': username, 'phone': phone, 'password': password, 'role': role}),
          )
          .timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 201) {
        final result = json.decode(response.body);

        // Clear users cache after successful creation
        _removeFromCache('users_list');

        if (Environment.isDebug) {
          dev.log('User created successfully, cache cleared');
        }

        return result;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create user');
      }
    } catch (e) {
      _logError(method, url, e);
      throw Exception('Error creating user: $e');
    }
  }

  // Update user
  static Future<Map<String, dynamic>> updateUser({
    required int id,
    required String name,
    required String username,
    required String phone,
    String? password,
    required String role,
  }) async {
    const String method = 'PUT';
    final String url = '$baseUrl/users/$id';

    try {
      final body = {'name': name, 'username': username, 'phone': phone, 'role': role};

      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      _logRequest(method, url, body);

      final response = await _client
          .put(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        final result = json.decode(response.body);

        // Clear users cache after successful update
        _removeFromCache('users_list');

        if (Environment.isDebug) {
          dev.log('User updated successfully, cache cleared');
        }

        return result;
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      _logError(method, url, e);
      throw Exception('Error updating user: $e');
    }
  }

  // Delete user
  static Future<void> deleteUser(int id) async {
    const String method = 'DELETE';
    final String url = '$baseUrl/users/$id';

    try {
      _logRequest(method, url, null);

      final response = await _client.delete(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        // Clear users cache after successful deletion
        _removeFromCache('users_list');

        if (Environment.isDebug) {
          dev.log('User deleted successfully, cache cleared');
        }
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      _logError(method, url, e);
      throw Exception('Error deleting user: $e');
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({required String username, required String password}) async {
    const String method = 'POST';
    final String url = '$baseUrl/login';
    final Map<String, dynamic> body = {'username': username, 'password': password};

    try {
      _logRequest(method, url, body);

      final response = await http
          .post(Uri.parse(url), headers: headers, body: json.encode(body))
          .timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return data;
        } else {
          throw Exception(data['message'] ?? 'Login gagal');
        }
      } else if (response.statusCode == 401) {
        // Handle unauthorized
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Username atau Password salah, harap coba lagi');
        } catch (e) {
          throw Exception('Username atau Password salah, harap coba lagi');
        }
      } else {
        // Handle other errors
        try {
          final errorData = json.decode(response.body);
          throw Exception(errorData['message'] ?? 'Terjadi kesalahan server (${response.statusCode})');
        } catch (e) {
          throw Exception('Terjadi kesalahan server (${response.statusCode})');
        }
      }
    } on TimeoutException catch (e) {
      _logError(method, url, e);
      throw Exception(
        'Koneksi timeout. Pastikan:\n• HP dan PC terhubung ke WiFi yang sama\n• Server Laravel berjalan di ${Environment.baseUrl.replaceAll('/api', '')}\n• Firewall tidak memblokir koneksi',
      );
    } on http.ClientException catch (e) {
      _logError(method, url, e);
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan:\n• HP dan PC terhubung ke WiFi yang sama\n• Server Laravel berjalan di ${Environment.baseUrl.replaceAll('/api', '')}',
      );
    } on FormatException catch (e) {
      _logError(method, url, e);
      throw Exception('Server mengembalikan response yang tidak valid');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Gagal terhubung ke server. Periksa koneksi internet Anda.');
    }
  }

  // Logout
  static Future<void> logout(String token) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/logout'),
        headers: {...headers, 'Authorization': 'Bearer $token'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to logout');
      }
    } catch (e) {
      throw Exception('Error during logout: $e');
    }
  }

  // ==========================================
  // AREAS API ENDPOINTS
  // ==========================================

  // Get all areas with optional search
  static Future<Map<String, dynamic>> getAreas({String? search, bool useCache = true}) async {
    const String method = 'GET';
    String url = '$baseUrl/areas';
    if (search != null && search.isNotEmpty) {
      url += '?search=$search';
    }
    final String cacheKey = 'areas_${search ?? 'all'}';

    try {
      // Check cache first
      if (useCache) {
        final cachedData = _getFromCache<Map<String, dynamic>>(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
      }

      _logRequest(method, url, null);

      final response = await _client.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (useCache) {
          _saveToCache(cacheKey, result);
        }
        return result;
      } else {
        throw Exception('Failed to load areas: ${response.statusCode}');
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Create new area
  static Future<Map<String, dynamic>> createArea({
    required String name,
    required String lantai,
    required String nomorRuangan,
    required List<String> kebersihan,
    required String keterangan,
  }) async {
    const String method = 'POST';
    final String url = '$baseUrl/areas';

    try {
      final requestBody = {
        'name': name,
        'lantai': lantai,
        'nomorRuangan': nomorRuangan,
        'kebersihan': kebersihan,
        'keterangan': keterangan,
      };

      _logRequest(method, url, requestBody);

      final response = await _client
          .post(Uri.parse(url), headers: headers, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 10));

      _logResponse(response);

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        // Clear areas cache
        _cache.removeWhere((key, value) => key.startsWith('areas_'));

        if (Environment.isDebug) {
          dev.log('Area created successfully, cache cleared');
        }

        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create area');
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Update area
  static Future<Map<String, dynamic>> updateArea({
    required int id,
    required String name,
    required String lantai,
    required String nomorRuangan,
    required List<String> kebersihan,
    required String keterangan,
  }) async {
    const String method = 'PUT';
    final String url = '$baseUrl/areas/$id';

    try {
      final requestBody = {
        'name': name,
        'lantai': lantai,
        'nomorRuangan': nomorRuangan,
        'kebersihan': kebersihan,
        'keterangan': keterangan,
      };

      _logRequest(method, url, requestBody);

      final response = await _client
          .put(Uri.parse(url), headers: headers, body: json.encode(requestBody))
          .timeout(const Duration(seconds: 10));

      _logResponse(response);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Clear areas cache
        _cache.removeWhere((key, value) => key.startsWith('areas_'));

        if (Environment.isDebug) {
          dev.log('Area updated successfully, cache cleared');
        }

        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update area');
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Delete area
  static Future<Map<String, dynamic>> deleteArea(int id) async {
    const String method = 'DELETE';
    final String url = '$baseUrl/areas/$id';

    try {
      _logRequest(method, url, null);

      final response = await _client.delete(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));

      _logResponse(response);

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        // Clear areas cache
        _cache.removeWhere((key, value) => key.startsWith('areas_'));

        if (Environment.isDebug) {
          dev.log('Area deleted successfully, cache cleared');
        }

        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete area');
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  // Get area statistics
  static Future<Map<String, dynamic>> getAreaStatistics({bool useCache = true}) async {
    const String method = 'GET';
    final String url = '$baseUrl/areas-statistics';
    const String cacheKey = 'areas_statistics';

    try {
      // Check cache first
      if (useCache) {
        final cachedData = _getFromCache<Map<String, dynamic>>(cacheKey);
        if (cachedData != null) {
          return cachedData;
        }
      }

      _logRequest(method, url, null);

      final response = await _client.get(Uri.parse(url), headers: headers).timeout(const Duration(seconds: 10));

      _logResponse(response);

      if (response.statusCode == 200) {
        final result = json.decode(response.body) as Map<String, dynamic>;
        if (useCache) {
          _saveToCache(cacheKey, result);
        }
        return result;
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } on TimeoutException {
      _logError(method, url, 'Request timeout');
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
