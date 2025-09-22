import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../admin/admin_dashboard.dart';
import '../user/user_dashboard.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;

  Future<void> _login() async {
    // Validasi form
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      _showSnackBar('Email dan password harus diisi');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:8000/api/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      final responseData = json.decode(response.body);

      if (responseData['success'] == true) {
        final userRole = responseData['user']['role'];

        if (userRole == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      } else {
        _showSnackBar(responseData['message'] ?? 'Login gagal');
      }
    } catch (e) {
      _showSnackBar('Terjadi kesalahan: ${e.toString()}');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF4CAF50), // Hijau
              Color(0xFF2196F3), // Biru
            ],
          ),
        ),
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
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.business,
                      size: 80,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Judul
                  const Text(
                    'BPS Cleaning System',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
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
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        // Email field
                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email/Username',
                            prefixIcon: Icon(Icons.person),
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.emailAddress,
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
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: _isLoading ? null : _login,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.white,
                                    )
                                  : const Text(
                                      'Masuk',
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Forgot password link
                        TextButton(
                          onPressed: () {
                            _showSnackBar('Fitur lupa password belum tersedia');
                          },
                          child: const Text(
                            'Lupa Password?',
                            style: TextStyle(color: Color(0xFF2196F3)),
                          ),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
