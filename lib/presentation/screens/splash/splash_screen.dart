import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_styles.dart';
import '../../../core/utils/auth_helper.dart';
import '../../../shared/widgets/custom_snackbar.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _logoAnimation;
  late Animation<double> _textAnimation;

  @override
  void initState() {
    super.initState();

    // Setup animations
    _animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);

    _logoAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
      ),
    );

    _textAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeInOut),
      ),
    );

    // Start animations
    _animationController.forward();

    // Navigate after delay
    _navigateToNextScreen();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  Future<void> _navigateToNextScreen() async {
    await Future.delayed(const Duration(milliseconds: 3000));

    if (!mounted) return;

    // Check if user is already logged in
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final userRole = prefs.getString('user_role');
    final userId = prefs.getInt('user_id');

    if (token != null && userRole != null && userId != null) {
      // Validate user masih exist di database
      final isValidUser = await AuthHelper.validateUser(userId, token);

      if (isValidUser && mounted) {
        // User valid, navigate to appropriate dashboard
        if (userRole == 'admin') {
          Navigator.pushReplacementNamed(context, '/admin');
        } else {
          Navigator.pushReplacementNamed(context, '/user');
        }
      } else {
        // User tidak valid (sudah dihapus), logout dan clear data
        await AuthHelper.clearUserData();
        if (mounted) {
          Navigator.pushReplacementNamed(context, '/login');

          // Show message to user
          CustomSnackbar.showWarning(
            title: 'Akun Tidak Aktif',
            message: 'Akun Anda sudah tidak aktif. Silakan hubungi administrator.',
          );
        }
      }
    } else {
      // User not logged in, navigate to login
      Navigator.pushReplacementNamed(context, '/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(gradient: AppColors.backgroundGradient),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Spacer(flex: 2),

                  // Logo Animation
                  AnimatedBuilder(
                    animation: _logoAnimation,
                    builder: (context, child) {
                      final opacity = _logoAnimation.value.clamp(0.0, 1.0);
                      final scale = _logoAnimation.value.clamp(0.0, 1.0);

                      return Transform.scale(
                        scale: scale,
                        child: Opacity(
                          opacity: opacity,
                          child: Container(
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.9),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 20,
                                  offset: const Offset(0, 10),
                                ),
                              ],
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(20),
                              child: Image.asset(
                                'assets/images/bpsLogo.png',
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                                  // Fallback icon if logo not found
                                  return const Icon(Icons.business, size: 50, color: Colors.blue);
                                },
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),

                  const SizedBox(height: 40),

                  // App Title Animation
                  AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      final opacity = _textAnimation.value.clamp(0.0, 1.0);
                      final translateY = 20 * (1 - _textAnimation.value);

                      return Transform.translate(
                        offset: Offset(0, translateY),
                        child: Opacity(
                          opacity: opacity,
                          child: Column(
                            children: [
                              const Text(
                                'BPS Cleaning System',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  letterSpacing: 1.2,
                                  shadows: [Shadow(color: Colors.black26, offset: Offset(0, 2), blurRadius: 4)],
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Sistem Manajemen Kebersihan',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.white.withOpacity(0.9),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'BPS Kota Sukabumi',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                  color: Colors.white.withOpacity(0.8),
                                  letterSpacing: 0.5,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),

                  // Loading Indicator
                  AnimatedBuilder(
                    animation: _textAnimation,
                    builder: (context, child) {
                      final opacity = _textAnimation.value.clamp(0.0, 1.0);

                      return Opacity(
                        opacity: opacity,
                        child: SizedBox(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation<Color>(Colors.white.withOpacity(0.8)),
                            strokeWidth: 3,
                          ),
                        ),
                      );
                    },
                  ),

                  const Spacer(flex: 1),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
