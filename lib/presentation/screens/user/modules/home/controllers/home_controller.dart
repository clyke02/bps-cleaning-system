// Core Dart libraries
import 'dart:async';
import 'dart:convert';

// External packages
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

// Internal imports
import '../../../../../../core/exports/app_exports.dart';

class HomeController extends GetxController {
  var userName = 'User'.obs;
  var userId = ''.obs;
  var isLoading = false.obs;
  var isLoadingAssignments = false.obs;
  var dailyAssignments = <DailyAssignment>[].obs;
  var lastRefreshDate = ''.obs;

  // Optimization: Debounce timer untuk prevent multiple API calls
  Timer? _debounceTimer;
  Timer? _periodicTimer;

  // Optimization: Cache untuk assignments (reduced timeout for more frequent updates)
  static const Duration _cacheTimeout = Duration(minutes: 2);
  DateTime? _lastAssignmentFetch;

  @override
  void onInit() {
    super.onInit();
    if (Environment.isDebug) {
      Environment.printConfig();
    }
    loadUserData();
    // Lazy load assignments after user data
    ever(userId, (_) {
      if (userId.value.isNotEmpty) {
        loadTodayAssignments();
      }
    });
    _startDailyRefreshCheck();
  }

  @override
  void onClose() {
    _debounceTimer?.cancel();
    _periodicTimer?.cancel();
    super.onClose();
  }

  Future<void> loadUserData() async {
    try {
      isLoading.value = true;
      final prefs = await SharedPreferences.getInstance();
      final name = prefs.getString('user_name');
      final id = prefs.getInt('user_id');

      if (name != null && name.isNotEmpty) {
        userName.value = name;
      }
      if (id != null) {
        userId.value = id.toString();
      }
    } catch (e) {
      if (Environment.isDebug) {
        print('Error loading user data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }

  // Load daily assignments dengan caching
  Future<void> loadTodayAssignments({bool forceRefresh = false}) async {
    if (userId.value.isEmpty) return;

    // Check cache validity
    if (!forceRefresh && _lastAssignmentFetch != null) {
      final timeDiff = DateTime.now().difference(_lastAssignmentFetch!);
      if (timeDiff < _cacheTimeout) {
        return; // Use cached data
      }
    }

    try {
      isLoadingAssignments.value = true;
      final today = DateTime.now().toIso8601String().split('T')[0]; // Format: YYYY-MM-DD
      final baseUrl = Environment.baseUrl;

      if (Environment.isDebug) {
        print('Loading today assignments from: $baseUrl/users/${userId.value}/assignments?date=$today');
      }

      final response = await http
          .get(
            Uri.parse('$baseUrl/users/${userId.value}/assignments?date=$today'),
            headers: {'Accept': 'application/json', 'Content-Type': 'application/json'},
          )
          .timeout(const Duration(seconds: 10));

      if (Environment.isDebug) {
        print('Response status: ${response.statusCode}');
        print('Response body: ${response.body}');
      }

      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        if (responseData['success'] == true) {
          final assignmentsData = responseData['data'] as List;
          dailyAssignments.value = assignmentsData.map((item) => DailyAssignment.fromJson(item)).toList();

          // Update cache timestamp
          _lastAssignmentFetch = DateTime.now();

          // Update last refresh date
          lastRefreshDate.value = today;
          await _saveLastRefreshDate(today);

          if (Environment.isDebug) {
            print('Loaded ${dailyAssignments.length} assignments for today');
          }
        } else {
          if (Environment.isDebug) {
            print('Failed to load assignments: ${responseData['message']}');
          }
        }
      } else {
        if (Environment.isDebug) {
          print('HTTP Error: ${response.statusCode}');
        }
      }
    } on TimeoutException {
      if (Environment.isDebug) {
        print('Request timeout loading assignments');
      }
    } catch (e) {
      if (Environment.isDebug) {
        print('Error loading today assignments: $e');
      }
    } finally {
      isLoadingAssignments.value = false;
    }
  }

  // Optimized refresh method with debouncing and cache clear
  Future<void> refreshAssignments() async {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(const Duration(milliseconds: 300), () {
      // Clear assignment cache to force fresh data
      _lastAssignmentFetch = null;
      loadTodayAssignments(forceRefresh: true);
    });
  }

  // Force refresh without debouncing (for manual refresh button)
  Future<void> forceRefreshAssignments() async {
    _lastAssignmentFetch = null;
    await loadTodayAssignments(forceRefresh: true);
  }

  // Auto refresh checker - reduced frequency
  void _startDailyRefreshCheck() {
    final today = DateTime.now().toIso8601String().split('T')[0];

    // Check if we need to refresh assignments
    if (lastRefreshDate.value.isEmpty || lastRefreshDate.value != today) {
      if (Environment.isDebug) {
        print('Date changed or first load, refreshing assignments...');
      }
      loadTodayAssignments(forceRefresh: true);
    }

    // Set up periodic check (every 30 minutes instead of frequent)
    _periodicTimer = Timer.periodic(const Duration(minutes: 30), (_) {
      final currentDate = DateTime.now().toIso8601String().split('T')[0];
      if (lastRefreshDate.value != currentDate) {
        loadTodayAssignments(forceRefresh: true);
      }
    });
  }

  Future<void> _saveLastRefreshDate(String date) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_assignment_refresh', date);
    } catch (e) {
      if (Environment.isDebug) {
        print('Error saving last refresh date: $e');
      }
    }
  }

  Future<void> _loadLastRefreshDate() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      lastRefreshDate.value = prefs.getString('last_assignment_refresh') ?? '';
    } catch (e) {
      if (Environment.isDebug) {
        print('Error loading last refresh date: $e');
      }
    }
  }

  // Get pending assignments count
  int get pendingAssignmentsCount {
    return dailyAssignments.where((assignment) => assignment.isPending).length;
  }

  // Get completed assignments count
  int get completedAssignmentsCount {
    return dailyAssignments.where((assignment) => assignment.isCompleted).length;
  }

  // Mark assignment as completed when report is submitted
  void markAssignmentCompleted(int areaId, int reportId) {
    final assignmentIndex = dailyAssignments.indexWhere(
      (assignment) => assignment.areaId == areaId && assignment.isPending,
    );

    if (assignmentIndex != -1) {
      final updatedAssignment = DailyAssignment(
        id: dailyAssignments[assignmentIndex].id,
        userId: dailyAssignments[assignmentIndex].userId,
        areaId: dailyAssignments[assignmentIndex].areaId,
        assignmentDate: dailyAssignments[assignmentIndex].assignmentDate,
        status: 'completed',
        reportId: reportId,
        notes: dailyAssignments[assignmentIndex].notes,
        createdAt: dailyAssignments[assignmentIndex].createdAt,
        updatedAt: DateTime.now(),
        user: dailyAssignments[assignmentIndex].user,
        area: dailyAssignments[assignmentIndex].area,
        report: dailyAssignments[assignmentIndex].report,
      );

      dailyAssignments[assignmentIndex] = updatedAssignment;
    }
  }

  // Combined refresh method - replaces the old one
  Future<void> refreshData() async {
    if (Environment.isDebug) {
      print('DEBUG: Refreshing home data...');
    }
    await Future.wait([loadUserData(), loadTodayAssignments(forceRefresh: true)]);
  }

  void clearData() {
    dailyAssignments.clear();
    isLoading.value = false;
    isLoadingAssignments.value = false;
    print('DEBUG: Home data cleared');
  }

  @override
  void onReady() {
    super.onReady();
    // Load initial data and set up daily refresh
    _loadLastRefreshDate().then((_) => _startDailyRefreshCheck());
  }
}
