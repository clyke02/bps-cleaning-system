# 🧹 BPS Cleaning System

Sistem manajemen pembersihan digital untuk BPS (Badan Pusat Statistik) Sukabumi. Aplikasi ini memungkinkan pengelolaan area pembersihan, penugasan harian, dan pelaporan real-time dengan foto.

---

## 📱 Fitur Utama

### 👨‍💼 Admin Dashboard

- **Dashboard Statistik**: Monitoring laporan harian, mingguan, dan bulanan
- **Manajemen User**: CRUD petugas pembersihan dengan role-based access
- **Manajemen Area**: Kelola area pembersihan dengan checklist tugas detail
- **Generate Tugas**: Otomatis generate tugas harian untuk semua area (mode kolaboratif)
- **Verifikasi Laporan**: Review dan approve/reject laporan pembersihan
- **Profile Management**: Ubah password, panduan aplikasi, logout

### 👷 User (Petugas) Features

- **Dashboard Aktivitas**: Lihat tugas pending dan selesai
- **Aktivitas Terbaru**: List area yang perlu dibersihkan hari ini
- **Checklist Pembersihan**: Detail item kebersihan per area
- **Laporan Real-time**: Upload foto before/after dengan checklist
- **Riwayat**: Lihat semua laporan yang pernah dikerjakan
- **Profile**: Ubah password dan logout

---

## 🏗️ Teknologi Stack

### Frontend (Flutter)

- **Framework**: Flutter 3.x
- **State Management**: GetX
- **Local Storage**: SharedPreferences
- **HTTP Client**: http package
- **UI/UX**: Material Design dengan custom gradient

### Backend (Laravel)

- **Framework**: Laravel 10.x
- **Authentication**: Laravel Sanctum (Bearer Token)
- **Database**: MySQL
- **Storage**: Local file system untuk foto laporan
- **API**: RESTful API

---

## 📂 Struktur Proyek

```
bps_cleaning_system/
├── lib/                           # Flutter Frontend
│   ├── config/                    # API & Environment config
│   ├── core/                      # Constants, themes, utilities
│   ├── data/                      # Data layer (datasources, models, repositories)
│   ├── presentation/              # UI layer (screens, controllers, widgets)
│   │   ├── screens/
│   │   │   ├── admin/            # Admin module
│   │   │   │   ├── modules/      # Dashboard, User, Area, Laporan
│   │   │   │   └── widgets/      # Admin widgets
│   │   │   ├── user/             # User module
│   │   │   │   └── modules/      # Home, Laporan, Profile
│   │   │   ├── login/            # Login screen
│   │   │   └── splash/           # Splash screen
│   │   └── widgets/              # Global widgets
│   ├── services/                  # PDF service
│   └── main.dart                  # Entry point
│
├── backend/                       # Laravel Backend
│   ├── app/
│   │   ├── Http/Controllers/Api/  # API Controllers
│   │   └── Models/                # Eloquent Models
│   ├── database/
│   │   ├── migrations/            # Database migrations
│   │   └── seeders/               # Data seeders
│   ├── routes/api.php             # API routes
│   └── .env                       # Environment config
│
├── assets/                        # Images & assets
├── pubspec.yaml                   # Flutter dependencies
└── README.md                      # Dokumentasi ini
```

---

## 🚀 Quick Start

### Prasyarat

Pastikan sudah terinstall:

- **Flutter SDK** (3.0 atau lebih tinggi)
- **Dart SDK** (sudah termasuk dalam Flutter)
- **PHP** (8.1 atau lebih tinggi)
- **Composer**
- **MySQL** (atau MariaDB)
- **Git**

Verifikasi instalasi:

```bash
flutter doctor
php -v
composer -v
mysql --version
```

---

### 1️⃣ Setup Database

1. **Buat database MySQL**:

```sql
CREATE DATABASE bps_cleaning CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
```

2. **Buat user (opsional)**:

```sql
CREATE USER 'bps_user'@'localhost' IDENTIFIED BY 'password123';
GRANT ALL PRIVILEGES ON bps_cleaning.* TO 'bps_user'@'localhost';
FLUSH PRIVILEGES;
```

---

### 2️⃣ Setup Backend (Laravel)

```bash
# Masuk ke folder backend
cd backend

# Install dependencies
composer install

# Copy environment file
cp .env.example .env

# Generate application key
php artisan key:generate

# Edit file .env dengan kredensial database Anda
# DB_DATABASE=bps_cleaning
# DB_USERNAME=root
# DB_PASSWORD=

# Jalankan migration
php artisan migrate

# Seed data user (admin & petugas)
php artisan db:seed --class=UserSeeder

# Jalankan Laravel server
php artisan serve
```

Backend akan berjalan di: `http://localhost:8000`

---

### 3️⃣ Setup Frontend (Flutter)

```bash
# Kembali ke root project
cd ..

# Install dependencies
flutter pub get

# Setup environment (opsional - untuk emulator/device fisik)
# Edit lib/config/environment.dart sesuai kebutuhan

# Jalankan aplikasi
flutter run
```

Pilih device:

- **Android**: Emulator atau device fisik via USB
- **iOS**: Simulator (macOS only)
- **Web**: Chrome browser
- **Desktop**: Windows/macOS/Linux

---

## 👥 Akun Default

Setelah menjalankan seeder, Anda dapat login dengan akun berikut:

| Role  | Email                  | Password | Telepon        |
| ----- | ---------------------- | -------- | -------------- |
| Admin | admin@bps.go.id        | admin123 | 0812-3456-7890 |
| User  | ahmad@bps.go.id        | user123  | 0856-7890-1234 |
| User  | superpetugas@bps.go.id | user123  | 0821-9876-5432 |

---

## 🔄 Alur Kerja Aplikasi

### Mode Kolaboratif (Shared Assignment)

Aplikasi ini menggunakan **sistem penugasan kolaboratif** dimana:

1. **Admin generate tugas harian** → 1 area = 1 tugas (shared)
2. **Semua petugas** melihat tugas yang sama
3. **Siapa yang selesai duluan** mengerjakan dan upload laporan
4. **Status otomatis update** untuk semua petugas (pending → selesai)

**Contoh**:

- Ada 3 area: Lantai 1, Lantai 2, Ruang Meeting
- Generate tugas → 3 tugas dibuat (bukan 3 x jumlah petugas)
- Ahmad selesai bersihkan Lantai 1 → Status "Selesai" untuk semua
- Super Petugas bersihkan Lantai 2 → Status "Selesai" untuk semua

---

## 🛠️ Development

### Struktur Arsitektur

Aplikasi menggunakan **Clean Architecture** dengan layer:

1. **Presentation Layer**: UI, Controllers (GetX), Widgets
2. **Data Layer**: Repositories, Data Sources, Models
3. **Core Layer**: Constants, Utilities, Themes

### State Management

Menggunakan **GetX** untuk:

- Reactive state management
- Dependency injection
- Route management
- Dialog & Snackbar

### API Communication

- **Base URL**: Dikonfigurasi di `lib/config/environment.dart`
- **Authentication**: Bearer Token (Laravel Sanctum)
- **Caching**: Area & statistics di-cache untuk performa
- **Timeout**: 30 detik untuk request normal

---

## 📸 Upload Foto

### Format & Validasi

- **Format**: JPEG, PNG
- **Ukuran**: Maks 5MB per foto
- **Kompresi**: Otomatis resize jika > 1920px
- **Storage**: `backend/storage/app/public/reports/`

### Cara Kerja

1. User pilih foto dari gallery/camera
2. Foto di-compress di frontend
3. Upload via multipart/form-data
4. Backend simpan di storage & return URL
5. URL disimpan di database

---

## 🔐 Security

- **Password**: Hash dengan bcrypt (Laravel default)
- **Token**: Laravel Sanctum dengan expiry
- **Validation**: User existence check di setiap request
- **Auto-logout**: Jika user dihapus dari database
- **CORS**: Configured untuk development & production

---

## 🧪 Testing

### Backend (Laravel)

```bash
cd backend

# Jalankan semua test
php artisan test

# Test spesifik
php artisan test --filter=UserTest
```

### Frontend (Flutter)

```bash
# Jalankan semua test
flutter test

# Test spesifik
flutter test test/widget_test.dart

# Coverage
flutter test --coverage
```

---

## 📦 Build & Deployment

### Build APK (Android)

```bash
# Debug APK
flutter build apk --debug

# Release APK
flutter build apk --release

# Split APK per ABI (file lebih kecil)
flutter build apk --split-per-abi --release
```

Output: `build/app/outputs/flutter-apk/`

### Build Web

```bash
flutter build web --release
```

Output: `build/web/`

### Deploy Backend

```bash
cd backend

# Production mode
php artisan config:cache
php artisan route:cache
php artisan view:cache

# Set permissions
chmod -R 775 storage bootstrap/cache
```

---

## 🐛 Troubleshooting

### Flutter Issues

**Hot reload error setelah ubah widget type**:

```bash
# Tekan 'R' (uppercase) untuk hot restart
# Atau restart app sepenuhnya
```

**Build error**:

```bash
flutter clean
flutter pub get
flutter run
```

**Dependency conflict**:

```bash
flutter pub upgrade --major-versions
```

### Laravel Issues

**Migration error**:

```bash
php artisan migrate:fresh --seed
```

**Storage permission**:

```bash
chmod -R 775 storage bootstrap/cache
```

**Cache issues**:

```bash
php artisan cache:clear
php artisan config:clear
php artisan route:clear
php artisan view:clear
```

---

## 📱 Platform Support

| Platform | Status       | Notes                    |
| -------- | ------------ | ------------------------ |
| Android  | ✅ Supported | Min SDK 21 (Android 5.0) |
| iOS      | ✅ Supported | Min iOS 11.0             |
| Web      | ✅ Supported | Modern browsers          |
| Windows  | ✅ Supported | Windows 10+              |
| macOS    | ✅ Supported | macOS 10.14+             |
| Linux    | ✅ Supported | Ubuntu 18.04+            |

---

## 🤝 Contributing

1. Fork repository
2. Buat feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit changes (`git commit -m 'feat: Add some AmazingFeature'`)
4. Push ke branch (`git push origin feature/AmazingFeature`)
5. Buat Pull Request

### Commit Message Convention

Gunakan [Conventional Commits](https://www.conventionalcommits.org/):

- `feat:` - Fitur baru
- `fix:` - Perbaikan bug
- `docs:` - Dokumentasi
- `style:` - Format kode
- `refactor:` - Refactoring
- `perf:` - Peningkatan performa
- `test:` - Tambah/update test
- `chore:` - Maintenance

---

## 📄 License

Proyek ini dibuat untuk keperluan internal BPS Sukabumi.

---

## 👨‍💻 Developer Contact

Untuk pertanyaan atau bantuan, hubungi tim developer BPS Sukabumi.

---

## 📝 Changelog

### Version 1.0.0 (Current)

**Features**:

- ✅ Admin dashboard dengan statistik
- ✅ Manajemen user (CRUD)
- ✅ Manajemen area dengan checklist detail
- ✅ Generate tugas harian otomatis (mode kolaboratif)
- ✅ Upload laporan dengan foto
- ✅ Verifikasi laporan oleh admin
- ✅ Profile management (ubah password)
- ✅ Auto-logout untuk user yang dihapus
- ✅ Panduan aplikasi

**Tech Stack**:

- Flutter 3.x + GetX
- Laravel 10.x + Sanctum
- MySQL Database

---

**Built with ❤️ for BPS Sukabumi**
