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
import 'package:bps_cleaning_system/shared/widgets/custom_snackbar.dart';

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
          cleaningTasks.value = (data['data'] as List).cast<Map<String, dynamic>>();

          // Reset completed tasks
          completedTasks.clear();
        } else {
          cleaningTasks.clear();
          CustomSnackbar.showInfo(title: 'Info', message: 'Tidak ada tugas pembersihan untuk area ini');
        }
      } else {
        CustomSnackbar.showError(title: 'Error', message: 'Gagal memuat tugas pembersihan');
      }
    } catch (e) {
      print('Error loading cleaning tasks: $e');
      CustomSnackbar.showError(title: 'Error', message: 'Terjadi kesalahan: ${e.toString()}');
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
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Maksimal 5 foto yang dapat diupload');
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
          CustomSnackbar.showWarning(title: 'Peringatan', message: 'Ukuran file tidak boleh lebih dari 5MB');
          return;
        }

        photoBukti.add(imageFile);
        CustomSnackbar.showSuccess(title: 'Sukses', message: 'Foto berhasil ditambahkan');
      }
    } catch (e) {
      print('Error picking image: $e');
      CustomSnackbar.showError(title: 'Error', message: 'Gagal mengambil foto: ${e.toString()}');
    }
  }

  Future<void> pickImageFromGallery() async {
    if (photoBukti.length >= 5) {
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Maksimal 5 foto yang dapat diupload');
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
          CustomSnackbar.showWarning(title: 'Peringatan', message: 'Ukuran file tidak boleh lebih dari 5MB');
          return;
        }

        photoBukti.add(imageFile);
        CustomSnackbar.showSuccess(title: 'Sukses', message: 'Foto berhasil ditambahkan');
      }
    } catch (e) {
      print('Error picking image: $e');
      CustomSnackbar.showError(title: 'Error', message: 'Gagal mengambil foto: ${e.toString()}');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photoBukti.length) {
      photoBukti.removeAt(index);
    }
  }

  Future<void> submitCleaningReport() async {
    if (selectedArea.value == null) {
      CustomSnackbar.showError(title: 'Error', message: 'Area tidak ditemukan');
      return;
    }

    if (completedTasks.isEmpty) {
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Pilih setidaknya satu tugas yang telah diselesaikan');
      return;
    }

    if (photoBukti.isEmpty) {
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Upload minimal satu foto bukti pembersihan');
      return;
    }

    if (catatanController.text.trim().isEmpty) {
      CustomSnackbar.showWarning(title: 'Peringatan', message: 'Catatan pembersihan harus diisi');
      return;
    }

    try {
      isLoading.value = true;

      // Get user data from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final userId = prefs.getInt('user_id');

      if (userId == null) {
        CustomSnackbar.showError(title: 'Error', message: 'Data user tidak ditemukan. Silakan login ulang.');
        return;
      }

      // Create multipart request
      final request = http.MultipartRequest('POST', Uri.parse('${Environment.baseUrl}/cleaning-reports'));

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
        final multipartFile = await http.MultipartFile.fromPath('photos[]', file.path);
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
          CustomSnackbar.showSuccess(title: 'Sukses', message: 'Laporan pembersihan berhasil dikirim');

          // Clear form
          clearForm();

          // Refresh home data to show updated status - WAIT for it
          if (Get.isRegistered<HomeController>()) {
            await Get.find<HomeController>().refreshData();
          }
        } else {
          CustomSnackbar.showError(title: 'Error', message: data['message'] ?? 'Gagal mengirim laporan');
        }
      } else {
        final errorData = json.decode(responseBody);
        CustomSnackbar.showError(title: 'Error', message: errorData['message'] ?? 'Gagal mengirim laporan pembersihan');
      }
    } catch (e) {
      print('Error submitting report: $e');
      CustomSnackbar.showError(title: 'Error', message: 'Terjadi kesalahan: ${e.toString()}');
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
