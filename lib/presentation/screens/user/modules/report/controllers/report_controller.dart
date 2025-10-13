import 'package:get/get.dart';

class ReportController extends GetxController {
  var isLoading = false.obs;
  var taskCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadTaskData();
  }

  Future<void> loadTaskData() async {
    try {
      isLoading.value = true;
      // TODO: Load actual task data from API
      await Future.delayed(const Duration(seconds: 1));
      taskCount.value = 0; // Placeholder
    } catch (e) {
      print('Error loading task data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadTaskData();
  }
}
