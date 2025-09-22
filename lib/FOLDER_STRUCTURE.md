# 📁 Flutter Project Structure

Panduan struktur folder untuk **BPS Cleaning System** Flutter App.

## 🏗️ Struktur Folder Lengkap

```
lib/
├── main.dart                     # Entry point aplikasi
├── FOLDER_STRUCTURE.md          # Dokumentasi ini
│
├── screens/                      # Semua halaman aplikasi
│   ├── auth/                    # 🔐 Authentication pages
│   │   ├── login_page.dart      # ✅ Halaman login
│   │   ├── splash_screen.dart   # 🔄 Splash screen + auto-login
│   │   ├── forgot_password_page.dart # 🔄 Lupa password
│   │   └── README.md            # Dokumentasi auth
│   │
│   ├── admin/                   # 👨‍💼 Admin features
│   │   ├── admin_dashboard.dart # ✅ Dashboard admin
│   │   ├── user_management/     # 🔄 CRUD user
│   │   ├── reports/             # 🔄 Laporan & statistik
│   │   ├── schedule_management/ # 🔄 Manajemen jadwal
│   │   ├── settings/            # 🔄 Pengaturan sistem
│   │   └── README.md            # Dokumentasi admin
│   │
│   └── user/                    # 👤 User features
│       ├── user_dashboard.dart  # ✅ Dashboard user
│       ├── reports/             # 🔄 Buat & lihat laporan
│       ├── tasks/               # 🔄 Tugas cleaning
│       ├── profile/             # 🔄 Profil user
│       ├── history/             # 🔄 Riwayat aktivitas
│       └── README.md            # Dokumentasi user
│
├── widgets/                      # 🧩 Reusable components
│   ├── custom_button.dart       # ✅ Button dengan gradient
│   ├── custom_text_field.dart   # ✅ TextField dengan validasi
│   ├── loading_widget.dart      # 🔄 Loading indicators
│   ├── empty_state_widget.dart  # 🔄 Empty state
│   ├── error_widget.dart        # 🔄 Error handling
│   └── app_bar_widget.dart      # 🔄 Custom AppBar
│
├── services/                     # 🔌 API & Business Logic
│   ├── api_service.dart         # ✅ HTTP client & auth
│   ├── auth_service.dart        # 🔄 Authentication logic
│   ├── user_service.dart        # 🔄 User operations
│   ├── report_service.dart      # 🔄 Report operations
│   └── notification_service.dart # 🔄 Push notifications
│
├── models/                       # 📊 Data Models
│   ├── user_model.dart          # ✅ User data model
│   ├── report_model.dart        # 🔄 Report data model
│   ├── task_model.dart          # 🔄 Task data model
│   └── api_response_model.dart  # 🔄 Generic API response
│
├── utils/                        # 🛠️ Utilities
│   ├── constants.dart           # 🔄 App constants
│   ├── helpers.dart             # 🔄 Helper functions
│   ├── validators.dart          # 🔄 Form validators
│   └── date_utils.dart          # 🔄 Date formatting
│
└── theme/                        # 🎨 App Theming
    ├── app_theme.dart           # 🔄 App theme configuration
    ├── colors.dart              # 🔄 Color constants
    └── text_styles.dart         # 🔄 Text style constants
```

## 🎯 Status Legend

- ✅ **Selesai**: File sudah dibuat dan siap digunakan
- 🔄 **Pending**: Perlu dikerjakan oleh worker
- 📝 **Template**: Ada template/contoh yang bisa diikuti

## 🚀 Development Workflow

### 1. **Worker Admin** fokus pada:

```
screens/admin/
├── user_management/
├── reports/
├── schedule_management/
└── settings/
```

### 2. **Worker User** fokus pada:

```
screens/user/
├── reports/
├── tasks/
├── profile/
└── history/
```

### 3. **Worker Backend Integration** fokus pada:

```
services/
├── auth_service.dart
├── user_service.dart
├── report_service.dart
└── notification_service.dart
```

### 4. **Worker UI/UX** fokus pada:

```
widgets/
├── loading_widget.dart
├── empty_state_widget.dart
├── error_widget.dart
└── app_bar_widget.dart

theme/
├── app_theme.dart
├── colors.dart
└── text_styles.dart
```

## 📋 Development Guidelines

### 1. **Naming Convention**

- **Files**: `snake_case.dart`
- **Classes**: `PascalCase`
- **Variables/Methods**: `camelCase`
- **Constants**: `UPPER_SNAKE_CASE`

### 2. **Import Order**

```dart
// 1. Dart imports
import 'dart:convert';

// 2. Flutter imports
import 'package:flutter/material.dart';

// 3. Package imports
import 'package:http/http.dart' as http;

// 4. Local imports
import '../models/user_model.dart';
import '../services/api_service.dart';
```

### 3. **File Template**

````dart
import 'package:flutter/material.dart';

/// [ClassName] description
///
/// Contoh penggunaan:
/// ```dart
/// ClassName(
///   parameter: value,
/// )
/// ```
class ClassName extends StatefulWidget {
  const ClassName({super.key});

  @override
  State<ClassName> createState() => _ClassNameState();
}

class _ClassNameState extends State<ClassName> {
  // State variables here

  @override
  void initState() {
    super.initState();
    // Initialization code
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget tree here
    );
  }

  @override
  void dispose() {
    // Cleanup code
    super.dispose();
  }
}
````

## 🔗 Navigation Structure

```dart
// Route names
const String loginRoute = '/login';
const String adminDashboardRoute = '/admin';
const String userDashboardRoute = '/user';
const String adminUsersRoute = '/admin/users';
const String userReportsRoute = '/user/reports';

// Navigation examples
Navigator.pushNamed(context, adminUsersRoute);
Navigator.pushReplacementNamed(context, loginRoute);
```

## 🎨 Design System

### Colors

```dart
// Primary colors
const Color bpsGreen = Color(0xFF4CAF50);
const Color bpsBlue = Color(0xFF2196F3);

// Gradient
const List<Color> bpsGradient = [bpsGreen, bpsBlue];
```

### Typography

```dart
// Text styles
const TextStyle headingStyle = TextStyle(
  fontSize: 24,
  fontWeight: FontWeight.bold,
);

const TextStyle bodyStyle = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.normal,
);
```

## 📦 Dependencies Recommendations

### Core Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # HTTP client
  http: ^1.2.2

  # Local storage
  shared_preferences: ^2.2.2

  # State management (pilih salah satu)
  provider: ^6.1.2 # Recommended untuk pemula
  # bloc: ^8.1.4          # Untuk complex state
  # riverpod: ^2.4.10     # Modern alternative
```

### Feature Dependencies

```yaml
# Image & Camera
image_picker: ^1.0.7
camera: ^0.10.5+9

# Location
geolocator: ^12.0.0
geocoding: ^3.0.0

# Charts & Reports
fl_chart: ^0.68.0
pdf: ^3.10.8

# File handling
file_picker: ^8.0.0+1
path_provider: ^2.1.3

# UI enhancements
flutter_spinkit: ^5.2.1
cached_network_image: ^3.3.1
```

## 🔧 Development Tips

1. **Gunakan const constructor** untuk widget yang tidak berubah
2. **Extract widget** jika widget tree terlalu dalam
3. **Gunakan ApiService** untuk semua HTTP requests
4. **Implement proper error handling** di setiap API call
5. **Test di multiple devices** dan orientasi
6. **Follow Material Design guidelines**
7. **Optimize images** sebelum upload
8. **Use meaningful variable names**

## 📞 Support

Jika ada pertanyaan tentang struktur atau implementasi, diskusikan di:

- Team meeting
- Code review
- Documentation ini (update sesuai kebutuhan)

---

_Last updated: [Date] by [Your Name]_
