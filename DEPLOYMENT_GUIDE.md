# 📱 BPS Cleaning System - Panduan Deployment

## 🎯 Overview

Aplikasi ini memiliki **2 mode**:
- **Development**: Untuk testing di local (PC developer)
- **Production**: Untuk deployment ke server BPS

---

## 🔧 DEVELOPMENT MODE (Testing)

### Untuk Developer/Tester

**1. Setup Backend Laravel:**

```bash
cd backend
php artisan serve --host=0.0.0.0 --port=8000
```

**2. Konfigurasi Flutter (`lib/config/environment.dart`):**

```dart
static const String mode = 'development';  // Mode development
static const String localNetworkIP = 'IP_PC_ANDA';  // Ganti dengan IP PC
static const bool useEmulator = false;  // true = emulator, false = HP fisik
```

**3. Cek IP PC:**

- **Windows**: `ipconfig` → cari IPv4 Address
- **Mac/Linux**: `ifconfig` → cari inet

**4. Run App:**

```bash
flutter run -d <device_id>
```

---

## 🚀 PRODUCTION MODE (Deployment)

### Langkah-Langkah Deployment ke Server BPS

### **A. Setup Backend di Server**

**1. Install di Server BPS:**

```bash
# Transfer folder backend ke server
# Install dependencies
cd backend
composer install --optimize-autoloader --no-dev

# Setup .env
cp .env.example .env
php artisan key:generate

# Setup database
php artisan migrate --force

# Setup storage
php artisan storage:link
```

**2. Setup Webserver (Apache/Nginx):**

Contoh konfigurasi Nginx:

```nginx
server {
    listen 80;
    server_name api.bps-cleaning.local;
    root /var/www/bps-cleaning-backend/public;

    index index.php;

    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location ~ \.php$ {
        fastcgi_pass unix:/var/run/php/php8.2-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
    }
}
```

**3. Catat URL/IP Server:**

Misal server di: `http://192.168.1.100` atau `http://api.bps-cleaning.local`

---

### **B. Build Flutter App untuk Production**

**1. Update Config (`lib/config/environment.dart`):**

```dart
static const String mode = 'production';  // ⚠️ UBAH KE PRODUCTION!

// Ganti dengan IP/domain server BPS yang sebenarnya
static const String productionUrl = 'http://192.168.1.100:8000/api';
// Atau: 'http://api.bps-cleaning.local/api'
// Atau: 'https://api.bps-cleaning.com/api'
```

**2. Build APK Production:**

```bash
# Build APK
flutter build apk --release

# Atau build App Bundle (untuk Play Store)
flutter build appbundle --release
```

**3. APK Result:**

```
build/app/outputs/flutter-apk/app-release.apk
```

**4. Distribute ke User:**

- Copy APK ke semua HP petugas
- Install APK
- Semua petugas akan connect ke **server production yang sama**

---

## 📝 Checklist Deployment

### ✅ Backend
- [ ] Backend di-deploy ke server dengan IP/domain tetap
- [ ] Database sudah di-migrate
- [ ] Storage folder sudah di-link
- [ ] `.env` sudah dikonfigurasi (DB, Firebase Server Key)
- [ ] Server bisa diakses dari jaringan lokal/internet

### ✅ Frontend
- [ ] File `environment.dart` mode diubah ke `'production'`
- [ ] `productionUrl` diisi dengan IP/domain server yang benar
- [ ] Build APK dengan `flutter build apk --release`
- [ ] Test APK di minimal 2 HP berbeda
- [ ] Notifikasi Firebase sudah ditest

---

## 🔄 Switch Between Modes

### Development → Production:
```dart
// lib/config/environment.dart
static const String mode = 'production';  // Ubah dari 'development'
```

### Production → Development:
```dart
// lib/config/environment.dart
static const String mode = 'development';  // Ubah dari 'production'
```

---

## ⚠️ IMPORTANT NOTES

1. **Satu Server untuk Semua User**
   - Semua HP petugas connect ke server production yang sama
   - Tidak perlu ubah IP per HP
   - IP hanya di-set sekali saat build APK

2. **Server Harus Accessible**
   - Server harus bisa diakses dari semua HP petugas
   - Jika internal: pastikan semua HP dalam 1 jaringan
   - Jika internet: gunakan domain dan SSL

3. **Firebase Configuration**
   - `google-services.json` sudah ada di project
   - Backend `.env` harus ada `FIREBASE_SERVER_KEY`
   - Test notifikasi sebelum deploy

4. **Security**
   - Untuk production, gunakan HTTPS (SSL)
   - Set `.env` `APP_ENV=production`
   - Set `.env` `APP_DEBUG=false`

---

## 🆘 Troubleshooting

### "Timeout Exception"
- Pastikan server berjalan
- Cek IP/domain di `environment.dart` sudah benar
- Test akses server dari browser HP: `http://SERVER_IP:8000`

### "Connection Refused"
- Firewall mungkin memblokir port 8000
- Pastikan server listen ke `0.0.0.0`, bukan `127.0.0.1`

### "Notifikasi Tidak Masuk"
- Cek backend `.env` ada `FIREBASE_SERVER_KEY`
- Cek HP sudah dapat izin notifikasi
- Cek FCM token tersimpan di database

---

## 📞 Support

Jika ada masalah deployment, hubungi developer atau cek dokumentasi lengkap di folder `docs/`.

---

**Version**: 1.0.0  
**Last Updated**: Oktober 2025


