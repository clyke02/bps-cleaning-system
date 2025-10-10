# Admin Dashboard & Features

Folder ini berisi semua halaman dan fitur khusus untuk **Administrator**.

## 📁 Struktur Folder

```
admin/
├── admin_dashboard.dart          # Dashboard utama admin
├── user_management/              # Manajemen user
│   ├── user_list.dart           # Daftar user
│   ├── user_detail.dart         # Detail user
│   └── user_form.dart           # Form tambah/edit user
├── reports/                      # Laporan dan statistik
│   ├── cleaning_reports.dart    # Laporan kebersihan
│   ├── statistics.dart          # Dashboard statistik
│   └── export_reports.dart      # Export laporan
├── schedule_management/          # Manajemen jadwal
│   ├── schedule_list.dart       # Daftar jadwal
│   ├── schedule_form.dart       # Form jadwal
│   └── assign_tasks.dart        # Assign tugas ke user
└── settings/                     # Pengaturan sistem
    ├── app_settings.dart        # Pengaturan aplikasi
    ├── notification_settings.dart # Pengaturan notifikasi
    └── backup_restore.dart      # Backup & restore
```

## 🎯 Fitur Admin

- ✅ **Dashboard**: Statistik dan overview sistem
- 🔄 **User Management**: CRUD user, role management
- 🔄 **Reports**: Laporan kebersihan, statistik, export
- 🔄 **Schedule**: Manajemen jadwal cleaning
- 🔄 **Settings**: Konfigurasi sistem

## 🚀 Development Guidelines

### 1. Naming Convention

- File: `snake_case.dart`
- Class: `PascalCase`
- Variable/Method: `camelCase`

### 2. Widget Structure

```dart
class AdminFeaturePage extends StatefulWidget {
  const AdminFeaturePage({super.key});

  @override
  State<AdminFeaturePage> createState() => _AdminFeaturePageState();
}

class _AdminFeaturePageState extends State<AdminFeaturePage> {
  // State variables here

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Feature Name'),
        backgroundColor: const Color(0xFF4CAF50), // Admin green
      ),
      body: const AdminFeatureBody(),
    );
  }
}
```

### 3. API Integration

```dart
// Gunakan ApiService yang sudah dibuat
import '../../services/api_service.dart';

// Contoh penggunaan
Future<void> _loadData() async {
  final response = await ApiService.get('admin/users');
  if (response['success']) {
    // Handle success
  } else {
    // Handle error
  }
}
```

### 4. Navigation

```dart
// Ke halaman admin lain
Navigator.pushNamed(context, '/admin/users');

// Kembali ke dashboard
Navigator.pushReplacementNamed(context, '/admin');

// Logout
Navigator.pushReplacementNamed(context, '/login');
```

## 🎨 UI Guidelines

- **Primary Color**: `Color(0xFF4CAF50)` (Hijau)
- **Accent Color**: `Color(0xFF66BB6A)` (Hijau terang)
- **Background**: `Colors.grey[50]` atau `Colors.white`
- **Text**: `Colors.black87` untuk primary, `Colors.grey[600]` untuk secondary

## 📝 TODO List untuk Worker

- [ ] Implementasi User Management (CRUD)
- [ ] Laporan Kebersihan dengan chart/grafik
- [ ] Manajemen Jadwal Cleaning
- [ ] Export laporan ke PDF/Excel
- [ ] Notifikasi push untuk admin
- [ ] Backup & restore data
- [ ] Settings halaman

## 🔗 Dependencies yang Mungkin Dibutuhkan

```yaml
dependencies:
  # Chart/grafik
  fl_chart: ^0.68.0

  # PDF generation
  pdf: ^3.10.8
  printing: ^5.12.0

  # Excel export
  excel: ^4.0.3

  # File picker
  file_picker: ^8.0.0+1

  # Image picker
  image_picker: ^1.0.7
```
