# 📱 Cara Konfigurasi IP Address untuk Development

## 🎯 Tujuan

Memudahkan switching antara Android Emulator dan Device Fisik tanpa harus mengubah banyak file.

---

## ⚙️ Konfigurasi

### File: `lib/config/environment.dart`

Ada **2 pengaturan utama**:

### 1️⃣ **IP Address PC Anda** (untuk device fisik)

```dart
static const String localNetworkIP = '192.168.1.100'; // ⚠️ GANTI DENGAN IP PC ANDA!
```

**Cara cek IP PC:**

#### Windows:

```bash
ipconfig
```

Cari **IPv4 Address** pada WiFi/Ethernet adapter

#### Mac/Linux:

```bash
ifconfig
# atau
ip addr show
```

Contoh hasil: `192.168.1.100` ← Copy IP ini!

---

### 2️⃣ **Mode Switch** (Emulator atau Device)

```dart
static const bool useEmulator = true; // ⚠️ UBAH INI!
```

- `true` = Menggunakan Emulator
- `false` = Menggunakan Device Fisik

---

## 🚀 Cara Pakai

### Menggunakan Android Emulator:

1. Buka `lib/config/environment.dart`
2. Set:
   ```dart
   static const bool useEmulator = true;
   ```
3. Jalankan Laravel server: `php artisan serve`
4. Run aplikasi: `flutter run`

### Menggunakan Device Fisik:

1. **Cek IP PC** (lihat cara di atas)
2. Buka `lib/config/environment.dart`
3. Ubah IP:
   ```dart
   static const String localNetworkIP = '192.168.1.XXX'; // IP PC Anda
   ```
4. Set mode:
   ```dart
   static const bool useEmulator = false;
   ```
5. **Pastikan PC dan HP terhubung ke WiFi yang sama!**
6. Jalankan Laravel server:
   ```bash
   php artisan serve --host=0.0.0.0 --port=8000
   ```
7. Run aplikasi: `flutter run`

---

## 🔍 Debug Info

Saat aplikasi dijalankan, akan muncul log di console:

```
═══════════════════════════════════════
📱 Environment Configuration
═══════════════════════════════════════
Mode: Android Emulator
Base URL: http://10.0.2.2:8000/api
Local IP: 192.168.1.100
═══════════════════════════════════════
```

Ini membantu Anda memastikan konfigurasi yang sedang digunakan.

---

## ✅ Checklist

### Untuk Emulator:

- [ ] Set `useEmulator = true`
- [ ] Laravel server berjalan: `php artisan serve`
- [ ] URL akan otomatis: `http://10.0.2.2:8000/api`

### Untuk Device Fisik:

- [ ] Set `useEmulator = false`
- [ ] Cek IP PC dan update `localNetworkIP`
- [ ] PC dan HP di WiFi yang sama
- [ ] Laravel server: `php artisan serve --host=0.0.0.0`
- [ ] Cek firewall PC (port 8000 harus terbuka)
- [ ] URL akan: `http://[IP-PC-ANDA]:8000/api`

---

## 🐛 Troubleshooting

### Error: Connection refused

- **Emulator**: Pastikan Laravel berjalan di `http://127.0.0.1:8000`
- **Device**: Pastikan:
  1. IP PC benar
  2. WiFi sama
  3. Laravel running dengan `--host=0.0.0.0`
  4. Firewall tidak memblokir port 8000

### Error: Timeout

- Cek koneksi internet/WiFi
- Restart Laravel server
- Restart aplikasi Flutter (Hot Restart `R`)

---

## 📝 Catatan Penting

1. **Jangan lupa** ganti `useEmulator` saat switch antara emulator dan device
2. **IP Address bisa berubah** jika WiFi di-restart atau ganti jaringan
3. **Firewall Windows** mungkin memblokir koneksi dari device fisik
4. **Production** nanti ganti dengan domain/IP server real

---

## 🔥 Tips

- Gunakan IP Static di PC untuk konsistensi
- Bookmark IP PC untuk referensi cepat
- Test dulu dengan browser di HP: `http://[IP-PC]:8000/api/users`
  (Jika browser berhasil, Flutter juga akan berhasil)
