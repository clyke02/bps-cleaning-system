import 'package:flutter/material.dart';

class AppColors {
  // 🎨 Modern Primary Colors - Vibrant Teal & Purple
  static const Color primary = Color(0xFF00BFA5); // Vibrant Teal
  static const Color primaryDark = Color(0xFF00897B); // Deep Teal
  static const Color primaryLight = Color(0xFF5EEAD4); // Light Teal

  // Secondary Colors - Deep Purple
  static const Color secondary = Color(0xFF7C3AED); // Vibrant Purple
  static const Color secondaryDark = Color(0xFF5B21B6); // Deep Purple
  static const Color secondaryLight = Color(0xFFA78BFA); // Light Purple

  // Accent Colors - Fresh & Modern
  static const Color accent = Color(0xFFFF6B9D); // Soft Pink
  static const Color accentOrange = Color(0xFFFF9B50); // Warm Orange
  static const Color accentYellow = Color(0xFFFFC93C); // Bright Yellow

  // Status Colors - Modern & Clear
  static const Color success = Color(0xFF10B981); // Emerald Green
  static const Color warning = Color(0xFFF59E0B); // Amber
  static const Color error = Color(0xFFEF4444); // Red
  static const Color info = Color(0xFF3B82F6); // Blue

  // Neutral Colors
  static const Color black = Color(0xFF000000);
  static const Color white = Color(0xFFFFFFFF);
  static const Color grey50 = Color(0xFFFAFAFA);
  static const Color grey100 = Color(0xFFF5F5F5);
  static const Color grey200 = Color(0xFFEEEEEE);
  static const Color grey300 = Color(0xFFE0E0E0);
  static const Color grey400 = Color(0xFFBDBDBD);
  static const Color grey500 = Color(0xFF9E9E9E);
  static const Color grey600 = Color(0xFF757575);
  static const Color grey700 = Color(0xFF616161);
  static const Color grey800 = Color(0xFF424242);
  static const Color grey900 = Color(0xFF212121);

  // Background Colors - Vibrant Gradient
  static const Color background = Color(0xFF53D1ED); // Sky Blue
  static const Color backgroundStart = Color(0xFF53D1ED); // Sky Blue (8%)
  static const Color backgroundMid = Color(0xFF2CA619); // Fresh Green (46%)
  static const Color backgroundEnd = Color(0xFFF2994B); // Warm Orange (100%)
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);
  static const Color overlay = Color(0x80000000); // 50% black

  // Text Colors - Modern Contrast
  static const Color textPrimary = Color(0xFF1E293B); // Slate 800
  static const Color textSecondary = Color(0xFF64748B); // Slate 500
  static const Color textDisabled = Color(0xFFCBD5E1); // Slate 300
  static const Color textOnPrimary = Color(0xFFFFFFFF);

  // Border Colors - Subtle
  static const Color border = Color(0xFFE2E8F0); // Slate 200
  static const Color borderLight = Color(0xFFF1F5F9); // Slate 100
  static const Color borderDark = Color(0xFFCBD5E1); // Slate 300

  // Gradient Colors
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF00BFA5), Color(0xFF00D4BD)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient secondaryGradient = LinearGradient(
    colors: [Color(0xFF7C3AED), Color(0xFF9333EA)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient accentGradient = LinearGradient(
    colors: [Color(0xFFFF6B9D), Color(0xFFFF8FB9)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  // Background Gradient - Natural & Soft (SMOOTH DIAGONAL)
  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topLeft, // ↖️ mulai dari kiri atas
    end: Alignment.bottomRight, // ↘️ berakhir di kanan bawah
    colors: [
      Color(0xFF4FACFE), // Soft Sky Blue - kiri atas
      Color(0xFF00D4FF), // Bright Cyan - transisi 1
      Color(0xFF00C9FF), // Light Blue - transisi 2
      Color(0xFF92FE9D), // Soft Mint Green - transisi 3
      Color(0xFFFFCC70), // Warm Peach - kanan bawah
    ],
    stops: [0.0, 0.2, 0.4, 0.7, 1.0], // distribusi warna yang lebih natural
  );
}

class AppSizes {
  // Padding & Margin - Modern Spacing
  static const double paddingXS = 4.0;
  static const double paddingS = 8.0;
  static const double paddingM = 16.0;
  static const double paddingL = 24.0;
  static const double paddingXL = 32.0;
  static const double paddingXXL = 40.0;

  // Border Radius - Softer & Rounder
  static const double radiusXS = 6.0;
  static const double radiusS = 10.0;
  static const double radiusM = 14.0;
  static const double radiusL = 18.0;
  static const double radiusXL = 24.0;
  static const double radiusXXL = 32.0;
  static const double radiusCircular = 999.0;

  // Icon Sizes
  static const double iconXS = 16.0;
  static const double iconS = 20.0;
  static const double iconM = 24.0;
  static const double iconL = 32.0;
  static const double iconXL = 48.0;

  // Font Sizes
  static const double fontXS = 10.0;
  static const double fontS = 12.0;
  static const double fontM = 14.0;
  static const double fontL = 16.0;
  static const double fontXL = 18.0;
  static const double fontXXL = 20.0;
  static const double fontTitle = 22.0;
  static const double fontHeading = 24.0;

  // Button Heights
  static const double buttonHeightS = 32.0;
  static const double buttonHeightM = 40.0;
  static const double buttonHeightL = 48.0;

  // Card Elevation - Subtle Shadows
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationS = 2.0;
  static const double elevationM = 4.0;
  static const double elevationL = 8.0;
  static const double elevationXL = 12.0;
  static const double elevationXXL = 20.0;

  // Animation Durations
  static const Duration durationFast = Duration(milliseconds: 150);
  static const Duration durationNormal = Duration(milliseconds: 250);
  static const Duration durationSlow = Duration(milliseconds: 400);
}

// 🎭 Custom Shadows for Modern Look
class AppShadows {
  static List<BoxShadow> get small => [
    BoxShadow(
      color: Colors.black.withOpacity(0.04),
      blurRadius: 4,
      offset: const Offset(0, 2),
    ),
  ];

  static List<BoxShadow> get medium => [
    BoxShadow(
      color: Colors.black.withOpacity(0.06),
      blurRadius: 12,
      offset: const Offset(0, 4),
    ),
  ];

  static List<BoxShadow> get large => [
    BoxShadow(
      color: Colors.black.withOpacity(0.08),
      blurRadius: 24,
      offset: const Offset(0, 8),
    ),
  ];

  static List<BoxShadow> get colored => [
    BoxShadow(
      color: AppColors.primary.withOpacity(0.15),
      blurRadius: 16,
      offset: const Offset(0, 6),
    ),
  ];
}
