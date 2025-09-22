## bps_cleaning_system

Panduan pengembangan Flutter untuk proyek bps_cleaning_system dan alur kerja Git untuk tim.

### Ringkasan

- **Platform**: Android, iOS, Web, Windows, macOS, Linux
- **SDK**: Flutter (lihat versi yang Anda gunakan secara lokal dengan `flutter --version`)
- **Bahasa**: Dart

## Prasyarat

Pastikan alat berikut terpasang:

- **Flutter SDK**: ikuti panduan resmi (`https://docs.flutter.dev/get-started/install`)
- **Dart SDK**: sudah termasuk dalam Flutter
- **Android Studio / Xcode**: untuk build Android/iOS
- **Java JDK** (untuk Android build)
- **Git**

Verifikasi instalasi:

```bash
flutter doctor
```

## Setup Proyek

1. Clone repo:

```bash
git clone <URL_REPO_ANDA>
cd bps_cleaning_system
```

2. Ambil dependency:

```bash
flutter pub get
```

3. (Opsional) Atur toolchain platform yang diperlukan (Android/iOS/Web/Desktop) sesuai output `flutter doctor`.

## Menjalankan Aplikasi (Debug)

- Jalankan di device/emulator yang tersedia:

```bash
flutter devices
flutter run
```

- Menentukan platform secara eksplisit:

```bash
# Android
flutter run -d android

# iOS (butuh macOS + Xcode)
flutter run -d ios

# Web
flutter run -d chrome

# Windows
flutter run -d windows

# macOS
flutter run -d macos

# Linux
flutter run -d linux
```

## Struktur Proyek (Ringkas)

- `lib/main.dart`: entry point aplikasi Flutter.
- `android/`, `ios/`, `macos/`, `linux/`, `windows/`, `web/`: konfigurasi platform.
- `pubspec.yaml`: dependency, asset, environment SDK.
- `test/`: unit/widget tests.

Direkomendasikan menambah struktur di `lib/` seperti:

- `lib/src/` → berisi modul fitur.
- `lib/common/` → widget umum, tema, utilitas.

## Perintah Pengembangan Umum

- Format & analisis kode:

```bash
flutter format .
flutter analyze
```

- Menjalankan tes:

```bash
flutter test
```

- Build release:

```bash
# Android (APK)
flutter build apk --release

# Android (App Bundle)
flutter build appbundle --release

# iOS (butuh macOS)
flutter build ios --release

# Web
flutter build web --release

# Windows
flutter build windows --release

# macOS
flutter build macos --release

# Linux
flutter build linux --release
```

## Konfigurasi Platform

- Android: versi Gradle/SDK di `android/build.gradle.kts` dan `android/gradle.properties`.
- iOS/macOS: pengaturan `Info.plist`, skema di `Runner.xcodeproj`/`Runner.xcworkspace`.
- Web: `web/index.html`, `web/manifest.json` untuk PWA.
- Windows/Linux: CMakeLists pada direktori platform terkait.

## Gaya Kode

- Ikuti rekomendasi `flutter analyze` tanpa error/warning.
- Gunakan nama variabel/deskriptif dan hindari singkatan tidak jelas.
- Pisahkan widget besar menjadi widget kecil yang dapat diuji.

## Manajemen Rahasia/Environment

- Simpan kunci/secret di system env, `.env`, atau layanan secret manager CI.
- Jangan commit kredensial atau file rahasia ke Git.

---

## Workflow Git untuk Tim

Workflow berikut dirancang agar sederhana namun terkontrol.

### Cabang Utama

- `main`: selalu stabil; berisi rilis produksi.

### Cabang Pekerjaan

- `feature/<deskripsi-singkat>`: pengembangan fitur baru.
- `bugfix/<deskripsi-singkat>`: perbaikan bug non-produksi.
- `hotfix/<deskripsi-singkat>`: perbaikan kritis pada produksi (bercabang dari `main`).
- `release/<versi>`: tahap stabilisasi menuju rilis (opsional; gunakan untuk rilis besar).

### Alur Pekerjaan Harian

1. Sinkronkan `main`:

```bash
git checkout main
git pull origin main
```

2. Buat cabang baru dari `main`:

```bash
git checkout -b feature/nama-fitur
```

3. Kerjakan perubahan, commit kecil dan sering:

```bash
git add .
git commit -m "feat: deskripsi singkat perubahan"
```

4. Dorong cabang dan buka Pull Request (PR) ke `main`:

```bash
git push -u origin feature/nama-fitur
```

5. Review code minimal oleh 1 rekan, pastikan:

- Build lulus (jika ada CI)
- `flutter analyze` dan `flutter test` lulus

6. Setelah disetujui, merge via PR (squash merge direkomendasikan).
7. Hapus cabang feature setelah merge.

### Konvensi Commit (Conventional Commits)

Gunakan tipe berikut di awal pesan commit:

- `feat:` penambahan fitur
- `fix:` perbaikan bug
- `docs:` dokumentasi
- `style:` format/white-space, tanpa perubahan kode
- `refactor:` perombakan kode tanpa fitur/bugfix
- `perf:` perbaikan performa
- `test:` menambah/memperbaiki tes
- `build:` perubahan build/dep
- `ci:` konfigurasi CI
- `chore:` tugas rutin lain

Contoh:

```bash
git commit -m "feat: tambah halaman login dan validasi form"
```

### Hotfix ke Produksi

1. Buat cabang dari `main`:

```bash
git checkout main && git pull
git checkout -b hotfix/perbaiki-crash-splash
```

2. Perbaiki, commit, PR ke `main`, merge.
3. Tag rilis (opsional):

```bash
git tag -a v1.0.1 -m "Hotfix crash splash screen"
git push origin v1.0.1
```

### Rilis

- Opsional gunakan `release/<versi>` untuk stabilisasi: hanya bugfix, no fitur baru.
- Setelah siap, merge ke `main`, buat tag.

### Praktik Baik

- Satu PR fokus pada satu tujuan.
- Sertakan deskripsi dan langkah uji di PR.
- Hindari commit binary besar; gunakan LFS bila perlu.
- Rebase ringan sebelum buka PR untuk riwayat bersih:

```bash
git fetch origin
git rebase origin/main
```

---

## Setup Laravel Backend (bps-cleaning-system)

### Struktur Project

```
bps_cleaning_system/
├── lib/                    # Flutter app
├── android/               # Android config
├── ios/                   # iOS config
├── web/                   # Web config
├── backend/               # Laravel API (backend)
│   ├── app/
│   ├── config/
│   ├── database/
│   ├── routes/
│   └── .env
└── README.md
```

### Lokasi Backend

Backend Laravel sekarang berada di: `backend/` (subfolder dalam project Flutter)

### Setup Database MySQL

1. **Pastikan MySQL berjalan** di port 3306
2. **Database sudah dibuat** dengan nama `bps_cleaning` (sesuai spesifikasi)
3. **File .env Laravel** berada di `backend/.env`

### Konfigurasi .env Laravel

File `.env` berada di folder `backend/.env`. Jika tidak ada, buat dengan isi:

```env
APP_NAME=Laravel
APP_ENV=local
APP_KEY=base64:1zun7pk+LTkIbv8yxf4GKczP9v4CokVpSa7JTFIQj2I=
APP_DEBUG=true
APP_URL=http://localhost:8000

DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bps_cleaning
DB_USERNAME=root
DB_PASSWORD=

# ... (konfigurasi lainnya tetap default)
```

### Menjalankan Migration & Seeder

```bash
# Dari root project (bps_cleaning_system/)
cd backend

# Jalankan migration
php artisan migrate

# Insert data user manual (karena seeder bermasalah)
# Gunakan MySQL client atau phpMyAdmin untuk menjalankan:
INSERT INTO users (name, email, password, role, created_at, updated_at) VALUES
('Admin 01', 'admin01@example.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'admin', NOW(), NOW()),
('User 01', 'user01@example.com', '$2y$12$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi', 'user', NOW(), NOW());
```

**Password untuk kedua akun: `secret`** (hash di atas adalah untuk password 'secret')

### Menjalankan Laravel Server

```bash
# Dari root project (bps_cleaning_system/)
cd backend
php artisan serve
```

Server akan berjalan di `http://localhost:8000`

### API Endpoints

- **POST** `/api/login` - Login dengan email & password
- **POST** `/api/logout` - Logout (dengan Bearer token)
- **GET** `/api/user` - Get user info (dengan Bearer token)

### Testing API

Gunakan Postman atau curl untuk test:

```bash
curl -X POST http://localhost:8000/api/login \
  -H "Content-Type: application/json" \
  -d '{"email":"admin01@example.com","password":"secret"}'
```

### Akun Test

- **Admin**: `admin01@example.com` / `admin01`
- **User**: `user01@example.com` / `user01`

---

## 🚀 Menjalankan Full Project

### Development Workflow

1. **Jalankan Backend (Laravel) terlebih dahulu:**

```bash
# Terminal 1 - Backend
cd backend
php artisan serve
# Laravel akan berjalan di http://localhost:8000
```

2. **Jalankan Frontend (Flutter):**

```bash
# Terminal 2 - Frontend (dari root project)
flutter pub get
flutter run
# Pilih device (Android emulator, iOS simulator, Chrome, dll)
```

### Setup Project untuk Worker Baru

```bash
# Clone project
git clone <your-repo-url>
cd bps_cleaning_system

# Setup backend
cd backend
composer install
cp .env.example .env  # Edit database config sesuai README
php artisan key:generate
php artisan migrate
php artisan db:seed --class=UserSeeder

# Setup frontend
cd ..  # kembali ke root
flutter pub get

# Jalankan development
# Terminal 1: cd backend && php artisan serve
# Terminal 2: flutter run
```

### Project Structure untuk Git

```
bps_cleaning_system/          # Root repo (ini yang di-push ke GitHub)
├── lib/                      # Flutter source code
├── android/                  # Android platform files
├── ios/                      # iOS platform files
├── web/                      # Web platform files
├── backend/                  # Laravel API
│   ├── app/                  # Laravel app logic
│   ├── config/               # Laravel config
│   ├── database/             # Migrations, seeders
│   ├── routes/               # API routes
│   ├── .env                  # Laravel environment (JANGAN commit!)
│   ├── .gitignore           # Backend specific gitignore
│   └── vendor/               # Laravel dependencies (JANGAN commit!)
├── pubspec.yaml              # Flutter dependencies
├── .gitignore                # Main gitignore
└── README.md                 # Dokumentasi ini
```

### ✅ Status Backend (Sudah Diperbaiki)

- ✅ **Struktur**: Backend sudah dipindahkan ke `backend/` subfolder
- ✅ **API Routes**: Sudah terdaftar dan berfungsi (`/api/login`, `/api/logout`, `/api/user`)
- ✅ **Database**: Migration dan seeder sudah berjalan
- ✅ **Encoding**: File PHP sudah diperbaiki dari masalah encoding
- ✅ **Dependencies**: Laravel Sanctum sudah terinstall dan dikonfigurasi
- ✅ **User Data**: Admin dan User test sudah berhasil dibuat

### Testing Lengkap

1. **Backend API**: `http://localhost:8000/api/login`
2. **Frontend Flutter**: Login dengan akun test
3. **Integration**: Flutter → Laravel → MySQL

---

## Troubleshooting

- Jalankan `flutter clean && flutter pub get` jika terjadi error build aneh.
- Periksa `flutter doctor` untuk dependensi yang hilang.
- Pada Windows, pastikan PowerShell memiliki izin eksekusi bila skrip diperlukan.
- **Laravel**: Pastikan MySQL service berjalan dan database `bps_cleaning` sudah dibuat.
- **Laravel**: Jika migration gagal, periksa koneksi database di file `.env`.

## Referensi

- Dokumentasi Flutter: `https://docs.flutter.dev/`
- Dart Packages: `https://pub.dev/`
- Laravel Documentation: `https://laravel.com/docs`
- Laravel Sanctum: `https://laravel.com/docs/sanctum`
