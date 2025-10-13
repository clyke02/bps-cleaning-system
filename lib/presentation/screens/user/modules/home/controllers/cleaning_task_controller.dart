import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:bps_cleaning_system/presentation/screens/admin/modules/area/controllers/area_controller.dart';
import 'package:bps_cleaning_system/config/environment.dart';
import 'package:bps_cleaning_system/presentation/screens/user/modules/home/controllers/home_controller.dart';

class CleaningTaskController extends GetxController {
  var isLoading = false.obs;
  var selectedArea = Rxn<Area>();
  var cleaningTasks = <Map<String, dynamic>>[].obs;
  var completedTasks = <int>[].obs;
  var photoBukti = <File>[].obs;
  var catatanController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  void setSelectedArea(Area area) {
    selectedArea.value = area;
    loadCleaningTasks(area.id);
  }

  Future<void> loadCleaningTasks(int areaId) async {
    try {
      isLoading.value = true;

      final response = await http.get(
        Uri.parse('${Environment.baseUrl}/area-cleaning-tasks/$areaId'),
        headers: {'Accept': 'application/json'},
      );

      print('Loading cleaning tasks response: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          cleaningTasks.value = (data['data'] as List)
              .cast<Map<String, dynamic>>();

          // Reset completed tasks
          completedTasks.clear();
        } else {
          cleaningTasks.clear();
          Get.snackbar('Info', 'Tidak ada tugas pembersihan untuk area ini');
        }
      } else {
        Get.snackbar('Error', 'Gagal memuat tugas pembersihan');
      }
    } catch (e) {
      print('Error loading cleaning tasks: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void toggleTaskCompletion(int taskId) {
    if (completedTasks.contains(taskId)) {
      completedTasks.remove(taskId);
    } else {
      completedTasks.add(taskId);
    }
  }

  Future<void> pickImage() async {
    if (photoBukti.length >= 5) {
      Get.snackbar('Peringatan', 'Maksimal 5 foto yang dapat diupload');
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
    if (photoBukti.length >= 5) {
      Get.snackbar('Peringatan', 'Maksimal 5 foto yang dapat diupload');
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

  Future<void> submitCleaningReport() async {
    if (selectedArea.value == null) {
      Get.snackbar('Error', 'Area tidak ditemukan');
      return;
    }

    if (completedTasks.isEmpty) {
      Get.snackbar(
        'Peringatan',
        'Pilih setidaknya satu tugas yang telah diselesaikan',
      );
      return;
    }

    if (photoBukti.isEmpty) {
      Get.snackbar('Peringatan', 'Upload minimal satu foto bukti pembersihan');
      return;
    }

    if (catatanController.text.trim().isEmpty) {
      Get.snackbar('Peringatan', 'Catatan pembersihan harus diisi');
      return;
    }

    try {
      isLoading.value = true;

      // Get user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        Get.snackbar(
          'Error',
          'Data user tidak ditemukan. Silakan login ulang.',
        );
        return;
      }

      // Create multipart request
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('${Environment.baseUrl}/cleaning-reports'),
      );

      // Add headers
      request.headers.addAll({'Accept': 'application/json'});

      // Add form fields
      request.fields.addAll({
        'area_id': selectedArea.value!.id.toString(),
        'user_id': userId.toString(),
        'area_name': selectedArea.value!.name,
        'lantai': selectedArea.value!.lantai,
        'nomor_ruangan': selectedArea.value!.nomorRuangan,
        'completed_task_ids': json.encode(completedTasks),
        'catatan_pembersihan': catatanController.text.trim(),
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

      print('Submitting cleaning report...');
      print('User ID: $userId');
      print('Area ID: ${selectedArea.value!.id}');
      print('Photos: ${photoBukti.length}');

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      print('Submit response: ${response.statusCode}');
      print('Response body: $responseBody');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = json.decode(responseBody);
        if (data['success'] == true) {
          // Close dialog first
          Get.back();

          // Show success message
          Get.snackbar(
            'Sukses',
            'Laporan pembersihan berhasil dikirim',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          );

          // Clear form
          clearForm();

          // Refresh home data to show updated status - WAIT for it
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().refreshData();
          }
        } else {
          Get.snackbar('Error', data['message'] ?? 'Gagal mengirim laporan');
        }
      } else {
        final errorData = json.decode(responseBody);
        Get.snackbar(
          'Error',
          errorData['message'] ?? 'Gagal mengirim laporan pembersihan',
        );
      }
    } catch (e) {
      print('Error submitting report: $e');
      Get.snackbar('Error', 'Terjadi kesalahan: ${e.toString()}');
    } finally {
      isLoading.value = false;
    }
  }

  void clearForm() {
    completedTasks.clear();
    photoBukti.clear();
    catatanController.clear();
    selectedArea.value = null;
    cleaningTasks.clear();
  }

  @override
  void onClose() {
    catatanController.dispose();
    super.onClose();
  }
}
