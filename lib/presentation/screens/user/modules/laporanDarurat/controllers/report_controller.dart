import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../../../../../config/environment.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;
  var isLoadingAreas = false.obs;
  var emergencyReports = <Map<String, dynamic>>[].obs;
  var availableAreas = <Map<String, dynamic>>[].obs;
  var selectedArea = Rxn<Map<String, dynamic>>();
  var photoBukti = <File>[].obs;
  var descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    loadAvailableAreas();
  }

  Future<void> loadAvailableAreas() async {
    try {
      isLoadingAreas.value = true;
      final baseUrl = Environment.baseUrl;
      print('Loading areas from: $baseUrl/areas');

      final response = await http
          .get(
            Uri.parse('$baseUrl/areas'),
            headers: {'Accept': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      print('Areas response: ${response.statusCode}');
      print('Areas body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          // Remove duplicates based on area id
          final List<Map<String, dynamic>> areas = (data['data'] as List)
              .cast<Map<String, dynamic>>();

          // Use a Set to track unique IDs and filter duplicates
          final seenIds = <int>{};
          final uniqueAreas = areas.where((area) {
            final id = area['id'] as int;
            if (seenIds.contains(id)) {
              return false; // Skip duplicate
            }
            seenIds.add(id);
            return true;
          }).toList();

          availableAreas.value = uniqueAreas;
          print('✅ Loaded ${uniqueAreas.length} unique areas');
        } else {
          availableAreas.clear();
        }
      } else {
        availableAreas.clear();
      }
    } catch (e) {
      print('Error loading areas: $e');
      availableAreas.clear();
    } finally {
      isLoadingAreas.value = false;
    }
  }

  void setSelectedArea(Map<String, dynamic>? area) {
    selectedArea.value = area;
  }

  Future<void> pickImage() async {
    if (photoBukti.length >= 3) {
      Get.snackbar('Peringatan', 'Maksimal 3 foto untuk laporan darurat');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.camera,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final File imageFile = File(image.path);

        // Check file size (max 5MB)
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          Get.snackbar('Peringatan', 'Ukuran file tidak boleh lebih dari 5MB');
          return;
        }

        photoBukti.add(imageFile);
        Get.snackbar('Sukses', 'Foto berhasil ditambahkan');
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Gagal mengambil foto: ${e.toString()}');
    }
  }

  Future<void> pickImageFromGallery() async {
    if (photoBukti.length >= 3) {
      Get.snackbar('Peringatan', 'Maksimal 3 foto untuk laporan darurat');
      return;
    }

    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 80,
        maxWidth: 1920,
        maxHeight: 1080,
      );

      if (image != null) {
        final File imageFile = File(image.path);

        // Check file size (max 5MB)
        final int fileSizeInBytes = await imageFile.length();
        final double fileSizeInMB = fileSizeInBytes / (1024 * 1024);

        if (fileSizeInMB > 5) {
          Get.snackbar('Peringatan', 'Ukuran file tidak boleh lebih dari 5MB');
          return;
        }

        photoBukti.add(imageFile);
        Get.snackbar('Sukses', 'Foto berhasil ditambahkan');
      }
    } catch (e) {
      print('Error picking image: $e');
      Get.snackbar('Error', 'Gagal mengambil foto: ${e.toString()}');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photoBukti.length) {
      photoBukti.removeAt(index);
    }
  }

  Future<void> submitEmergencyReport() async {
    if (selectedArea.value == null) {
      Get.snackbar('Peringatan', 'Pilih area yang akan dilaporkan');
      return;
    }

    if (descriptionController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Catatan petugas harus diisi');
      return;
    }

    if (photoBukti.isEmpty) {
      Get.snackbar('Peringatan', 'Upload minimal satu foto bukti');
      return;
    }

    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(
        'auth_token',
      ); // FIX: gunakan key yang benar
      final userId = prefs.getInt('user_id');
      final userName = prefs.getString('user_name');

      if (token == null || userId == null) {
        Get.snackbar(
          'Error',
          'Data user tidak ditemukan. Silakan login kembali.',
        );
        return;
      }

      final area = selectedArea.value!;

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Environment.baseUrl}/emergency-reports'),
      );

      // Add headers
      request.headers.addAll({
        'Authorization': 'Bearer $token',
        'Accept': 'application/json',
      });

      // Add form fields
      request.fields.addAll({
        'user_id': userId.toString(),
        'user_name': userName ?? 'Unknown',
        'area_id': area['id'].toString(),
        'area_name': area['name'] ?? '',
        'lantai': area['lantai']?.toString() ?? '',
        'no_ruangan': area['nomorRuangan']?.toString() ?? '',
        'catatan': descriptionController.text.trim(),
      });

      // Add photo files
      for (int i = 0; i < photoBukti.length; i++) {
        final file = photoBukti[i];
        final multipartFile = await http.MultipartFile.fromPath(
          'photos[]',
          file.path,
        );
        request.files.add(multipartFile);
      }

      print('Submitting emergency report...');
      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Submit response: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);
        if (data['success'] == true) {
          Get.snackbar(
            'Sukses',
            'Laporan darurat berhasil dikirim',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );
          clearForm();
        } else {
          Get.snackbar('Error', data['message'] ?? 'Gagal mengirim laporan');
        }
      } else {
        final errorData = json.decode(responseBody);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Gagal mengirim laporan darurat',
        );
      }
    } catch (e) {
      print('Error submitting emergency report: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    selectedArea.value = null;
    photoBukti.clear();
    descriptionController.clear();
  }

  Future<void> refreshData() async {
    await loadAvailableAreas();
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
