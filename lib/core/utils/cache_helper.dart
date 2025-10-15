import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 💾 Cache Helper untuk Optimisasi Performance
class CacheHelper {
  static const Duration _defaultCacheDuration = Duration(minutes: 5);

  /// Save data to cache with expiration
  static Future<bool> saveToCache({
    required String key,
    required dynamic data,
    Duration duration = _defaultCacheDuration,
  }) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cacheData = {
        'data': data,
        'timestamp': DateTime.now().millisecondsSinceEpoch,
        'duration': duration.inMilliseconds,
      };

      final jsonString = json.encode(cacheData);
      return await prefs.setString(key, jsonString);
    } catch (e) {
      print('Error saving to cache: $e');
      return false;
    }
  }

  /// Get data from cache if not expired
  static Future<dynamic> getFromCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonString = prefs.getString(key);

      if (jsonString == null) {
        return null;
      }

      final cacheData = json.decode(jsonString);
      final timestamp = cacheData['timestamp'] as int;
      final duration = cacheData['duration'] as int;

      final expirationTime = DateTime.fromMillisecondsSinceEpoch(
        timestamp,
      ).add(Duration(milliseconds: duration));

      // Check if cache is expired
      if (DateTime.now().isAfter(expirationTime)) {
        await clearCache(key);
        return null;
      }

      return cacheData['data'];
    } catch (e) {
      print('Error getting from cache: $e');
      return null;
    }
  }

  /// Clear specific cache
  static Future<bool> clearCache(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(key);
    } catch (e) {
      print('Error clearing cache: $e');
      return false;
    }
  }

  /// Clear all cache
  static Future<bool> clearAllCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Get all keys except user data
      final keys = prefs.getKeys();
      final cacheKeys = keys.where(
        (key) =>
            key.startsWith('cache_') ||
            key.startsWith('reports_') ||
            key.startsWith('areas_'),
      );

      for (final key in cacheKeys) {
        await prefs.remove(key);
      }

      return true;
    } catch (e) {
      print('Error clearing all cache: $e');
      return false;
    }
  }

  /// Check if cache exists and is valid
  static Future<bool> isCacheValid(String key) async {
    final data = await getFromCache(key);
    return data != null;
  }
}

/// 🔑 Cache Keys Constants
class CacheKeys {
  // Areas
  static const String areas = 'cache_areas';
  static const String areasList = 'cache_areas_list';

  // Reports
  static const String reports = 'cache_reports';
  static const String userReports = 'cache_user_reports';
  static const String reportStats = 'cache_report_stats';

  // Users
  static const String users = 'cache_users';
  static const String userProfile = 'cache_user_profile';

  // Statistics
  static const String weeklySummary = 'cache_weekly_summary';
  static const String dashboard = 'cache_dashboard';
}

/// 📊 Cache Manager untuk GetX Controllers
mixin CacheManager {
  /// Load data with cache
  Future<T?> loadWithCache<T>({
    required String cacheKey,
    required Future<T> Function() fetchData,
    Duration cacheDuration = const Duration(minutes: 5),
  }) async {
    // Try to get from cache first
    final cachedData = await CacheHelper.getFromCache(cacheKey);

    if (cachedData != null) {
      print('✅ Cache HIT: $cacheKey');
      return cachedData as T;
    }

    print('❌ Cache MISS: $cacheKey - Fetching fresh data');

    // Fetch fresh data
    try {
      final freshData = await fetchData();

      // Save to cache
      await CacheHelper.saveToCache(
        key: cacheKey,
        data: freshData,
        duration: cacheDuration,
      );

      return freshData;
    } catch (e) {
      print('Error loading data: $e');
      return null;
    }
  }

  /// Invalidate cache
  Future<void> invalidateCache(String cacheKey) async {
    print('🗑️ Invalidating cache: $cacheKey');
    await CacheHelper.clearCache(cacheKey);
  }

  /// Invalidate multiple caches
  Future<void> invalidateCaches(List<String> cacheKeys) async {
    for (final key in cacheKeys) {
      await invalidateCache(key);
    }
  }
}
