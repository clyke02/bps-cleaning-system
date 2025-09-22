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

## Troubleshooting

- Jalankan `flutter clean && flutter pub get` jika terjadi error build aneh.
- Periksa `flutter doctor` untuk dependensi yang hilang.
- Pada Windows, pastikan PowerShell memiliki izin eksekusi bila skrip diperlukan.

## Referensi

- Dokumentasi Flutter: `https://docs.flutter.dev/`
- Dart Packages: `https://pub.dev/`
