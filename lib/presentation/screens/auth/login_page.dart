import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../data/repositories/user_repository.dart';
import '../../../data/models/user.dart';
import '../../../core/constants/app_styles.dart';
import '../../../services/fcm_service.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../config/environment.dart';
import 'dart:developer' as dev;
import '../../../shared/widgets/custom_snackbar.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final UserRepository _userRepository = UserRepository();
  bool _isLoading = false;

  Future<void> _login() async {
    // Validasi form
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Username dan password harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final result = await _userRepository.login(
        username: _usernameController.text.trim(),
        password: _passwordController.text,
      );

      final User user = result['user'];
      final String token = result['token'];

      // Save user data to SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('user_id', user.id);
      await prefs.setString('user_name', user.name);
      await prefs.setString('user_username', user.username);
      await prefs.setString('user_phone', user.phone);
      await prefs.setString('user_role', user.role);
      await prefs.setString('auth_token', token);

      // Save FCM token to backend
      try {
        final fcmToken = await FCMService.getToken();
        if (fcmToken != null) {
          await _updateFCMToken(user.id, fcmToken);
        }
      } catch (e) {
        dev.log('Error saving FCM token: $e');
        // Continue even if FCM token save fails
      }

      if (user.isAdmin) {
        Navigator.pushReplacementNamed(context, '/admin');
      } else {
        Navigator.pushReplacementNamed(context, '/user');
      }

      CustomSnackbar.showSuccess(title: 'Selamat Datang!', message: 'Halo, ${user.name}!');
    } catch (e) {
      String errorMessage = e
          .toString()
          .replaceFirst('Exception: ', '')
          .replaceFirst('Login failed: ', '')
          .replaceFirst('Exception:', '')
          .replaceFirst('Login failed:', '');

      // Clean up common error prefixes
      if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.substring(11);
      }
      if (errorMessage.startsWith('Login failed: ')) {
        errorMessage = errorMessage.substring(14);
      }

      // Default user-friendly messages
      if (errorMessage.contains('Invalid credentials') ||
          errorMessage.contains('Unauthorized') ||
          errorMessage.contains('401')) {
        errorMessage = 'Username atau Password salah, harap coba lagi';
      } else if (errorMessage.contains('Connection refused') || errorMessage.contains('tidak dapat terhubung')) {
        errorMessage = 'Tidak dapat terhubung ke server, periksa koneksi internet';
      } else if (errorMessage.isEmpty) {
        errorMessage = 'Terjadi kesalahan, silakan coba lagi';
      }

      CustomSnackbar.showError(title: 'Login Gagal', message: errorMessage);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _updateFCMToken(int userId, String token) async {
    try {
      final response = await http.put(
        Uri.parse('${Environment.baseUrl}/users/$userId/fcm-token'),
        headers: {'Content-Type': 'application/json', 'Accept': 'application/json'},
        body: json.encode({'fcm_token': token}),
      );

      if (response.statusCode == 200) {
        dev.log('FCM token updated successfully');
      } else {
        dev.log('Failed to update FCM token: ${response.body}');
      }
    } catch (e) {
      dev.log('Error updating FCM token: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Ikon gedung
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), shape: BoxShape.circle),
                    child: const Icon(Icons.business, size: 80, color: Colors.white),
                  ),
                  const SizedBox(height: 32),

                  // Judul
                  const Text(
                    'BPS Cleaning System',
                    style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Subjudul
                  const Text(
                    'Sistem Manajemen Kebersihan\nBPS Kota Sukabumi',
                    style: TextStyle(fontSize: 16, color: Colors.white70),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),

                  // Form container
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 10, offset: const Offset(0, 5)),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Username field
                        TextFormField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.text,
                        ),
                        const SizedBox(height: 16),

                        // Password field
                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Login button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _login,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 2,
                            ),
                            child: _isLoading
                                ? const CircularProgressIndicator(color: Colors.white)
                                : const Text(
                                    'Masuk',
                                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Forgot password link
                        TextButton(
                          onPressed: () {
                            CustomSnackbar.showInfo(title: 'Info', message: 'Fitur lupa password belum tersedia');
                          },
                          child: const Text('Lupa Password?', style: TextStyle(color: Color(0xFF2196F3))),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
