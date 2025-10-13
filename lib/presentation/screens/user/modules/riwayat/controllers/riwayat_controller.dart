import 'package:get/get.dart';

class RiwayatController extends GetxController {
  var isLoading = false.obs;
  var historyList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadHistoryData();
  }

  Future<void> loadHistoryData() async {
    try {
      isLoading.value = true;
      // TODO: Load actual history data from API
      await Future.delayed(const Duration(seconds: 1));
      historyList.clear(); // Placeholder - empty for now
    } catch (e) {
      print('Error loading history data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshData() async {
    await loadHistoryData();
  }
}
