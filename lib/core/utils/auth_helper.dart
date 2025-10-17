import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../config/environment.dart';
import '../../shared/widgets/custom_snackbar.dart';

class AuthHelper {
  /// Validate apakah user masih exist di database
  static Future<bool> validateUser(int userId, String token) async {
    try {
      final response = await http
          .get(
            Uri.parse('${Environment.baseUrl}/users/$userId'),
            headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
          )
          .timeout(const Duration(seconds: 5));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['success'] == true;
      } else if (response.statusCode == 404) {
        // User sudah dihapus
        return false;
      } else if (response.statusCode == 401) {
        // Token invalid atau expired
        return false;
      } else {
        // Error lain, assume masih valid (untuk offline support)
        return true;
      }
    } catch (e) {
      // Network error - assume masih valid (offline scenario)
      if (Environment.isDebug) {
        print('Error validating user: $e');
      }
      return true;
    }
  }

  /// Logout user dan clear semua data
  static Future<void> logout(BuildContext context, {String? reason}) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');

      // Call logout API jika ada token
      if (token != null) {
        try {
          await http
              .post(
                Uri.parse('${Environment.baseUrl}/logout'),
                headers: {'Accept': 'application/json', 'Authorization': 'Bearer $token'},
              )
              .timeout(const Duration(seconds: 3));
        } catch (e) {
          // Ignore error saat logout API call
          if (Environment.isDebug) {
            print('Error calling logout API: $e');
          }
        }
      }

      // Clear all user data
      await clearUserData();

      // Navigate to login
      if (context.mounted) {
        Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);

        // Show message if reason provided
        if (reason != null) {
          CustomSnackbar.showWarning(title: 'Perhatian', message: reason);
        }
      }
    } catch (e) {
      if (Environment.isDebug) {
        print('Error during logout: $e');
      }
    }
  }

  /// Clear semua data user dari SharedPreferences
  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_id');
    await prefs.remove('user_name');
    await prefs.remove('user_username');
    await prefs.remove('user_phone');
    await prefs.remove('user_role');
    await prefs.remove('last_assignment_refresh');

    if (Environment.isDebug) {
      print('User data cleared from SharedPreferences');
    }
  }

  /// Get current user data dari SharedPreferences
  static Future<Map<String, dynamic>?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
    final userName = prefs.getString('user_name');
    final userRole = prefs.getString('user_role');

    if (token != null && userId != null) {
      return {'token': token, 'user_id': userId, 'user_name': userName, 'user_role': userRole};
    }

    return null;
  }

  /// Check apakah user sedang login
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userId = prefs.getInt('user_id');
    return token != null && userId != null;
  }
}
