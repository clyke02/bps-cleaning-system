# 🧹 BPS Cleaning System

**Sistem Manajemen Pembersihan Gedung BPS Sukabumi**

Aplikasi mobile untuk monitoring dan manajemen pembersihan ruangan yang terintegrasi dengan notifikasi real-time.

---

## 📖 Tentang Aplikasi

**BPS Cleaning System** adalah aplikasi mobile yang dirancang untuk membantu pengelolaan tugas pembersihan gedung BPS Sukabumi secara efisien. Aplikasi ini memungkinkan admin untuk menugaskan area pembersihan kepada petugas, memantau progres pekerjaan secara real-time, dan menerima laporan pembersihan beserta bukti foto.

### 🎯 Tujuan

- Meningkatkan efisiensi manajemen pembersihan gedung
- Monitoring tugas pembersihan secara real-time
- Dokumentasi bukti pembersihan dengan foto
- Komunikasi cepat antara admin dan petugas via notifikasi
- Laporan terstruktur dan dapat di-export dalam bentuk PDF

---

## 📱 Fitur Utama

### 👨‍💼 Admin

- **Dashboard Statistik** - Monitoring laporan harian, mingguan, dan bulanan
- **Manajemen Area** - Kelola ruangan dengan checklist tugas pembersihan
- **Manajemen Petugas** - CRUD data petugas kebersihan
- **Generate Tugas Harian** - Auto-generate penugasan untuk semua petugas
- **Review Laporan** - Approve/Reject laporan dengan rating dan catatan
- **Download PDF** - Export laporan pembersihan dalam format PDF
- **Push Notification** - Kirim notifikasi ke petugas secara real-time

### 👨‍🔧 Petugas

- **Dashboard Tugas** - Lihat status tugas (Pending, Selesai, Ditolak)
- **Checklist Pembersihan** - Daftar item yang harus dibersihkan per area
- **Submit Laporan** - Upload foto bukti pembersihan + centang checklist
- **Laporan Darurat** - Kirim laporan masalah mendesak ke admin
- **Riwayat** - Lihat histori semua laporan yang pernah dikerjakan
- **Notifikasi** - Terima pemberitahuan approval/rejection dari admin
- **Profile** - Update data diri dan ganti password

---

## 🛠️ Teknologi yang Digunakan

### Backend (Laravel)

```
Framework    : Laravel 10.x
Language     : PHP 8.2+
Database     : MySQL / MariaDB
Auth         : Laravel Sanctum (Token-based)
Notification : Firebase Cloud Messaging (FCM) HTTP v1 API
HTTP Client  : Guzzle
Storage      : Local File System
```

**Package Utama:**

- `laravel/sanctum` - Authentication API
- `google/auth` - Firebase Admin SDK
- `guzzlehttp/guzzle` - HTTP Client untuk FCM

### Frontend (Flutter)

```
Framework       : Flutter 3.x
Language        : Dart 3.x
State Management: GetX
Navigation      : GetX Router
UI Components   : Material Design 3
```

**Package Utama:**

- `get` - State management & navigation
- `http` - API communication
- `shared_preferences` - Local storage
- `firebase_core` - Firebase initialization
- `firebase_messaging` - Push notifications
- `image_picker` - Ambil foto dari kamera/galeri
- `pdf` - Generate PDF reports
- `printing` - Print & share PDF
- `path_provider` - File path management

### Infrastructure & Services

```
Push Notification : Firebase Cloud Messaging (FCM)
Platform Support  : Android 5.0+ (API 21+), iOS 11.0+
Dev Server        : XAMPP / Laragon (Windows)
Production Server : Apache / Nginx + PHP-FPM
Timezone          : Asia/Jakarta (WIB/UTC+7)
```

---

## 🔐 Fitur Keamanan

- ✅ Token-based Authentication (Laravel Sanctum)
- ✅ Password Hashing (bcrypt)
- ✅ Input Validation & Sanitization
- ✅ SQL Injection Prevention (Eloquent ORM)
- ✅ XSS Protection (Laravel Blade escaping)
- ✅ CORS Configuration
- ✅ File Upload Validation (type, size, malware check)
- ✅ Secure FCM Token Storage
- ✅ Role-based Access Control (Admin/User)

---

## 📱 Platform Support

| Platform | Status         | Minimum Version |
| -------- | -------------- | --------------- |
| Android  | ✅ Supported   | 5.0+ (API 21)   |
| iOS      | ✅ Supported   | 11.0+           |
| Web      | 🚧 Coming Soon | -               |

---

## 🚀 Quick Start

Untuk panduan instalasi lengkap, lihat **[INSTALLATION.md](INSTALLATION.md)**

### Ringkasan Instalasi

1. Setup backend Laravel (`composer install`, migrate database)
2. Setup frontend Flutter (`flutter pub get`)
3. Konfigurasi Firebase (download `google-services.json`)
4. Update base URL di `environment.dart`
5. Run aplikasi (`flutter run`)

---

## 📄 Dokumentasi

- **Panduan Instalasi:** [INSTALLATION.md](INSTALLATION.md)
- **API Documentation:** Coming soon
- **User Manual:** Coming soon

---

## 🗺️ Roadmap

### ✅ Version 1.0 (Selesai)

- [x] Authentication system
- [x] Dashboard admin & petugas
- [x] CRUD Area & Petugas
- [x] Generate tugas harian
- [x] Submit & review laporan
- [x] Push notifications
- [x] PDF export laporan

### 🚧 Version 1.1 (Planning)

- [ ] Dark mode
- [ ] Multi-language (Indonesia/English)
- [ ] Export Excel
- [ ] Advanced statistics & charts
- [ ] Calendar view untuk tugas
- [ ] Barcode scanning area

### 💡 Version 2.0 (Future)

- [ ] Web dashboard untuk admin
- [ ] Real-time chat admin-petugas
- [ ] Attendance tracking dengan GPS
- [ ] Performance analytics dashboard

---

## 👥 Tim Pengembang

- **Project Manager** - Koordinasi & perencanaan
- **Backend Developer** - Laravel & API development
- **Mobile Developer** - Flutter app development
- **UI/UX Designer** - Design sistem & user interface

---

## 📞 Kontak & Dukungan

Jika ada pertanyaan atau kendala:

- **Email:** support@bpscleaning.com
- **GitHub Issues:** [Laporkan Bug](https://github.com/clyke02/bps-cleaning-system/issues)

---

## 📝 Lisensi

Project ini menggunakan MIT License - lihat file LICENSE untuk detail.

---

**Built with ❤️ for BPS Sukabumi**

**⭐ Jika project ini membantu, berikan star di repository!**
