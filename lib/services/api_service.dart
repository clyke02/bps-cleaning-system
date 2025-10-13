import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:io';

class ApiService {
  // Use different baseUrl for Android emulator vs real device/web
  static String get baseUrl {
    if (Platform.isAndroid) {
      // For Android emulator, use 10.0.2.2 to access host machine
      return 'http://10.0.2.2:8000/api';
    } else {
      // For iOS simulator, web, or real devices use localhost
      return 'http://127.0.0.1:8000/api';
    }
  }

  // Areas endpoints
  static Future<Map<String, dynamic>> getAreas({String? search}) async {
    try {
      String url = '$baseUrl/areas';
      if (search != null && search.isNotEmpty) {
        url += '?search=$search';
      }

      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load areas: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> createArea({
    required String name,
    required String lantai,
    required String nomorRuangan,
    required List<String> kebersihan,
    required String keterangan,
  }) async {
    try {
      final requestBody = {
        'name': name,
        'lantai': lantai,
        'nomorRuangan': nomorRuangan,
        'kebersihan': kebersihan,
        'keterangan': keterangan,
      };

      print('DEBUG ApiService: Sending request to $baseUrl/areas');
      print('DEBUG ApiService: Request body: ${json.encode(requestBody)}');

      final response = await http.post(
        Uri.parse('$baseUrl/areas'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode(requestBody),
      );

      print('DEBUG ApiService: Response status: ${response.statusCode}');
      print('DEBUG ApiService: Response body: ${response.body}');

      final responseData = json.decode(response.body);

      if (response.statusCode == 201) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to create area');
      }
    } catch (e) {
      print('DEBUG ApiService: Exception: $e');
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> updateArea({
    required int id,
    required String name,
    required String lantai,
    required String nomorRuangan,
    required List<String> kebersihan,
    required String keterangan,
  }) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/areas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: json.encode({
          'name': name,
          'lantai': lantai,
          'nomorRuangan': nomorRuangan,
          'kebersihan': kebersihan,
          'keterangan': keterangan,
        }),
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to update area');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> deleteArea(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/areas/$id'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      final responseData = json.decode(response.body);

      if (response.statusCode == 200) {
        return responseData;
      } else {
        throw Exception(responseData['message'] ?? 'Failed to delete area');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  static Future<Map<String, dynamic>> getAreaStatistics() async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/areas-statistics'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to load statistics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}
