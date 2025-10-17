# 📋 Panduan Instalasi BPS Cleaning System

Panduan lengkap untuk setup dan menjalankan aplikasi dari awal hingga siap digunakan.

---

## ⚠️ PENTING - Baca Dulu!

Panduan ini ditulis untuk pemula. Ikuti langkah demi langkah dengan teliti.  
**Jangan skip langkah apapun** atau aplikasi tidak akan jalan.

**Estimasi waktu:** 30-45 menit untuk instalasi pertama kali.

---

## 📦 Yang Harus Diinstall Dulu

### 1. Untuk Backend (Server)

#### A. XAMPP

- **Download:** https://www.apachefriends.org/download.html
- **Pilih:** XAMPP untuk Windows dengan PHP 8.2
- **Install di:** `C:\xampp` (default)
- **Yang dibutuhkan:**
  - ✅ Apache (web server)
  - ✅ MySQL (database)
  - ✅ PHP 8.2+
  - ✅ phpMyAdmin (manage database)

**Cara Install:**

1. Download file installer
2. Jalankan sebagai Administrator
3. Ikuti wizard instalasi
4. Pilih komponen: Apache, MySQL, PHP, phpMyAdmin
5. Install di `C:\xampp`
6. Finish

#### B. Composer (PHP Package Manager)

- **Download:** https://getcomposer.org/download/
- **Pilih:** Composer-Setup.exe untuk Windows
- **Cara Install:**
  1. Download installer
  2. Jalankan installer
  3. Ikuti wizard (akan detect PHP dari XAMPP otomatis)
  4. Finish
  5. **Test:** Buka Command Prompt, ketik `composer --version`
  6. Kalau muncul versi Composer → Berhasil!

### 2. Untuk Frontend (Aplikasi Mobile)

#### A. Flutter SDK

- **Download:** https://docs.flutter.dev/get-started/install/windows
- **Pilih:** Windows - Flutter SDK
- **Cara Install:**
  1. Download file `flutter_windows_xxx.zip`
  2. Extract ke `C:\src\flutter` (JANGAN di Program Files!)
  3. Tambahkan Flutter ke PATH:
     - Buka "Environment Variables"
     - Edit "Path" di System Variables
     - Tambahkan: `C:\src\flutter\bin`
     - Klik OK semua
  4. **Test:** Buka Command Prompt baru, ketik `flutter --version`
  5. Jalankan `flutter doctor` untuk cek requirement

#### B. Android Studio

- **Download:** https://developer.android.com/studio
- **Untuk:** Development Android app + Emulator
- **Cara Install:**
  1. Download installer (±1GB)
  2. Install dengan default settings
  3. Buka Android Studio
  4. Ikuti wizard pertama kali (download SDK, tools, dll)
  5. Install plugin:
     - Buka: File → Settings → Plugins
     - Cari "Flutter" dan "Dart"
     - Install kedua plugin
     - Restart Android Studio

#### C. Visual Studio Code (Opsional, tapi direkomendasikan)

- **Download:** https://code.visualstudio.com/
- **Install Extension:**
  1. Buka VS Code
  2. Klik icon Extensions (kotak 4 di sidebar kiri)
  3. Install:
     - Flutter
     - Dart
     - Laravel Extension Pack (opsional)

### 3. Firebase Account

#### Setup Firebase Project

1. **Buka:** https://console.firebase.google.com/
2. **Login** dengan Google Account
3. **Klik:** "Add Project" atau "Tambah Project"
4. **Nama Project:** `bps-cleaning-system`
5. **Analytics:** Enable (opsional)
6. **Tunggu** project dibuat (±30 detik)
7. **Selesai!**

---

## 🚀 Langkah Instalasi

### BAGIAN 1: Setup Backend (Laravel)

#### Langkah 1: Clone/Download Project

**Jika punya Git:**

```bash
cd C:\xampp\htdocs
git clone https://github.com/clyke02/bps-cleaning-system.git
cd bps-cleaning-system
```

**Jika tidak punya Git:**

1. Download project sebagai ZIP dari GitHub
2. Extract ke `C:\xampp\htdocs\bps-cleaning-system`
3. Pastikan strukturnya: `C:\xampp\htdocs\bps-cleaning-system\backend\`

#### Langkah 2: Masuk ke Folder Backend

```bash
cd C:\xampp\htdocs\bps-cleaning-system\backend
```

#### Langkah 3: Install Dependencies Laravel

```bash
composer install
```

**Tunggu proses selesai** (5-10 menit pertama kali, tergantung internet).

**Jika error "composer not found":**

- Tutup CMD/PowerShell
- Buka CMD/PowerShell **BARU** (agar ENV variables ter-reload)
- Coba lagi

#### Langkah 4: Copy File Environment

```bash
copy .env.example .env
```

**Penjelasan:** File `.env` berisi konfigurasi database, API key, dll.

#### Langkah 5: Generate Application Key

```bash
php artisan key:generate
```

**Hasilnya:** File `.env` akan diupdate dengan APP_KEY

#### Langkah 6: Buat Database

**Via phpMyAdmin:**

1. **Buka browser:** http://localhost/phpmyadmin
2. **Login:**
   - Username: `root`
   - Password: (kosongkan)
3. **Klik:** "New" di sidebar kiri
4. **Database name:** `bps_cleaning_system`
5. **Collation:** `utf8mb4_general_ci`
6. **Klik:** "Create"

**Via Command Line:**

```bash
# Masuk ke MySQL
mysql -u root

# Buat database
CREATE DATABASE bps_cleaning_system;

# Keluar
exit;
```

#### Langkah 7: Konfigurasi Database di .env

**Edit file:** `backend/.env`

**Cari baris ini:**

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=laravel
DB_USERNAME=root
DB_PASSWORD=
```

**Ubah menjadi:**

```env
DB_CONNECTION=mysql
DB_HOST=127.0.0.1
DB_PORT=3306
DB_DATABASE=bps_cleaning_system
DB_USERNAME=root
DB_PASSWORD=
```

**Penjelasan:**

- `DB_DATABASE` → Nama database yang tadi dibuat
- `DB_USERNAME` → `root` (default XAMPP)
- `DB_PASSWORD` → Kosong (default XAMPP)

#### Langkah 8: Setup Firebase Admin SDK

**A. Download Service Account Key:**

1. Buka Firebase Console: https://console.firebase.google.com/
2. Pilih project: `bps-cleaning-system`
3. Klik icon ⚙️ (Settings) → Project Settings
4. Tab: **Service Accounts**
5. Klik: **Generate New Private Key**
6. Klik: **Generate Key** (file JSON akan terdownload)
7. **Rename file** menjadi: `firebase-service-account.json`

**B. Copy ke Backend:**

1. Copy file `firebase-service-account.json`
2. Paste ke: `backend/storage/`
3. Path lengkap: `C:\xampp\htdocs\bps-cleaning-system\backend\storage\firebase-service-account.json`

**C. Update .env:**

Edit `backend/.env`, tambahkan baris ini:

```env
FIREBASE_CREDENTIALS=storage/firebase-service-account.json
```

#### Langkah 9: Migrasi Database + Seeding Data

**Jalankan command ini:**

```bash
php artisan migrate:fresh --seed
```

**Penjelasan:**

- `migrate` → Buat tabel database
- `fresh` → Drop semua tabel dulu (kalau ada)
- `--seed` → Isi dengan data dummy untuk testing

**Tunggu proses selesai** (±1 menit).

**Hasilnya:**

- Tabel database terbuat
- User admin & petugas ter-create
- Data area & tasks ter-create

#### Langkah 10: Jalankan Laravel Server

```bash
php artisan serve
```

**Jika mau di network (bisa diakses HP lain):**

```bash
php artisan serve --host=0.0.0.0 --port=8000
```

**Output yang benar:**

```
Laravel development server started: http://127.0.0.1:8000
```

**Test di browser:**  
Buka http://127.0.0.1:8000/api/areas

**Hasilnya harus JSON** (daftar area):

```json
{
  "success": true,
  "data": [...]
}
```

**✅ Backend selesai! Jangan tutup CMD ini, biarkan server tetap jalan.**

---

### BAGIAN 2: Setup Frontend (Flutter)

**Buka terminal/CMD BARU** (jangan pakai yang sama dengan Laravel server).

#### Langkah 1: Masuk ke Root Project

```bash
cd C:\xampp\htdocs\bps-cleaning-system
```

#### Langkah 2: Install Dependencies Flutter

```bash
flutter pub get
```

**Tunggu proses download packages** (5-10 menit pertama kali).

#### Langkah 3: Setup Firebase untuk Android

**A. Download google-services.json:**

1. Buka Firebase Console: https://console.firebase.google.com/
2. Pilih project: `bps-cleaning-system`
3. Klik icon Android (tambah app Android)
4. **Android package name:** `com.example.bps_cleaning_system`
5. **App nickname:** `BPS Cleaning (Android)`
6. Register app
7. **Download** file `google-services.json`

**B. Copy ke Project:**

1. Copy file `google-services.json`
2. Paste ke: `android/app/`
3. Path lengkap: `C:\xampp\htdocs\bps-cleaning-system\android\app\google-services.json`

**C. Enable Cloud Messaging:**

1. Di Firebase Console → Project Settings
2. Tab: **Cloud Messaging**
3. Tab: **Cloud Messaging API (Legacy)** → Enable
4. **Selesai!**

#### Langkah 4: Update Base URL Backend

**Edit file:** `lib/config/environment.dart`

**Cari baris:**

```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```

**Ubah sesuai situasi:**

**A. Jika run di Android Emulator:**

```dart
static const String baseUrl = 'http://10.0.2.2:8000/api';
```

(10.0.2.2 = localhost di emulator)

**B. Jika run di HP fisik via WiFi:**

1. **Cek IP laptop:**

   - Buka CMD
   - Ketik: `ipconfig`
   - Cari: "Wireless LAN adapter Wi-Fi"
   - Copy IPv4 Address (contoh: 192.168.1.100)

2. **Update baseUrl:**

```dart
static const String baseUrl = 'http://192.168.1.100:8000/api';
```

**C. Jika run di iOS Simulator:**

```dart
static const String baseUrl = 'http://127.0.0.1:8000/api';
```

**PENTING:** Pastikan HP/Emulator dan laptop **dalam 1 jaringan WiFi yang sama**.

#### Langkah 5: Cek Device yang Tersedia

```bash
flutter devices
```

**Output contoh:**

```
OPPO CPH2521 (mobile) • e4998032 • android-arm64 • Android 15
sdk gphone64 arm64 (mobile) • emulator-5554 • android-x64 • Android API 34
```

**Jika tidak ada device:**

**A. Android Emulator:**

1. Buka Android Studio
2. Klik: AVD Manager (icon HP di toolbar)
3. Create Virtual Device:
   - Phone: Pixel 4
   - OS: Android 11 (API 30)
   - Finish
4. Klik ▶️ (Play) untuk start emulator

**B. HP Fisik (Android):**

1. **Di HP:**
   - Buka Settings → About Phone
   - Tap "Build Number" 7x (aktifkan Developer Mode)
   - Kembali → Developer Options
   - Enable: **USB Debugging**
2. **Hubungkan HP ke laptop via USB**
3. **Di HP:** Allow USB Debugging (popup)
4. **Test:** `flutter devices` (HP harus muncul)

#### Langkah 6: Clean Project (Opsional tapi Direkomendasikan)

```bash
flutter clean
flutter pub get
```

#### Langkah 7: Run Aplikasi!

**Run di device default:**

```bash
flutter run
```

**Run di device spesifik:**

```bash
flutter run -d <device_id>

# Contoh:
flutter run -d e4998032
flutter run -d emulator-5554
```

**Tunggu proses build** (5-10 menit pertama kali).

**Jika berhasil:**

- Aplikasi terbuka di HP/Emulator
- Muncul halaman Login
- **Coba login:**
  - Username: `admin`
  - Password: `password`

**✅ Frontend selesai! Aplikasi sudah jalan!**

---

## 🎯 Testing Aplikasi

### 1. Test Login

**Admin:**

- Username: `admin`
- Password: `password`
- Seharusnya masuk ke Dashboard Admin

**Petugas:**

- Username: `user1` (atau user2, user3)
- Password: `password`
- Seharusnya masuk ke Dashboard User

### 2. Test Fitur Admin

1. **Dashboard** → Lihat statistik
2. **Area** → Tambah/Edit/Hapus ruangan
3. **Petugas** → Tambah/Edit petugas baru
4. **Generate Tugas** → Klik tombol generate
5. **Laporan** → Lihat list laporan (kosong jika belum ada)

### 3. Test Fitur Petugas

1. **Dashboard** → Lihat tugas hari ini
2. **Klik area** → Lihat checklist
3. **Submit Laporan:**
   - Upload foto (min 1)
   - Centang checklist
   - Tambah catatan
   - Submit
4. **Riwayat** → Lihat laporan yang sudah disubmit

### 4. Test Push Notification

1. **Login sebagai Admin** di HP/Emulator pertama
2. **Login sebagai User** di HP/Emulator kedua
3. **User submit laporan**
4. **Admin approve laporan**
5. **User seharusnya dapat notifikasi!**

---

## 🐛 Troubleshooting (Cara Mengatasi Error)

### ❌ Error: "Connection refused" atau "Failed to connect"

**Penyebab:** Flutter tidak bisa konek ke backend.

**Solusi:**

1. **Cek Laravel server jalan:**

   - Buka CMD yang jalankan `php artisan serve`
   - Harus masih jalan dan tidak ada error

2. **Test backend di browser:**

   - Buka: `http://192.168.1.100:8000/api/areas` (ganti IP)
   - Harus return JSON

3. **Cek base URL di Flutter:**

   - Buka: `lib/config/environment.dart`
   - Pastikan IP sama dengan IP laptop
   - Format: `http://IP:8000/api` (harus ada `/api`)

4. **Cek Firewall:**

   - Windows Firewall mungkin block port 8000
   - Allow akses untuk PHP di Firewall settings

5. **Pastikan 1 WiFi:**
   - HP dan Laptop harus connect ke WiFi yang SAMA
   - Jangan pakai mobile data di HP

### ❌ Error: "Gradle build failed"

**Solusi 1: Clean & Rebuild**

```bash
cd android
./gradlew clean
cd ..
flutter clean
flutter pub get
flutter run
```

**Solusi 2: Update Gradle (jika masih error)**

1. Edit `android/gradle/wrapper/gradle-wrapper.properties`
2. Ubah `distributionUrl` jadi:
   ```
   distributionUrl=https\://services.gradle.org/distributions/gradle-7.5-all.zip
   ```

### ❌ Error: "google-services.json not found"

**Solusi:**

1. Pastikan file `google-services.json` ada di `android/app/`
2. Jangan taruh di `android/` saja (harus masuk folder `app/`)
3. Jalankan `flutter clean` lalu `flutter run` lagi

### ❌ Error: "Firebase not initialized"

**Solusi:**

1. Pastikan `google-services.json` sudah di-copy
2. Buka Firebase Console → Project Settings → General
3. Pastikan package name sama: `com.example.bps_cleaning_system`
4. Clean project: `flutter clean && flutter pub get`

### ❌ Error: "composer: command not found"

**Solusi:**

1. Tutup semua CMD/PowerShell
2. Buka CMD/PowerShell **BARU** (sebagai Administrator)
3. Test: `composer --version`
4. Jika masih error, **restart laptop** (Environment Variables belum ke-load)

### ❌ Error: "SQLSTATE[HY000] [1045] Access denied for user"

**Penyebab:** Database credentials salah.

**Solusi:**

1. Edit `backend/.env`
2. Cek:
   ```env
   DB_DATABASE=bps_cleaning_system  # Nama database harus sama
   DB_USERNAME=root
   DB_PASSWORD=                      # Kosongkan (default XAMPP)
   ```
3. Cek database ada: Buka http://localhost/phpmyadmin
4. Jalankan lagi: `php artisan migrate:fresh --seed`

### ❌ Error: "Class 'ZipArchive' not found"

**Solusi:**

1. Buka `C:\xampp\php\php.ini`
2. Cari baris: `;extension=zip`
3. Hapus `;` (uncomment): `extension=zip`
4. Save file
5. Restart XAMPP Apache

### ❌ Notifikasi Tidak Masuk

**Solusi:**

1. **Cek FCM Token tersimpan:**

   - Login di app
   - Buka database: `bps_cleaning_system` → tabel `users`
   - Kolom `fcm_token` harus terisi (panjang ~150 karakter)

2. **Cek Firebase Service Account:**

   - File `firebase-service-account.json` harus ada di `backend/storage/`
   - Path di `.env` harus benar

3. **Cek Firebase Console:**

   - Cloud Messaging API harus enable
   - Project harus punya Server Key

4. **Cek log backend:**
   - Buka: `backend/storage/logs/laravel.log`
   - Cari error terkait FCM

### ❌ Hot Reload Tidak Bekerja

**Solusi:**

- Ketik `r` di terminal → Hot reload
- Ketik `R` di terminal → Hot restart (full restart)
- Atau stop app (`q`) lalu run lagi

---

## 📱 Run di Device Fisik (HP Android)

### Persiapan HP

1. **Enable Developer Mode:**

   - Settings → About Phone
   - Tap "Build Number" **7 kali**
   - Muncul toast "You are now a developer!"

2. **Enable USB Debugging:**

   - Settings → System → Developer Options
   - Toggle ON: **USB Debugging**
   - Toggle ON: **Install via USB** (jika ada)

3. **Hubungkan ke Laptop:**

   - Pakai kabel USB (original lebih baik)
   - Pilih mode: **File Transfer / MTP**
   - Allow USB Debugging di HP (popup)

4. **Verify Device:**

   ```bash
   flutter devices
   ```

   HP harus muncul di list.

5. **Run:**
   ```bash
   flutter run -d <device_id>
   ```

### Tips WiFi Debugging (Tanpa Kabel)

**Setelah terhubung via USB sekali:**

```bash
# Di terminal
adb tcpip 5555
adb connect <IP_HP>:5555

# Contoh:
adb connect 192.168.1.105:5555

# Cabut kabel USB
# Run app
flutter run
```

---

## 🔄 Update Project (Pull Latest Changes)

**Jika ada update dari GitHub:**

### Backend:

```bash
cd C:\xampp\htdocs\bps-cleaning-system\backend

# Pull changes
git pull origin frontend

# Update dependencies
composer update

# Migrate database (jika ada perubahan)
php artisan migrate

# Clear cache
php artisan config:clear
php artisan cache:clear
```

### Frontend:

```bash
cd C:\xampp\htdocs\bps-cleaning-system

# Pull changes
git pull origin frontend

# Update dependencies
flutter pub get

# Clean & rebuild
flutter clean
flutter run
```

---

## 📦 Build APK untuk Production

### Debug APK (untuk testing):

```bash
flutter build apk --debug
```

**Location:** `build/app/outputs/flutter-apk/app-debug.apk`

### Release APK (untuk distribute):

```bash
flutter build apk --release
```

**Location:** `build/app/outputs/flutter-apk/app-release.apk`

**File size:** ±20-30 MB

**Install di HP:**

1. Copy file APK ke HP
2. Buka file APK di HP
3. Install (izinkan "Install from Unknown Sources")

---

## ✅ Checklist Instalasi

Centang setiap langkah yang sudah selesai:

### Persiapan

- [ ] XAMPP terinstall & MySQL jalan
- [ ] Composer terinstall (`composer --version` jalan)
- [ ] Flutter SDK terinstall (`flutter --version` jalan)
- [ ] Android Studio terinstall (ada emulator atau HP fisik siap)
- [ ] Firebase project sudah dibuat
- [ ] `google-services.json` sudah di-download
- [ ] `firebase-service-account.json` sudah di-download

### Backend

- [ ] Project sudah di-clone/download
- [ ] `composer install` berhasil
- [ ] File `.env` sudah di-copy dan dikonfigurasi
- [ ] Database `bps_cleaning_system` sudah dibuat
- [ ] `firebase-service-account.json` ada di `backend/storage/`
- [ ] `php artisan migrate:fresh --seed` berhasil
- [ ] Laravel server jalan (`php artisan serve`)
- [ ] Test API di browser return JSON

### Frontend

- [ ] `flutter pub get` berhasil
- [ ] `google-services.json` ada di `android/app/`
- [ ] `environment.dart` base URL sudah disesuaikan
- [ ] Device/Emulator terdetect (`flutter devices`)
- [ ] `flutter run` berhasil
- [ ] App terbuka di device
- [ ] Login berhasil (admin/password)

### Testing

- [ ] Admin bisa login
- [ ] User bisa login
- [ ] Admin bisa generate tugas
- [ ] User bisa submit laporan
- [ ] Admin bisa approve/reject laporan
- [ ] Notifikasi masuk ke device user

---

## 🎉 Selamat!

Jika semua checklist tercentang, **instalasi sukses!**

Aplikasi BPS Cleaning System siap digunakan.

---

## 💬 Butuh Bantuan?

Jika ada kendala yang tidak tercantum di troubleshooting:

1. **Cek Log Error:**

   - Backend: `backend/storage/logs/laravel.log`
   - Flutter: Terminal output saat run

2. **Screenshot Error** dan kirim ke tim support

3. **Kontak:**
   - Email: support@bpscleaning.com
   - WhatsApp: +62-xxx-xxxx-xxxx

---

**Happy Coding! 🚀**
