@echo off
echo ================================================
echo  Membersihkan Semua Cache Flutter & Gradle
echo ================================================
echo.

echo [1/6] Stopping Gradle Daemon...
cd android
call gradlew --stop
cd ..

echo [2/6] Flutter Clean...
call flutter clean

echo [3/6] Menghapus Build Folders...
if exist "build" rmdir /s /q "build"
if exist "android\.gradle" rmdir /s /q "android\.gradle"
if exist "android\build" rmdir /s /q "android\build"
if exist "android\app\build" rmdir /s /q "android\app\build"

echo [4/6] Menghapus Kotlin Cache...
if exist "%USERPROFILE%\.gradle\caches" rmdir /s /q "%USERPROFILE%\.gradle\caches"

echo [5/6] Flutter Pub Get...
call flutter pub get

echo [6/6] Selesai!
echo.
echo ================================================
echo  Clean berhasil! Sekarang jalankan: flutter run
echo ================================================
pause

