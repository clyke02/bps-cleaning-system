import 'package:get/get.dart';

// Area Model
class Area {
  final int id;
  final String name;
  final String description;
  final bool isActive;
  final int reportCount;
  final DateTime createdAt;

  Area({
    required this.id,
    required this.name,
    required this.description,
    this.isActive = true,
    this.reportCount = 0,
    required this.createdAt,
  });

  Area copyWith({
    int? id,
    String? name,
    String? description,
    bool? isActive,
    int? reportCount,
    DateTime? createdAt,
  }) {
    return Area(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
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
        return area.name.toLowerCase().contains(searchQuery.value.toLowerCase()) ||
               area.description.toLowerCase().contains(searchQuery.value.toLowerCase());
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
      
      // Simulate API call delay
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Load sample data (replace with actual API call)
      final areas = _getSampleAreas();
      areaList.assignAll(areas);
      
    } catch (e) {
      errorMessage.value = 'Gagal memuat area: \${e.toString()}';
    } finally {
      isLoading.value = false;
    }
  }

  // Search functionality
  void searchAreas(String query) {
    searchQuery.value = query;
  }

  // Clear search
  void clearSearch() {
    searchQuery.value = '';
  }

  // Toggle active filter
  void toggleActiveFilter() {
    showActiveOnly.value = !showActiveOnly.value;
  }

  // Add new area
  Future<bool> addArea(String name, String description) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final newArea = Area(
        id: DateTime.now().millisecondsSinceEpoch,
        name: name,
        description: description,
        createdAt: DateTime.now(),
      );
      
      areaList.add(newArea);
      return true;
      
    } catch (e) {
      errorMessage.value = 'Gagal menambah area: \${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Update area
  Future<bool> updateArea(int areaId, String name, String description) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      final areaIndex = areaList.indexWhere((area) => area.id == areaId);
      if (areaIndex != -1) {
        final updatedArea = areaList[areaIndex].copyWith(
          name: name,
          description: description,
        );
        areaList[areaIndex] = updatedArea;
        return true;
      }
      return false;
      
    } catch (e) {
      errorMessage.value = 'Gagal update area: \${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Toggle area status
  Future<bool> toggleAreaStatus(int areaId) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
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
      errorMessage.value = 'Gagal update status area: \${e.toString()}';
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  // Delete area
  Future<bool> deleteArea(int areaId) async {
    try {
      isLoading.value = true;
      
      // Simulate API call
      await Future.delayed(const Duration(milliseconds: 1000));
      
      areaList.removeWhere((area) => area.id == areaId);
      return true;
      
    } catch (e) {
      errorMessage.value = 'Gagal hapus area: \${e.toString()}';
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
    final totalReports = areaList.fold(0, (sum, area) => sum + area.reportCount);
    
    return {
      'total': total,
      'active': active,
      'inactive': inactive,
      'totalReports': totalReports,
    };
  }

  // Sample data
  List<Area> _getSampleAreas() {
    return [
      Area(
        id: 1,
        name: 'Ruang Rapat',
        description: 'Ruang rapat utama lantai 1',
        reportCount: 5,
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      Area(
        id: 2,
        name: 'Toilet',
        description: 'Toilet umum lantai 1 dan 2',
        reportCount: 12,
        createdAt: DateTime.now().subtract(const Duration(days: 25)),
      ),
      Area(
        id: 3,
        name: 'Dapur',
        description: 'Dapur kantin dan pantry',
        reportCount: 8,
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      Area(
        id: 4,
        name: 'Mushola',
        description: 'Mushola kantor lantai 3',
        reportCount: 3,
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      Area(
        id: 5,
        name: 'Lobby Utama',
        description: 'Area lobby dan resepsionis',
        reportCount: 15,
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      Area(
        id: 6,
        name: 'Ruang Meeting',
        description: 'Ruang meeting lantai 2',
        reportCount: 7,
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];
  }
}