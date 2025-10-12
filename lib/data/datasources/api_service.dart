import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:async';
import 'package:http/http.dart' as http;

class ApiService {
  // Use 10.0.2.2 for Android Emulator to access localhost on host machine
  // Use 127.0.0.1 for iOS Simulator or physical devices on same network
  // Untuk device fisik di jaringan yang sama
  // static const String baseUrl = 'http://192.168.x.x:8000/api';

  // Untuk iOS Simulator
  // static const String baseUrl = 'http://127.0.0.1:8000/api';
  static const String baseUrl = 'http://10.0.2.2:8000/api';

  // Headers untuk request
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
    'Access-Control-Allow-Origin': '*',
    'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS',
    'Access-Control-Allow-Headers': 'Content-Type, Authorization',
  };

  // Helper method untuk logging
  static void _logRequest(
    String method,
    String url,
    Map<String, dynamic>? body,
  ) {
    developer.log('API Request: $method $url');
    if (body != null) {
      developer.log('Request Body: ${json.encode(body)}');
    }
  }

  static void _logResponse(http.Response response) {
    developer.log('API Response: ${response.statusCode}');
    developer.log('Response Body: ${response.body}');
  }

  static void _logError(String method, String url, dynamic error) {
    developer.log('API Error: $method $url - $error');
  }

  // Get all users (staff)
  static Future<List<Map<String, dynamic>>> getUsers() async {
    const String method = 'GET';
    const String url = '$baseUrl/users';

    try {
      _logRequest(method, url, null);

      final response = await http.get(Uri.parse(url), headers: headers);

      _logResponse(response);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true) {
          return List<Map<String, dynamic>>.from(data['data'] ?? []);
        } else {
          throw Exception(data['message'] ?? 'Gagal memuat data users');
        }
      } else {
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Failed to load users: ${response.statusCode}',
          );
        } catch (e) {
          throw Exception('Failed to load users: ${response.statusCode}');
        }
      }
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception(
        'Gagal terhubung ke server. Periksa koneksi internet Anda.',
      );
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
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/users'),
        headers: headers,
        body: json.encode({
          'name': name,
          'username': username,
          'phone': phone,
          'password': password,
          'role': role,
        }),
      );

      if (response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to create user');
      }
    } catch (e) {
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
    try {
      final body = {
        'name': name,
        'username': username,
        'phone': phone,
        'role': role,
      };

      if (password != null && password.isNotEmpty) {
        body['password'] = password;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to update user');
      }
    } catch (e) {
      throw Exception('Error updating user: $e');
    }
  }

  // Delete user
  static Future<void> deleteUser(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/users/$id'),
        headers: headers,
      );

      if (response.statusCode != 200) {
        final error = json.decode(response.body);
        throw Exception(error['message'] ?? 'Failed to delete user');
      }
    } catch (e) {
      throw Exception('Error deleting user: $e');
    }
  }

  // Login
  static Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    const String method = 'POST';
    const String url = '$baseUrl/login';
    final Map<String, dynamic> body = {
      'username': username,
      'password': password,
    };

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
          throw Exception(
            errorData['message'] ??
                'Username atau Password salah, harap coba lagi',
          );
        } catch (e) {
          throw Exception('Username atau Password salah, harap coba lagi');
        }
      } else {
        // Handle other errors
        try {
          final errorData = json.decode(response.body);
          throw Exception(
            errorData['message'] ??
                'Terjadi kesalahan server (${response.statusCode})',
          );
        } catch (e) {
          throw Exception('Terjadi kesalahan server (${response.statusCode})');
        }
      }
    } on http.ClientException catch (e) {
      _logError(method, url, e);
      throw Exception(
        'Tidak dapat terhubung ke server. Pastikan server Laravel berjalan di http://127.0.0.1:8000',
      );
    } on FormatException catch (e) {
      _logError(method, url, e);
      throw Exception('Server mengembalikan response yang tidak valid');
    } catch (e) {
      _logError(method, url, e);
      if (e is Exception) {
        rethrow;
      }
      throw Exception(
        'Gagal terhubung ke server. Periksa koneksi internet Anda.',
      );
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
}
