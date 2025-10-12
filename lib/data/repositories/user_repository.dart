import '../datasources/api_service.dart';
import '../models/user.dart';

class UserRepository {
  // Get all users
  Future<List<User>> getAllUsers() async {
    try {
      final data = await ApiService.getUsers();
      return data.map((json) => User.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Failed to get users: $e');
    }
  }

  // Create new user
  Future<User> createUser({
    required String name,
    required String username,
    required String phone,
    required String password,
    required String role,
  }) async {
    try {
      final data = await ApiService.createUser(
        name: name,
        username: username,
        phone: phone,
        password: password,
        role: role,
      );
      return User.fromJson(data['data']);
    } catch (e) {
      throw Exception('Failed to create user: $e');
    }
  }

  // Update user
  Future<User> updateUser({
    required int id,
    required String name,
    required String username,
    required String phone,
    String? password,
    required String role,
  }) async {
    try {
      final data = await ApiService.updateUser(
        id: id,
        name: name,
        username: username,
        phone: phone,
        password: password,
        role: role,
      );
      return User.fromJson(data['data']);
    } catch (e) {
      throw Exception('Failed to update user: $e');
    }
  }

  // Delete user
  Future<void> deleteUser(int id) async {
    try {
      await ApiService.deleteUser(id);
    } catch (e) {
      throw Exception('Failed to delete user: $e');
    }
  }

  // Login
  Future<Map<String, dynamic>> login({
    required String username,
    required String password,
  }) async {
    try {
      final data = await ApiService.login(
        username: username,
        password: password,
      );
      return {'user': User.fromJson(data['user']), 'token': data['token']};
    } catch (e) {
      // Re-throw the original error without adding "Login failed:" prefix
      rethrow;
    }
  }

  // Logout
  Future<void> logout(String token) async {
    try {
      await ApiService.logout(token);
    } catch (e) {
      throw Exception('Logout failed: $e');
    }
  }
}
