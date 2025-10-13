import 'package:get/get.dart';
import '../../../../../../services/api_service.dart';

// Area Model
class Area {
  final int id;
  final String name;
  final String lantai;
  final String nomorRuangan;
  final List<String> kebersihan;
  final String keterangan;
  final bool isActive;
  final int reportCount;
  final DateTime createdAt;

  Area({
    required this.id,
    required this.name,
    required this.lantai,
    required this.nomorRuangan,
    required this.kebersihan,
    required this.keterangan,
    this.isActive = true,
    this.reportCount = 0,
    required this.createdAt,
  });

  String get description => keterangan; // For compatibility

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(
      id: json['id'],
      name: json['name'],
      lantai: json['lantai'].toString(),
      nomorRuangan: json['nomorRuangan'].toString(),
      kebersihan: List<String>.from(json['kebersihan'] ?? []),
      keterangan: json['keterangan'] ?? '',
      isActive: json['isActive'] ?? true,
      reportCount: json['reportCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Area copyWith({
    int? id,
    String? name,
    String? lantai,
    String? nomorRuangan,
    List<String>? kebersihan,
    String? keterangan,
    bool? isActive,
    int? reportCount,
    DateTime? createdAt,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      lantai: lantai ?? this.lantai,
      nomorRuangan: nomorRuangan ?? this.nomorRuangan,
      kebersihan: kebersihan ?? this.kebersihan,
      keterangan: keterangan ?? this.keterangan,
      isActive: isActive ?? this.isActive,
      reportCount: reportCount ?? this.reportCount,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

class AreaController extends GetxController {
  // Reactive Variables
  final RxList<Area> areaList = <Area>[].obs;
  final RxString searchQuery = ''.obs;
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool showActiveOnly = true.obs;

  // Filtered areas based on search and status
  List<Area> get filteredAreas {
    var filtered = areaList.toList();

    // Filter by active status
    if (showActiveOnly.value) {
      filtered = filtered.where((area) => area.isActive).toList();
    }

    // Filter by search query
    if (searchQuery.value.isNotEmpty) {
      filtered = filtered.where((area) {
        return area.name.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            ) ||
            area.description.toLowerCase().contains(
              searchQuery.value.toLowerCase(),
            );
      }).toList();
    }

    return filtered;
  }

  @override
  void onInit() {
    super.onInit();
    loadAreas();
  }

  // Load all areas
  Future<void> loadAreas() async {
    try {
      isLoading.value = true;
      errorMessage.value = '';

      // API call to get areas
      final response = await ApiService.getAreas(search: searchQuery.value);

      if (response['success']) {
        final List<dynamic> areasData = response['data'];
        final areas = areasData.map((json) => Area.fromJson(json)).toList();
        areaList.assignAll(areas);
      } else {
        errorMessage.value = response['message'] ?? 'Failed to load areas';
      }
    } catch (e) {
      errorMessage.value = 'Gagal memuat area: ${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchAreas(String query) {
    searchQuery.value = query;
    loadAreas(); // Reload with new search
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
    loadAreas(); // Reload without search
  }

  // Toggle active filter
  void toggleActiveFilter() {
    showActiveOnly.value = !showActiveOnly.value;
  }

  // Add new area
  Future<bool> addArea(
    String name,
    String lantai,
    String nomorRuangan,
    List<String> kebersihan,
    String keterangan,
  ) async {
    try {
      isLoading.value = true;

      print('DEBUG: Attempting to create area with data:');
      print('Name: $name');
      print('Lantai: $lantai');
      print('Nomor Ruangan: $nomorRuangan');
      print('Kebersihan: $kebersihan');
      print('Keterangan: $keterangan');

      // API call to create area
      final response = await ApiService.createArea(
        name: name,
        lantai: lantai,
        nomorRuangan: nomorRuangan,
        kebersihan: kebersihan,
        keterangan: keterangan,
      );

      print('DEBUG: API Response: $response');

      if (response['success']) {
        print('DEBUG: Area created successfully, reloading areas...');
        // Reload areas to get updated list
        await loadAreas();
        return true;
      } else {
        print('DEBUG: API returned error: ${response['message']}');
        errorMessage.value = response['message'] ?? 'Failed to create area';
        return false;
      }
    } catch (e) {
      print('DEBUG: Exception caught: $e');
      errorMessage.value = 'Gagal menambah area: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update area
  Future<bool> updateArea(
    int areaId,
    String name,
    String lantai,
    String nomorRuangan,
    List<String> kebersihan,
    String keterangan,
  ) async {
    try {
      isLoading.value = true;

      // API call to update area
      final response = await ApiService.updateArea(
        id: areaId,
        name: name,
        lantai: lantai,
        nomorRuangan: nomorRuangan,
        kebersihan: kebersihan,
        keterangan: keterangan,
      );

      if (response['success']) {
        // Reload areas to get updated list
        await loadAreas();
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to update area';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal update area: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle area status
  Future<bool> toggleAreaStatus(int areaId) async {
    try {
      isLoading.value = true;

      // For now, just toggle locally - can be implemented with API later
      final areaIndex = areaList.indexWhere((area) => area.id == areaId);
      if (areaIndex != -1) {
        final updatedArea = areaList[areaIndex].copyWith(
          isActive: !areaList[areaIndex].isActive,
        );
        areaList[areaIndex] = updatedArea;
        return true;
      }
      return false;
    } catch (e) {
      errorMessage.value = 'Gagal update status area: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete area
  Future<bool> deleteArea(int areaId) async {
    try {
      isLoading.value = true;

      // API call to delete area
      final response = await ApiService.deleteArea(areaId);

      if (response['success']) {
        // Reload areas to get updated list
        await loadAreas();
        return true;
      } else {
        errorMessage.value = response['message'] ?? 'Failed to delete area';
        return false;
      }
    } catch (e) {
      errorMessage.value = 'Gagal hapus area: ${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Get area statistics
  Map<String, int> get areaStatistics {
    final total = areaList.length;
    final active = areaList.where((area) => area.isActive).length;
    final inactive = total - active;
    final totalReports = areaList.fold(
      0,
      (sum, area) => sum + area.reportCount,
    );

    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'totalReports': totalReports,
    };
  }
}
