# Authentication Pages

Folder ini berisi semua halaman terkait **Authentication** (login, register, forgot password, dll).

## 📁 Struktur Folder

```
auth/
├── login_page.dart              # Halaman login (sudah ada)
├── register_page.dart           # Halaman registrasi (opsional)
├── forgot_password_page.dart    # Lupa password
├── reset_password_page.dart     # Reset password
└── splash_screen.dart           # Splash screen dengan auto-login
```

## 🎯 Fitur Auth

- ✅ **Login**: Login dengan email/password
- 🔄 **Register**: Registrasi user baru (opsional)
- 🔄 **Forgot Password**: Reset password via email
- 🔄 **Auto Login**: Remember login session
- 🔄 **Splash Screen**: Check authentication status

## 🚀 Development Guidelines

### 1. Authentication Flow

```
Splash Screen → Check Token → Login/Dashboard
     ↓              ↓              ↓
Auto Login    Invalid Token   Valid Token
     ↓              ↓              ↓
Dashboard      Login Page     Dashboard
```

### 2. Token Management

```dart
// Gunakan ApiService untuk token management
import '../../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Save token after login
Future<void> _saveToken(String token) async {
  ApiService.setAuthToken(token);
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString('auth_token', token);
}

// Load token on app start
Future<void> _loadToken() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('auth_token');
  if (token != null) {
    ApiService.setAuthToken(token);
  }
}

// Clear token on logout
Future<void> _clearToken() async {
  ApiService.clearAuthToken();
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove('auth_token');
}
```

### 3. Form Validation

```dart
// Contoh validasi email dan password
String? _validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'Email tidak boleh kosong';
  }
  if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)) {
    return 'Format email tidak valid';
  }
  return null;
}

String? _validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'Password tidak boleh kosong';
  }
  if (value.length < 6) {
    return 'Password minimal 6 karakter';
  }
  return null;
}
```

## 🎨 UI Guidelines

- **Background**: Gradient hijau ke biru (sesuai design)
- **Form Container**: White background dengan shadow
- **Button**: Gradient button (gunakan `BPSGradientButton`)
- **Input**: Gunakan `CustomTextField` atau `EmailTextField`/`PasswordTextField`

## 📝 TODO List untuk Worker

- [ ] Splash Screen dengan auto-login
- [ ] Forgot Password flow
- [ ] Reset Password page
- [ ] Remember Me checkbox
- [ ] Social login (Google/Facebook) - opsional
- [ ] Registration page - opsional
- [ ] Email verification - opsional

## 🔗 Dependencies yang Dibutuhkan

```yaml
dependencies:
  # Local storage untuk token
  shared_preferences: ^2.2.2

  # Secure storage (alternatif)
  flutter_secure_storage: ^9.2.2

  # Loading indicators
  flutter_spinkit: ^5.2.1
```

## 🔐 Security Best Practices

1. **Token Storage**: Gunakan `flutter_secure_storage` untuk token sensitif
2. **Input Validation**: Selalu validasi input di client dan server
3. **HTTPS Only**: Pastikan API menggunakan HTTPS
4. **Token Expiry**: Handle token expiry dengan refresh token
5. **Biometric Auth**: Implementasi fingerprint/face ID (opsional)

## 📱 Splash Screen Template

```dart
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _checkAuthStatus();
  }

  Future<void> _checkAuthStatus() async {
    await Future.delayed(const Duration(seconds: 2)); // Show splash

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');

    if (token != null) {
      ApiService.setAuthToken(token);
      // Verify token dengan API
      final response = await ApiService.get('user');
      if (response['success']) {
        // Navigate to appropriate dashboard
        final userRole = response['user']['role'];
        Navigator.pushReplacementNamed(
          context,
          userRole == 'admin' ? '/admin' : '/user'
        );
      } else {
        // Token invalid, go to login
        Navigator.pushReplacementNamed(context, '/login');
      }
    } else {
      // No token, go to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4CAF50), Color(0xFF2196F3)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.business, size: 100, color: Colors.white),
              SizedBox(height: 24),
              Text(
                'BPS Cleaning System',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 48),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}
```
